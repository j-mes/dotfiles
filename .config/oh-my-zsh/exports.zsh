#!/bin/zsh
# ---------------------------------------------------------------------------
# Environment Exports
# Purpose: Centralize PATH and environment variable setup for toolchains.
# Notes: Order matters (prepend higher priority paths first). Keep lean.
# ---------------------------------------------------------------------------

# Volta (Node.js toolchain manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Homebrew
# export HOMEBREW_CASK_OPTS=--require-sha  # (Optional) Require SHA for casks.
export HOMEBREW_NO_INSECURE_REDIRECT=1     # Harden HTTP redirect handling.
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Rust toolchain (cargo)
export PATH="$HOME/.cargo/bin:$PATH"

# Dotfiles helper scripts (symlinked into ~/.config/scripts)
export PATH="$HOME/.config/scripts:$PATH"

# Local project binaries (Node.js) – allows `npx`-style executables to resolve first.
export PATH="node_modules/.bin:$PATH"
