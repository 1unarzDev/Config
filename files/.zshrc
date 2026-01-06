MAX_WIDTH=55
MAX_HEIGHT=10

tput cols | read WIDTH
tput lines | read HEIGHT
if [[ $WIDTH -gt $MAX_WIDTH ]] || [[ $HEIGHT -gt $MAX_HEIGHT ]]; then
    fastfetch 
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Install and load Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# nvm
export NVM_LAZY_LOAD=true

# Your plugins
zinit ice depth=1 
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit light romkatv/powerlevel10k
zinit light jeffreytse/zsh-vi-mode
zinit light lukechilds/zsh-nvm 
zinit light hlissner/zsh-autopair
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Vi-mode modification
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
ZVM_CLIPBOARD_COPY_CMD='wl-copy -n'
ZVM_CLIPBOARD_PASTE_CMD='wl-paste -n'

# Initialize completions
autoload -U compinit && compinit

# Basic config
setopt CORRECT
export LANG=en_US.UTF-8
export EDITOR='nvim'
export TERMINAL=kitty 
export TERMCMD="kitty"

clear_screen_clean() {
    tput civis
    clear
    zle reset-prompt 2>/dev/null 
    tput cnorm
}

# Function to check terminal size and clear if too small
check_terminal_size() {
    tput cols | read WIDTH
    tput lines | read HEIGHT

    if [[ $WIDTH -le $MAX_WIDTH ]] || [[ $HEIGHT -le $MAX_HEIGHT ]]; then
        clear_screen_clean
    fi
}

# Trap the SIGWINCH signal (triggered on terminal resize)
trap check_terminal_size SIGWINCH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Show hidden files in ls
setopt globdots

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Aliases
alias ls='ls --color -AFG'
alias mirror-update='sudo reflector --verbose --score 100 -l 50 -f 10 --sort rate --save /etc/pacman.d/mirrorlist' 
alias cpv="rsync -ah --info=progress2" 
alias big="du -a -BM | sort -n -r | head -n 10" 
alias ..="cd .."
alias svim="sudo -E -s nvim"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Remove fastfetch screen if terminal becomes too small
export TERM=xterm
check_terminal_size

source ~/.profile

# Mamba
if [[ ! -f "$HOME/.local/bin/micromamba" ]]; then
    echo "Micromamba not found. Installing automatically..."
    "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
fi

export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup

alias mamba='micromamba'

alias zinit_update="zinit self-update && zinit update --all"

alias device_access="sudo chmod a+w+r /dev/hidraw*"

export WINEDEBUG=-all

export PATH=$PATH:$HOME/ardupilot/Tools/autotest
export PATH=/usr/lib/ccache:$PATH
export PATH=$PATH:$HOME/ardupilot-gcc/bin

# lazy_conda_aliases=('conda')
# 
# load_conda() {
#   for lazy_conda_alias in $lazy_conda_aliases
#   do
#     unalias $lazy_conda_alias
#   done
# 
#   __conda_prefix="$HOME/miniconda3" # Set your conda Location
# 
#   # >>> conda initialize >>>
#   __conda_setup="$("$__conda_prefix/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
#   if [ $? -eq 0 ]; then
#       eval "$__conda_setup"
#   else
#       if [ -f "$__conda_prefix/etc/profile.d/conda.sh" ]; then
#           . "$__conda_prefix/etc/profile.d/conda.sh"
#       else
#           export PATH="$__conda_prefix/bin:$PATH"
#       fi
#   fi
#   unset __conda_setup
#   # <<< conda initialize <<<
# 
#   unset __conda_prefix
#   unfunction load_conda
# }
# 
# for lazy_conda_alias in $lazy_conda_aliases
# do
#   alias $lazy_conda_alias="load_conda && $lazy_conda_alias"
# done
# 
# export PATH="$HOME/miniconda3/bin:$PATH"
