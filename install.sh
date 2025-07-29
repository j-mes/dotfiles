# Prequisites:
# - Homebrew installed
# - Oh My Zsh installed
# - No ~/.* files that you want to keep

#brew bundle

# Clean up old symlinks before installing
for file in .{config,editorconfig,gitconfig,gitignore,hushlogin,prettierrc,zshrc}; do
	if [ -L ~/$file ]; then
		rm ~/$file && echo "Removed symlink ~/$file"
	fi

done;

if [ -d ~/.config ]; then
	for item in ~/.config/*; do
		if [ -L "$item" ]; then
			rm "$item" && echo "Removed symlink $item"
		fi
		if [ -d "$item" ]; then
			for subitem in "$item"/*; do
				if [ -L "$subitem" ]; then
					rm "$subitem" && echo "Removed symlink $subitem"
				fi
			done
		fi
	
done
fi

for file in .{config,editorconfig,gitconfig,gitignore,hushlogin,prettierrc,zshrc}; do
	if [ -e ~/Developer/dotfiles/$file ]; then
		ln -sf ~/Developer/dotfiles/$file ~/$file && echo "Symlinked $file"
	fi

done;

# Symlink contents of .config
if [ -d ~/Developer/dotfiles/.config ]; then
	mkdir -p ~/.config
	for item in ~/Developer/dotfiles/.config/*; do
		base=$(basename "$item")
		if [ -e "$item" ]; then
			ln -sf "$item" ~/.config/"$base" && echo "Symlinked .config/$base"
		fi
		# If item is a directory, symlink its contents (but not the directory itself)
		if [ -d "$item" ]; then
			mkdir -p ~/.config/"$base"
			for subitem in "$item"/*; do
				subbase=$(basename "$subitem")
				if [ -e "$subitem" ]; then
					ln -sf "$subitem" ~/.config/"$base"/"$subbase" && echo "Symlinked .config/$base/$subbase"
				fi
			done
		fi
	
done
fi

# Symlink only regular files inside .config/scripts, avoiding circular symlinks and skipping directories
if [ -d ~/Developer/dotfiles/.config/scripts ]; then
	mkdir -p ~/.config/scripts
	for script in ~/Developer/dotfiles/.config/scripts/*; do
		scriptbase=$(basename "$script")
		dest="$HOME/.config/scripts/$scriptbase"
		if [ -f "$script" ]; then
			# Remove existing symlink at destination, but do not delete real files/folders
			if [ -L "$dest" ]; then
				rm "$dest" && echo "Removed old symlink $dest"
			fi
			# Only symlink if source is not a symlink pointing to destination
			if [ "$(readlink -f "$script")" != "$dest" ]; then
				ln -sf "$script" "$dest" && echo "Symlinked scripts/$scriptbase"
				chmod +x "$dest"
			fi
		fi
	done
fi

unset file;

# Ensure ~/.config/scripts/git-cleanup.sh is executable
if [ -f ~/.config/scripts/git-cleanup.sh ]; then
	chmod +x ~/.config/scripts/git-cleanup.sh
fi

# Ensure git-cleanup symlink exists and is executable, only if source is a real file
if [ -f ~/.config/scripts/git-cleanup.sh ] && [ ! -L ~/.config/scripts/git-cleanup.sh ]; then
    # Remove any existing symlink named git-cleanup
    if [ -L ~/.config/scripts/git-cleanup ]; then
        rm ~/.config/scripts/git-cleanup && echo "Removed old symlink ~/.config/scripts/git-cleanup"
    fi
    ln -sf ~/.config/scripts/git-cleanup.sh ~/.config/scripts/git-cleanup && echo "Symlinked git-cleanup to git-cleanup.sh"
    chmod +x ~/.config/scripts/git-cleanup.sh
    chmod +x ~/.config/scripts/git-cleanup
fi

# Add ~/.config/scripts to PATH in .zshrc if not present
if ! grep -q 'export PATH="$HOME/.config/scripts:$PATH"' ~/.zshrc; then
  echo 'export PATH="$HOME/.config/scripts:$PATH"' >> ~/.zshrc
  echo "Added ~/.config/scripts to PATH in .zshrc"
fi

# Reload zsh configuration
source ~/.zshrc
