#!/bin/zsh
# ---------------------------------------------------------------------------
# install.sh
# Purpose: Symlink dotfiles & .config contents into $HOME after cloning.
#           Added: supports machine profile selection (personal/work) and
#           optional Homebrew bundle per-profile.
# Prereqs: Homebrew, Oh My Zsh installed. Existing dotfiles will be replaced.
# Safety: Uses ln -sf (force) – ensure you have backups if needed.
# ---------------------------------------------------------------------------

# Check: Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "Error: Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# Check: Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Error: Oh My Zsh is not installed. Please install Oh My Zsh first."
    exit 1
fi

# --- CLI flags & Profile selection ----------------------------------------
# Supports:
#   --profile=<personal|work>   (or set DOTFILES_PROFILE env var)
#   --auto-brew                 (automatically run brew bundle non-interactively)
#   --no-brew                   (skip brew bundle)

DEFAULT_PROFILE="personal"
PROFILE="${DOTFILES_PROFILE:-}"
AUTO_BREW="no"

INSTALL_VSCODE_EXTS="no"

# Simple argv parsing for supported flags
for arg in "$@"; do
    case "$arg" in
        --profile=*) PROFILE="${arg#*=}" ;;
        --auto-brew) AUTO_BREW="yes" ;;
        --install-vscode-extensions) INSTALL_VSCODE_EXTS="yes" ;;
        --yes) AUTO_BREW="yes"; INSTALL_VSCODE_EXTS="yes" ;;
        --no-brew) AUTO_BREW="no" ;;
        --help|-h)
            echo "Usage: $0 [--profile=personal|work] [--auto-brew|--no-brew] [--install-vscode-extensions] [--yes]"
            exit 0
            ;;
    esac
done

# If PROFILE still empty and running interactively, prompt the user
if [ -z "$PROFILE" ] && [ -t 0 ]; then
    echo "Which profile are you installing for?"
    echo "  1) personal (default)"
    echo "  2) work"
    printf "Enter choice [1/2]: "
    read -r choice
    case "$choice" in
        2) PROFILE="work" ;;
        1|"" ) PROFILE="personal" ;;
        *) echo "Unrecognized choice, defaulting to personal."; PROFILE="personal" ;;
    esac
fi

# Final default
PROFILE="${PROFILE:-$DEFAULT_PROFILE}"
echo "Selected profile: $PROFILE"

# Brewfile path now lives under .config/homebrew
BREWFILE_PATH="$PWD/.config/homebrew/Brewfile.$PROFILE"
if [ -f "$BREWFILE_PATH" ]; then
    if [ "$AUTO_BREW" = "yes" ]; then
        echo "Auto-running: brew bundle --file=$BREWFILE_PATH"
        brew bundle --file="$BREWFILE_PATH"
    else
        if [ -t 0 ]; then
            printf "Run Homebrew bundle using %s? [Y/n]: " "$BREWFILE_PATH"
            read -r run_bundle
            case "$run_bundle" in
                [Yy]|"" )
                    echo "Running: brew bundle --file=$BREWFILE_PATH"
                    brew bundle --file="$BREWFILE_PATH"
                    ;;
                *) echo "Skipping Homebrew bundle for $PROFILE profile." ;;
            esac
        else
            echo "Non-interactive shell and --auto-brew not set; skipping Homebrew bundle for $PROFILE."
        fi
    fi
else
    echo "No Brewfile found for profile '$PROFILE' at $BREWFILE_PATH. Skipping brew bundle."
fi


# Phase 1: Symlink top-level dotfiles
echo "Symlinking dotfiles..."
success_count=0
fail_count=0
for file in .{config,editorconfig,gitignore,hushlogin,prettierrc,zshrc}; do
    src="$PWD/$file"      # Source file in repo
    dest="$HOME/$file"    # Destination in home directory
    # Create symlink, overwrite if exists
    if ln -sf "$src" "$dest"; then
        echo "Linked $src -> $dest"
        success_count=$((success_count+1))
    else
        echo "Failed to link $src"
        fail_count=$((fail_count+1))
    fi
done

# Summary (top-level)
echo "Done. $success_count files linked, $fail_count failed."

# Cleanup loop variables
unset file src dest success_count fail_count

# Phase 2: Symlink .config subtree
echo "Symlinking contents of .config..."
config_src="$PWD/.config"
config_dest="$HOME/.config"
if [ -d "$config_src" ]; then
    find "$config_src" -mindepth 1 | while read -r item; do
        rel_path="${item#$config_src/}"
        target="$config_dest/$rel_path"
        mkdir -p "$(dirname "$target")"
        if ln -sf "$item" "$target"; then
            echo "Linked $item -> $target"
        else
            echo "Failed to link $item"
        fi
    done
else
    echo ".config directory not found in repo. Skipping recursive symlinking."
fi

# Apply PATH changes immediately for current session
if [ -f "$HOME/.config/oh-my-zsh/exports.zsh" ]; then
    echo "Sourcing $HOME/.config/oh-my-zsh/exports.zsh to update PATH..."
    source "$HOME/.config/oh-my-zsh/exports.zsh"
else
    echo "exports.zsh not found. Please check your dotfiles setup."
fi

# Git config template handling
# Only create ~/.gitconfig from example if none exists. Never overwrite an existing file.
if [ -f "$HOME/.gitconfig" ]; then
    echo "Skipping git config template: ~/.gitconfig already exists (left untouched)."
elif [ -L "$HOME/.gitconfig" ]; then
    echo "NOTE: ~/.gitconfig is a symlink; not replacing."
elif [ -f "$PWD/.gitconfig.example" ]; then
    cp "$PWD/.gitconfig.example" "$HOME/.gitconfig"
    echo "Created ~/.gitconfig from template (.gitconfig.example). Edit your name/email & signing key." 
else
    echo "No .gitconfig.example found; skipping git config setup."
fi

# --- VS Code extensions installation --------------------------------------
VSCODE_EXT_FILE="$PWD/.config/vscode/extensions-$PROFILE.txt"
if [ "$INSTALL_VSCODE_EXTS" = "yes" ]; then
    if ! command -v code >/dev/null 2>&1; then
        echo "VS Code CLI 'code' not found in PATH; skipping extensions installation."
    elif [ -f "$VSCODE_EXT_FILE" ]; then
        echo "Installing VS Code extensions from $VSCODE_EXT_FILE"
        # Install each extension listed (ignore empty lines and comments)
        grep -v -E '^\s*(#|$)' "$VSCODE_EXT_FILE" | while read -r ext; do
            echo "Installing extension: $ext"
            code --install-extension "$ext" || echo "Failed to install $ext"
        done
    else
        echo "No VS Code extensions file found for profile at $VSCODE_EXT_FILE. Skipping."
    fi
fi
