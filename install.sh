#!/bin/zsh
# Lightweight dotfiles installer.
#
# What this script does:
# - Symlinks a small set of top-level dotfiles into $HOME.
# - Symlinks tracked files from .config into $HOME/.config one file at a time.
# - Backs up conflicting files before replacing them with symlinks.
# - Optionally runs the shared Brewfile.

set -u

log() { printf "%s\n" "$*"; }
warn() { printf "Warning: %s\n" "$*"; }
err() { printf "Error: %s\n" "$*"; }

usage() {
  code="${1:-0}"
  cat <<'EOF'
Usage: ./install.sh [--auto-brew] [--repair-links] [--verify] [--dry-run] [--force]
EOF
  exit "$code"
}

usage_error() {
  err "$1"
  usage 2
}

AUTO_BREW="no"
DRY_RUN="no"
FORCE="no"
REPAIR_LINKS="no"
VERIFY="no"

TOP_LEVEL_DOTFILES=(
  .editorconfig
  .gitignore
  .hushlogin
  .prettierrc
  .zshrc
)

for arg in "$@"; do
  case "$arg" in
    --auto-brew) AUTO_BREW="yes" ;;
    --repair-links) REPAIR_LINKS="yes" ;;
    --dry-run) DRY_RUN="yes" ;;
    --verify) VERIFY="yes" ;;
    --force) FORCE="yes" ;;
    --help|-h) usage ;;
    *) usage_error "Unknown arg: $arg" ;;
  esac
done

realpath_f() {
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1"
  elif command -v python >/dev/null 2>&1; then
    python -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1"
  else
    printf "%s\n" "$1"
  fi
}

if [ -n "${BASH_SOURCE:-}" ] && [ "${BASH_SOURCE[0]}" != "" ]; then
  script_path="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
  script_path="${(%):-%x}"
else
  script_path="${0:-$PWD}"
fi

[ -z "$script_path" ] && script_path="$PWD"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"

if command -v git >/dev/null 2>&1 && git -C "$script_dir" rev-parse --show-toplevel >/dev/null 2>&1; then
  REPO_ROOT="$(git -C "$script_dir" rev-parse --show-toplevel)"
else
  REPO_ROOT="$script_dir"
fi

REPO_REALPATH="$(realpath_f "$REPO_ROOT")"
MISSING_BREW="no"

command -v brew >/dev/null 2>&1 || MISSING_BREW="yes"
[ -d "$HOME/.oh-my-zsh" ] || warn "oh-my-zsh missing"

tracked_config_files() {
  if command -v git >/dev/null 2>&1 && git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$REPO_ROOT" ls-files -z -- .config
  else
    find "$REPO_ROOT/.config" \( -type f -o -type l \) -print0 2>/dev/null
  fi
}

should_skip_path() {
  case "$1" in
    */.DS_Store) return 0 ;;
    *) return 1 ;;
  esac
}

path_matches_source() {
  src="$1"
  dest="$2"

  [ -e "$dest" ] || [ -L "$dest" ] || return 1

  src_abs="$(realpath_f "$src" 2>/dev/null || true)"
  dest_abs="$(realpath_f "$dest" 2>/dev/null || true)"

  [ -n "$src_abs" ] && [ "$src_abs" = "$dest_abs" ]
}

is_ancestor() {
  case "$2" in
    "$1"|"$1"/*) return 0 ;;
    *) return 1 ;;
  esac
}

safe_link() {
  src="$1"
  dest="$2"

  if [ ! -e "$src" ] && [ ! -L "$src" ]; then
    warn "missing src: $src"
    return 1
  fi

  src_abs="$(realpath_f "$src" 2>/dev/null || true)"
  dest_parent="$(realpath_f "$(dirname "$dest")" 2>/dev/null || true)"

  if [ -n "$dest_parent" ] && is_ancestor "$REPO_REALPATH" "$dest_parent" && [ "$FORCE" != "yes" ]; then
    warn "Skipping link that would live inside repo: $src -> $dest"
    return 1
  fi

  if [ "$DRY_RUN" = "yes" ]; then
    log "[dry-run] ln -sf $src $dest"
    return 0
  fi

  if [ -L "$dest" ]; then
    cur_abs="$(realpath_f "$dest" 2>/dev/null || true)"
    [ -n "$src_abs" ] && [ "$cur_abs" = "$src_abs" ] && {
      log "Already: $dest"
      return 0
    }

    rm -f "$dest" && ln -s "$src" "$dest" && {
      log "Replaced symlink: $dest -> $src"
      return 0
    }

    err "Failed link: $dest"
    return 1
  fi

  if [ -e "$dest" ]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)" || {
      err "backup failed: $dest"
      return 1
    }
  fi

  mkdir -p "$(dirname "$dest")" &&
    ln -s "$src" "$dest" &&
    log "Linked $src -> $dest"
}

config_path_covered_by_parent_symlink() {
  rel="$1"

  if [ -L "$HOME/.config" ] && [ "$(realpath_f "$HOME/.config" 2>/dev/null || true)" = "$(realpath_f "$REPO_ROOT/.config" 2>/dev/null || true)" ]; then
    return 0
  fi

  case "$rel" in
    .config/*/*)
      top="${rel#.config/}"
      top="${top%%/*}"
      top_dest="$HOME/.config/$top"
      top_src="$REPO_ROOT/.config/$top"

      [ -L "$top_dest" ] || return 1
      [ "$(realpath_f "$top_dest" 2>/dev/null || true)" = "$(realpath_f "$top_src" 2>/dev/null || true)" ]
      ;;
    *)
      return 1
      ;;
  esac
}

