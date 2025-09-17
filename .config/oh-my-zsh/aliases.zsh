#!/bin/zsh
# ---------------------------------------------------------------------------
# Aliases
# Purpose: Convenience shortcuts for frequent git and navigation commands.
# Safety: Non-destructive except where noted (e.g. gundo rewrites last commit).
# Style: Keep names short & readable; prefer verbs; document intent inline.
# ---------------------------------------------------------------------------

alias cob="git checkout -b "   # Create & switch to a new git branch (expects name appended).
alias com="git checkout main"  # Switch to 'main' branch.
alias dev="cd ~/Developer"     # Jump to Developer directory.
alias gap="git add -p"         # Interactively stage changes (patch mode).
alias gp="git pull"            # Pull latest remote changes.
alias gs="git status"          # Show git status.
alias gsp="git stash pop"      # Apply & drop latest stash.
alias gst="git stash -u && gs" # Stash all (incl. untracked), then show status.
alias gundo="git reset HEAD~"  # Undo last commit (keeps changes staged) – destructive.
alias reload="exec zsh"        # Reload current shell session.
alias upgrade="zsh ~/.config/upgrade.zsh"  # Run upgrade / maintenance script.
