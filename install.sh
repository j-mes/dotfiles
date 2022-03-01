# Prequisites:
# - Homebrew installed
# - Oh My Zsh installed
# - No ~/.* files that you want to keep

brew bundle

for file in .{config,editorconfig,gitconfig,gitignore,hushlogin,prettierrc,zshrc}; do
	ln -sf ~/Developer/dotfiles/$file ~/$file
done;

unset file;
