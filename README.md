# dotfiles

A comprehensive, well-documented set of configuration files and scripts for setting up and maintaining a macOS development environment. This repository automates the installation of essential tools, configures your shell, and ensures consistent editor and git settings.

## Features
- Automated setup for Homebrew packages, casks, and dotfiles
- Zsh configuration with Oh My Zsh, custom aliases, and exports
- Editor and code style settings for consistent formatting
- Git configuration with useful aliases and signing setup
- Upgrade script for keeping tools up to date

## Prerequisites
- macOS
- [Homebrew](https://brew.sh/) installed
- [Oh My Zsh](https://ohmyz.sh/) installed
- No existing `~/.*` dotfiles you wish to keep (the install script will overwrite them)

## Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/j-mes/dotfiles.git ~/Developer/dotfiles
   cd ~/Developer/dotfiles
   ```
2. **Install Homebrew packages and casks:**
   ```sh
   brew bundle --file=Brewfile
   ```
3. **Symlink dotfiles to your home directory:**
   ```sh
   ./install.sh
   ```
   This will create symbolic links for:
   - `.config`
   - `.editorconfig`
   - `.gitconfig`
   - `.gitignore`
   - `.hushlogin`
   - `.prettierrc`
   - `.zshrc`

## File Overview

### Brewfile
Lists all Homebrew packages and casks to install, including:
- CLI tools: `fzf`, `gh`, `git`, `mas`, `starship`, `volta`
- Apps: `discord`, `firefox@developer-edition`, `google-chrome`, `imageoptim`, `insomnia`, `kap`, `microsoft-edge`, `protonvpn`, `rectangle`, `vlc`, `visual-studio-code`, `hiddenbar`
- Fonts: `font-fira-code-nerd-font`

### install.sh
Symlinks all relevant dotfiles from the repository to your home directory, overwriting any existing files.

### .config/
Custom configuration scripts:
- `oh-my-zsh/aliases.zsh`: Useful git and shell aliases
- `oh-my-zsh/exports.zsh`: Environment variable exports for Homebrew, Rust, Node.js, Volta, etc.
- `upgrade.zsh`: Script to upgrade Oh My Zsh, Homebrew, and Mac App Store apps

### .zshrc
Configures Zsh with:
- Oh My Zsh
- Custom theme and plugins
- Starship prompt
- FZF integration
- Volta for Node.js version management
- Loads custom aliases and exports

### .gitconfig
Git configuration with:
- User info and SSH signing
- Editor setup
- Useful aliases (`cleanup`, `branches`, `who`)
- Push and pull defaults

### .editorconfig
Editor configuration for consistent line endings and indentation.

### .prettierrc
Prettier configuration for code formatting.

### .gitignore
Ignores common system and node files.

### .hushlogin
Suppresses login messages in the terminal (empty file).

### LICENSE
MIT License.

## Upgrading
Run the upgrade script to update all tools:
```sh
upgrade
```
This will:
- Update Oh My Zsh
- Update and upgrade Homebrew packages and casks
- Upgrade Mac App Store apps

## Customisation
Feel free to modify aliases, exports, and other configuration files to suit your workflow.

## Contributing
Pull requests and suggestions are welcome!

## License
This repository is licensed under the MIT License.
