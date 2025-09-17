#!/bin/zsh
# ---------------------------------------------------------------------------
# install.sh
# Purpose: Symlink dotfiles & .config contents into $HOME after cloning.
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

# Git config template: copy example if user does not already have one
if [ ! -f "$HOME/.gitconfig" ] && [ -f "$PWD/.gitconfig.example" ]; then
    cp "$PWD/.gitconfig.example" "$HOME/.gitconfig"
    echo "Created ~/.gitconfig from template (.gitconfig.example). Please edit your name/email."
fi
