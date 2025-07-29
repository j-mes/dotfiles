#!/bin/zsh
source ~/.zshrc

echo "# Starting upgrades…"
echo "## OhMyZsh upgrade starting"
omz update
echo "## OhMyZsh upgrade done"
echo "## Homebrew upgrades starting"
brew update
brew upgrade
brew upgrade --cask --greedy
echo "## Homebrew upgrades done"
echo "## macOS upgrades starting"
mas upgrade
echo "## macOS upgrades done"
echo "# Upgrades done"
