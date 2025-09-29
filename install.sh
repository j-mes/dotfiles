#!/bin/zsh
# Lightweight dotfiles installer
#
# What this script does:
# - Creates symlinks from the repository into $HOME for a small set of top-level
#   dotfiles and for items under .config (mirrors the .config subtree).
# - When a destination file exists it is moved to a timestamped backup before
#   creating the symlink. If the source is missing the link is skipped (no
#   broken symlinks are created).
# - Supports a conservative --dry-run mode (no changes), an opt-in
#   --repair-links mode to attempt limited repairs of broken symlinks that point
#   into this repo, per-profile Homebrew bundle installation, and optional VS
#   Code extension installation from a per-profile list.

set -u

# --- Simple logging helpers -------------------------------------------------
log() { printf "%s\n" "$*"; }
warn() { printf "Warning: %s\n" "$*"; }
err() { printf "Error: %s\n" "$*"; }

# Print brief usage and exit
usage() { cat <<EOF
Usage: $0 [--profile=personal|work] [--auto-brew|--no-brew] [--repair-links] [--install-vscode-extensions] [--dry-run] [--force]
EOF
  exit 0
}

# --- Defaults --------------------------------------------------------------
DEFAULT_PROFILE="personal"
PROFILE="${DOTFILES_PROFILE:-}"
AUTO_BREW="no"
FORCE="no"
DRY_RUN="no"                # --dry-run avoids making changes; useful for verification
INSTALL_VSCODE_EXTS="no"
REPAIR_LINKS="no"           # --repair-links optionally repairs broken symlinks

# --- Parse command-line arguments ------------------------------------------
for arg in "$@"; do
  case "$arg" in
    --profile=*) PROFILE="${arg#*=}" ;;                     # select profile
    --auto-brew) AUTO_BREW="yes" ;;                        # run brew bundle automatically
    --no-brew) AUTO_BREW="no" ;;                          # explicitly disable brew steps
    --repair-links) REPAIR_LINKS="yes" ;;                 # opt-in repair of broken symlinks
    --install-vscode-extensions) INSTALL_VSCODE_EXTS="yes" ;; # install VS Code extensions list
    --dry-run) DRY_RUN="yes" ;;                           # show actions without mutating
    --force) FORCE="yes" ;;                               # replace conflicting files without backing off
    --help|-h) usage ;;                                    # show usage
    *) ;;                                                  # ignore unknown args (future-proof)
  esac
done

# If no profile was supplied and we're interactive, ask the user
if [ -z "$PROFILE" ] && [ -t 0 ]; then
  echo "Which profile? 1) personal (default)  2) work"
  printf "Choice [1/2]: "
  read -r c
  case "$c" in 2) PROFILE="work" ;; *) PROFILE="personal" ;; esac
fi
PROFILE="${PROFILE:-$DEFAULT_PROFILE}"
log "Profile: $PROFILE"

# --- Optional prerequisites (warn, do not fail) ---------------------------
MISSING_BREW="no"; MISSING_OMZ="no"
command -v brew >/dev/null 2>&1 || { warn "brew missing"; MISSING_BREW="yes"; }
[ -d "$HOME/.oh-my-zsh" ] || { warn "oh-my-zsh missing"; MISSING_OMZ="yes"; }

## Resolve a path to its canonical (real) path.
## Prefer system `realpath`, then `python3`, then `python` as a fallback.
realpath_f() { command -v realpath >/dev/null 2>&1 && realpath "$1" || (command -v python3 >/dev/null 2>&1 && python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1" || python -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1") }

## Determine repository root. Prefer the repository git top-level (if available)
## so the script works when invoked from subdirectories or when PWD isn't the repo root.
script_dir="$(cd "$(dirname "${0:-$PWD}")" && pwd)"
if command -v git >/dev/null 2>&1 && git -C "$script_dir" rev-parse --show-toplevel >/dev/null 2>&1; then
  REPO_ROOT="$(git -C "$script_dir" rev-parse --show-toplevel)"
else
  REPO_ROOT="$script_dir"
fi
REPO_REALPATH="$(realpath_f "$REPO_ROOT")"; HOME_REALPATH="$(realpath_f "$HOME")"

