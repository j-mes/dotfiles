#!/bin/zsh
# ---------------------------------------------------------------------------
# Environment Exports
# Purpose: Centralize PATH and environment variable setup for toolchains.
# Notes: Order matters (prepend higher priority paths first). Keep lean.
# ---------------------------------------------------------------------------

# Homebrew
# export HOMEBREW_CASK_OPTS=--require-sha  # (Optional) Require SHA for casks.
export HOMEBREW_NO_INSECURE_REDIRECT=1     # Harden HTTP redirect handling.

# Rust toolchain (cargo)
typeset -U path PATH
path=(
	/opt/homebrew/sbin
	/opt/homebrew/bin
	"$HOME/.cargo/bin"
	"$HOME/.config/scripts"
	node_modules/.bin
	$path
)
# Remove deprecated Volta path if inherited from parent shells/process managers.
path=(${path:#$HOME/.volta/bin})
export PATH
