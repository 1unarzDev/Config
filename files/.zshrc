MAX_WIDTH=45
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
zinit light romkatv/powerlevel10k
zinit light jeffreytse/zsh-vi-mode
zinit light lukechilds/zsh-nvm 
zinit load "zsh-users/zsh-syntax-highlighting"
zinit load "zsh-users/zsh-autosuggestions"
zinit load "zsh-users/zsh-completions"

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
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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

# Remove fastfetch screen if terminal becomes too small
export TERM=xterm
check_terminal_size

source ~/.profile
