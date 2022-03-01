export ZSH=~/.oh-my-zsh
export GPG_TTY=$(tty)

ZSH_CUSTOM=~/.config/oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(fnm git heroku)

source $ZSH/oh-my-zsh.sh

eval "$(fnm env --use-on-cd)"
eval "$(starship init zsh)"
