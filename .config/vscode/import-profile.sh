#!/bin/zsh
# Helper: open a VS Code profile file and print instructions to import it.
# Usage: ./import-profile.sh template-work.code-profile

if [ -z "$1" ]; then
  echo "Usage: $0 <profile-file>"
  exit 1
fi
PROFILE_FILE="$PWD/profiles/$1"
if [ ! -f "$PROFILE_FILE" ]; then
  echo "Profile file not found: $PROFILE_FILE"
  exit 2
fi

if command -v code >/dev/null 2>&1; then
  echo "Opening profile file in VS Code: $PROFILE_FILE"
  code "$PROFILE_FILE"
  echo "In VS Code: Command Palette -> 'Profiles: Import Profile From File...' and choose the opened file."
else
  echo "Please open the file in VS Code and import it via Command Palette -> 'Profiles: Import Profile From File...'"
fi
