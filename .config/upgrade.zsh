#!/bin/zsh
# Upgrade Script for macOS Environment
# -------------------------------------
# This script updates Oh My Zsh, Homebrew packages, and Mac App Store apps.
# Run with: zsh ~/.config/upgrade.zsh

source ~/.zshrc

print -P "%F{cyan}%B==============================%b%f"
print -P "%F{yellow}%B  🚀 Starting Upgrades...%b%f"
print -P "%F{cyan}%B==============================%b%f"


# Upgrade Oh My Zsh
if command -v omz >/dev/null 2>&1; then
    print -P "%F{magenta}%B→ Upgrading Oh My Zsh...%b%f"
    omz update
    print -P "%F{green}%B✓ Oh My Zsh upgrade complete!%b%f"
else
    print -P "%F{red}%B✗ omz (Oh My Zsh CLI) not found! Skipping.%b%f"
fi


# Upgrade Homebrew
if command -v brew >/dev/null 2>&1; then
    print -P "%F{magenta}%B→ Updating Homebrew...%b%f"
    brew update
    print -P "%F{magenta}%B→ Upgrading Homebrew packages...%b%f"
    brew upgrade
    print -P "%F{green}%B✓ Homebrew upgrade complete!%b%f"
else
    print -P "%F{red}%B✗ brew (Homebrew) not found! Skipping.%b%f"
fi


# Upgrade Mac App Store apps
if command -v mas >/dev/null 2>&1; then
    print -P "%F{magenta}%B→ Upgrading Mac App Store apps...%b%f"
    mas upgrade
    print -P "%F{green}%B✓ Mac App Store upgrade complete!%b%f"
else
    print -P "%F{red}%B✗ mas (Mac App Store CLI) not found! Skipping.%b%f"
fi

print -P "%F{cyan}%B==============================%b%f"
print -P "%F{yellow}%B  🎉 All upgrades finished!%b%f"
print -P "%F{cyan}%B==============================%b%f"
