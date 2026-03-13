#!/bin/zsh

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git)

source "$ZSH/oh-my-zsh.sh"

[ -f "$ZSH_CUSTOM/exports.zsh" ] && source "$ZSH_CUSTOM/exports.zsh"
[ -f "$ZSH_CUSTOM/aliases.zsh" ] && source "$ZSH_CUSTOM/aliases.zsh"
[ -f "$ZSH_CUSTOM/machine.zsh" ] && source "$ZSH_CUSTOM/machine.zsh"

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
elif command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if [ -f "$ZSH_CUSTOM/local.zsh" ]; then
  source "$ZSH_CUSTOM/local.zsh"
fi