## is_ancestor parent child -> returns 0 if parent is an ancestor of child
is_ancestor() { case "$2" in "$1"|"$1"/*) return 0;; *) return 1;; esac }

## safe_link src dest
## - ensures source exists before creating a symlink
## - avoids creating links that point back into the repo (self-referential)
## - respects --dry-run
## - if dest is a symlink that already points to src, do nothing
## - if dest exists and is not a symlink, move it to a timestamped backup
safe_link() {
  src="$1"; dest="$2"
  # Skip when source doesn't exist (prevents creating broken symlinks)
  if [ ! -e "$src" ] && [ ! -L "$src" ]; then warn "missing src: $src"; return 1; fi

  src_abs="$(realpath_f "$src")"; dest_parent="$(realpath_f "$(dirname "$dest")")"
  # Avoid creating links whose destination parent resolves into the repo tree.
  # Without this, when a parent directory (eg. ~/.config/dir) is a symlink to
  # the repo, creating child links like ~/.config/dir/file would actually write
  # into the repository. Skip those to avoid mutating repo contents.
  if is_ancestor "$REPO_REALPATH" "$dest_parent" && [ "$FORCE" != "yes" ]; then
    warn "Skipping link that would live inside repo: $src -> $dest"
    return 1
  fi

  # Dry-run support
  [ "$DRY_RUN" = "yes" ] && { log "[dry-run] ln -sf $src $dest"; return 0; }

  # If dest is a symlink, replace it when it points elsewhere
  if [ -L "$dest" ]; then
    cur="$(readlink "$dest")"; cur_abs="$(realpath_f "$(dirname "$dest")/$cur")"
    [ "$cur_abs" = "$src_abs" ] && { log "Already: $dest -> $cur"; return 0; }
    rm -f "$dest" && ln -s "$src" "$dest" && { log "Replaced symlink: $dest -> $src"; return 0; } || { err "Failed link"; return 1; }
  fi

  # If dest is a real file, move to a timestamped backup before linking
  [ -e "$dest" ] && { mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)" || { err "backup failed"; return 1; } }
  mkdir -p "$(dirname "$dest")" && ln -s "$src" "$dest" && log "Linked $src -> $dest"
}

## Optional: repair broken symlinks in $HOME that point into this repo
## This is intentionally conservative (limited depth) and only runs when --repair-links
if [ "$REPAIR_LINKS" = "yes" ]; then
  log "Repairing broken symlinks (limited)..."
  find "$HOME" -maxdepth 4 -type l -print0 2>/dev/null | while IFS= read -r -d '' lnk; do
    # Skip symlinks that are inside the repo itself
    case "$lnk" in "$REPO_ROOT"*) continue;; esac
    target_raw="$(readlink "$lnk")" || continue
    [ -z "$target_raw" ] && continue
    if [ "${target_raw#/}" = "$target_raw" ]; then target_abs="$(realpath_f "$(dirname "$lnk")/$target_raw")"; else target_abs="$target_raw"; fi
    # If link is broken but its target resides in the repo and now exists, repair it
    if [ ! -e "$lnk" ] && [[ "$target_abs" == "$REPO_REALPATH"* ]] && [ -e "$target_abs" ]; then
      log "Repair: $lnk -> $target_abs"; [ "$DRY_RUN" = "yes" ] || (rm -f "$lnk" && ln -s "$target_abs" "$lnk")
    fi
  done
fi

## Homebrew: per-profile Brewfile. Skip if brew is not available.
BREWFILE="$REPO_ROOT/.config/homebrew/Brewfile.$PROFILE"
if [ -f "$BREWFILE" ]; then
  if [ "$MISSING_BREW" = "yes" ]; then
    warn "brew missing, skipping Brewfile"
  else
    if [ "$AUTO_BREW" = "yes" ]; then
      [ "$DRY_RUN" = "yes" ] || brew bundle --file="$BREWFILE"
    fi
  fi
fi

log "Symlinking top-level dotfiles"
# Top-level dotfiles -- keep this list small and explicit for readability
for f in .{editorconfig,gitignore,hushlogin,prettierrc,zshrc}; do
  safe_link "$REPO_ROOT/$f" "$HOME/$f" || warn "failed: $f"
done

## Mirror contents of .config (one level at a time). If the user already uses a
## single symlink for $HOME/.config, respect it and don't try to expand into it.
if [ -d "$REPO_ROOT/.config" ]; then
  [ -L "$HOME/.config" ] && log ".config is a symlink; skipping" || (
    mkdir -p "$HOME/.config"
    # Mirror files/dirs under .config, but special-case the
    # artificial-intelligence/github-copilot/* files so they are linked
    # directly into ~/.config/artificial-intelligence/ (VS Code expects
    # instruction files at that level).
    find "$REPO_ROOT/.config" -mindepth 1 -print0 | while IFS= read -r -d '' item; do
      rel="${item#$REPO_ROOT/.config/}"
      # Skip the github-copilot directory itself (we'll handle its contents)
      if [ "$rel" = "artificial-intelligence/github-copilot" ]; then
        continue
      fi

      if [[ "$rel" == artificial-intelligence/github-copilot/* ]]; then
        # Flatten: place files from github-copilot/ into ~/.config/artificial-intelligence/
        filename="${rel#artificial-intelligence/github-copilot/}"
        tgt="$HOME/.config/artificial-intelligence/$filename"
        mkdir -p "$(dirname "$tgt")"
        safe_link "$item" "$tgt" || warn "link failed: $item"
      else
        tgt="$HOME/.config/$rel"
        mkdir -p "$(dirname "$tgt")"
        safe_link "$item" "$tgt" || warn "link failed: $item"
      fi
    done
  )
fi

## Copy example gitconfig if the user doesn't already have one
if [ -f "$REPO_ROOT/.gitconfig.example" ] && [ ! -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
  cp "$REPO_ROOT/.gitconfig.example" "$HOME/.gitconfig" && log "Created ~/.gitconfig"
fi

## Optionally install VS Code extensions from a per-profile list
if [ "$INSTALL_VSCODE_EXTS" = "yes" ]; then
  EXTFILE="$REPO_ROOT/.config/vscode/extensions-$PROFILE.txt"
  if [ -f "$EXTFILE" ] && command -v code >/dev/null 2>&1; then
    grep -v -E '^\s*(#|$)' "$EXTFILE" | while IFS= read -r ext; do
      [ "$DRY_RUN" = "yes" ] || code --install-extension "$ext" || warn "ext failed: $ext"
    done
  fi
fi
