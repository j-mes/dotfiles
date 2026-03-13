#!/bin/zsh

[ -f "$HOME/.config/oh-my-zsh/exports.zsh" ] && source "$HOME/.config/oh-my-zsh/exports.zsh"

print -P "%F{cyan}%B==============================%b%f"
print -P "%F{yellow}%B  Starting upgrades%b%f"
print -P "%F{cyan}%B==============================%b%f"

if command -v omz >/dev/null 2>&1; then
  print -P "%F{magenta}%B-> Updating Oh My Zsh%b%f"
  omz update
  print -P "%F{green}%BOK: Oh My Zsh%b%f"
else
  print -P "%F{red}%BSKIP: omz not found%b%f"
fi

if command -v brew >/dev/null 2>&1; then
  print -P "%F{magenta}%B-> Updating Homebrew%b%f"
  brew update
  print -P "%F{magenta}%B-> Upgrading Homebrew packages%b%f"
  brew upgrade
  print -P "%F{green}%BOK: Homebrew%b%f"
else
  print -P "%F{red}%BSKIP: brew not found%b%f"
fi

if command -v mas >/dev/null 2>&1; then
  print -P "%F{magenta}%B-> Upgrading App Store packages%b%f"
  mas upgrade
  print -P "%F{green}%BOK: mas%b%f"
else
  print -P "%F{red}%BSKIP: mas not found%b%f"
fi

print -P "%F{cyan}%B==============================%b%f"
print -P "%F{yellow}%B  Finished upgrades%b%f"
print -P "%F{cyan}%B==============================%b%f"
