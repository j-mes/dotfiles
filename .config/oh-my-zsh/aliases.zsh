#!/bin/zsh
# ---------------------------------------------------------------------------
# Aliases
# Purpose: Convenience shortcuts for frequent git and navigation commands.
# Safety: Non-destructive except where noted.
# Style: Keep names short & readable; prefer verbs; document intent inline.
# ---------------------------------------------------------------------------

alias cob="git switch -c "     # Create and switch to a new branch.
alias com="git switch main"    # Switch to the main branch.
alias dev="cd ~/Developer"     # Jump to Developer directory.
alias gap="git add -p"         # Interactively stage changes.
alias gp="git pull"            # Pull latest remote changes.
alias gs="git status"          # Show git status.
alias gsp="git stash pop"      # Apply and drop the latest stash.
alias gst="git stash -u && gs" # Stash tracked and untracked changes, then show status.
alias guncommit="git reset --soft HEAD~1" # Undo the last commit but keep changes staged.
alias reload="exec zsh"        # Reload current shell session.
alias upgrade="zsh ~/.config/upgrade.zsh"  # Run upgrade / maintenance script.
