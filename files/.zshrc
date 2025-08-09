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

# Plugins
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
source $ZSH/oh-my-zsh.sh

# Basic config
ENABLE_CORRECTION="true"
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
alias ls='ls --color'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Remove fastfetch screen if terminal becomes too small
export TERM=xterm
check_terminal_size

# Lazy load nvm
typeset -ga __lazyLoadLabels=(nvm node npm npx pnpm yarn pnpx bun bunx)

__load-nvm() {
    export NVM_DIR="${NVM_DIR:-/usr/share/nvm}"

    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

__work() {
    for label in "${__lazyLoadLabels[@]}"; do
        unset -f $label
    done
    unset -v __lazyLoadLabels

    __load-nvm
    unset -f __load-nvm __work
}

for label in "${__lazyLoadLabels[@]}"; do
    eval "$label() { __work; $label \$@; }"
done
