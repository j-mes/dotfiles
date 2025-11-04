#!/bin/zsh
# ---------------------------------------------------------------------------
# Zsh Configuration
# Loads Oh My Zsh, plugins, prompt, fuzzy finder, environment exports, and
# optional machine / private overrides. Keep this file lean; put logic into
# dedicated files under .config/oh-my-zsh/.
# ---------------------------------------------------------------------------

# Core paths / locations
export ZSH=~/.oh-my-zsh
ZSH_CUSTOM=~/.config/oh-my-zsh
# Theme & plugin selection
ZSH_THEME="robbyrussell"
# Enable plugins
plugins=(git)

# Machine-specific / optional integrations (VS Code, host tweaks, etc.)
[ -f "$ZSH_CUSTOM/machine.zsh" ] && source "$ZSH_CUSTOM/machine.zsh"

# Framework & prompt
source $ZSH/oh-my-zsh.sh

# Starship prompt (fast, configurable)
eval "$(starship init zsh)"

# fzf integration (key bindings + completion)
[ -f ~/.fzf.zsh ] \
	&& source ~/.fzf.zsh \
	|| { [ -x "$(command -v fzf 2>/dev/null)" ] && source <(fzf --zsh); }

# Environment exports (PATH, toolchain managers, etc.)
[ -f "$ZSH_CUSTOM/exports.zsh" ] && source "$ZSH_CUSTOM/exports.zsh"

# Private / untracked overrides (git-ignored)
[ -f "$ZSH_CUSTOM/work.zsh" ] && source "$ZSH_CUSTOM/work.zsh"
