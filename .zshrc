export ZSH=~/.oh-my-zsh
export GPG_TTY=$(tty)

ZSH_CUSTOM=~/.config/oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(git heroku zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

if [ -f ~/.config/scripts/fzf.zsh ]; then
	source ~/.config/scripts/fzf.zsh
fi

if [ -f ~/.config/scripts/git-cleanup.sh ]; then
	alias git-cleanup="~/.config/scripts/git-cleanup.sh"
fi


eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Rebind Ctrl-R to our widget again (ensure override)
zle -N __fzf_history_filtered
bindkey '^R' __fzf_history_filtered
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.config/scripts:$PATH"
