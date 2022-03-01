#!/bin/zsh
source ~/.zshrc

echo "# Starting upgrades…"
echo ""
echo "## OhMyZsh upgrade starting"
echo "##"
omz update
echo "##"
echo "## OhMyZsh upgrade done"
echo ""
echo ""
echo "## NodeJS upgrades starting"
echo "##"
fnm uninstall 16
fnm install 16
fnm default 16
n use
echo "##"
echo "## NodeJS upgrades done"
echo ""
echo ""
echo "## Homebrew upgrades starting"
echo "##"
brew update
brew upgrade
brew upgrade --cask --greedy
echo "##"
echo "## Homebrew upgrades done"
echo ""
echo ""
echo "## macOS upgrades starting"
echo "##"
mas upgrade
echo "##"
echo "## macOS upgrades done"
echo ""
echo "# Upgrades done"
