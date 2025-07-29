#!/bin/zsh

# -----------------------------
# Git Cleanup Script
# Purpose:
#   - Remove remote-tracking branches that no longer exist
#   - Delete local branches tracking deleted remote branches
#   - Delete local branches already merged into 'main'
# -----------------------------

# 🚧 Guard: Exit if not in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ Not inside a Git repository. Aborting."
  exit 1
fi

# 🔄 Fetch from remote and prune deleted remote-tracking branches
echo "🔄 Fetching and pruning remote branches..."
git fetch --prune

# 🗑️ Remove local branches tracking deleted remote branches
# - 'git branch -vv' lists branches with upstream info
# - 'grep : gone]' filters branches with deleted upstreams
# - 'grep -v "\*"' excludes the currently checked out branch
# - 'awk' extracts the branch name (first column)
# - 'xargs -r git branch -d' deletes each safely
echo "🗑️ Removing local branches tracking deleted remotes..."
git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d

# ✅ Delete local branches already merged into 'main'
# - 'git branch --merged main' shows fully merged branches
# - 'grep -v main' ensures we don't delete 'main' itself
# - 'xargs -r git branch -d' deletes each safely
echo "✅ Deleting branches already merged into 'main'..."
git branch --merged main | grep -v '^[ *]*main$' | xargs -r git branch -d

echo "🎉 Git cleanup completed."