verify_links() {
  ok=0
  mismatch=0
  missing=0

  log "Checking top-level dotfiles..."
  for rel in "${TOP_LEVEL_DOTFILES[@]}"; do
    src="$REPO_ROOT/$rel"
    dest="$HOME/$rel"

    if path_matches_source "$src" "$dest"; then
      log "OK       : $dest"
      ok=$((ok + 1))
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
      warn "MISMATCH : $dest"
      mismatch=$((mismatch + 1))
    else
      warn "MISSING  : $dest"
      missing=$((missing + 1))
    fi
  done

  log ""
  log "Checking tracked .config files..."
  while IFS= read -r -d '' rel; do
    should_skip_path "$rel" && continue

    src="$REPO_ROOT/$rel"
    [ -e "$src" ] || [ -L "$src" ] || continue

    dest="$HOME/$rel"

    if path_matches_source "$src" "$dest"; then
      log "OK       : $dest"
      ok=$((ok + 1))
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
      warn "MISMATCH : $dest"
      mismatch=$((mismatch + 1))
    else
      warn "MISSING  : $dest"
      missing=$((missing + 1))
    fi
  done < <(tracked_config_files)

  log ""
  log "Summary:"
  log "  OK: $ok"
  log "  MISMATCH: $mismatch"
  log "  MISSING: $missing"

  [ "$mismatch" -eq 0 ] && [ "$missing" -eq 0 ]
}

if [ "$REPAIR_LINKS" = "yes" ]; then
  log "Repairing broken symlinks (limited)..."
  while IFS= read -r -d '' lnk; do
    case "$lnk" in
      "$REPO_ROOT"*) continue ;;
    esac

    [ ! -e "$lnk" ] || continue

    target_abs="$(realpath_f "$lnk" 2>/dev/null || true)"
    [ -n "$target_abs" ] || continue

    if is_ancestor "$REPO_REALPATH" "$target_abs" && [ -e "$target_abs" ]; then
      log "Repair: $lnk -> $target_abs"
      [ "$DRY_RUN" = "yes" ] || {
        rm -f "$lnk"
        ln -s "$target_abs" "$lnk"
      }
    fi
  done < <(find "$HOME" -maxdepth 4 -type l -print0 2>/dev/null)
fi

if [ "$VERIFY" = "yes" ]; then
  if verify_links; then
    exit 0
  fi
  exit 1
fi

log "Symlinking top-level dotfiles"
for rel in "${TOP_LEVEL_DOTFILES[@]}"; do
  safe_link "$REPO_ROOT/$rel" "$HOME/$rel" || warn "failed: $rel"
done

log "Symlinking tracked .config files"
while IFS= read -r -d '' rel; do
  should_skip_path "$rel" && continue

  src="$REPO_ROOT/$rel"
  [ -e "$src" ] || [ -L "$src" ] || continue

  config_path_covered_by_parent_symlink "$rel" && continue

  safe_link "$src" "$HOME/$rel" || warn "failed: $rel"
done < <(tracked_config_files)

if [ -f "$REPO_ROOT/.gitconfig.example" ] && [ ! -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
  if [ "$DRY_RUN" = "yes" ]; then
    log "[dry-run] cp $REPO_ROOT/.gitconfig.example $HOME/.gitconfig"
  else
    cp "$REPO_ROOT/.gitconfig.example" "$HOME/.gitconfig" &&
      log "Created ~/.gitconfig from .gitconfig.example"
  fi
fi

BREWFILE="$REPO_ROOT/.config/homebrew/Brewfile"
if [ "$AUTO_BREW" = "yes" ]; then
  if [ "$MISSING_BREW" = "yes" ]; then
    warn "brew missing; skipping Brewfile"
  elif [ -f "$BREWFILE" ]; then
    [ "$DRY_RUN" = "yes" ] || brew bundle --file="$BREWFILE"
  else
    warn "missing Brewfile: $BREWFILE"
  fi
fi
