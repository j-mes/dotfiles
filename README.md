# dotfiles

A comprehensive, well-documented set of configuration files and scripts for setting up and maintaining a macOS development environment. This repository automates the installation of essential tools, configures your shell, and ensures consistent editor and git settings.

## Features

-   Automated setup for Homebrew packages, casks, and dotfiles
-   Zsh configuration with Oh My Zsh, custom aliases, and exports
-   Editor and code style settings for consistent formatting
-   Git configuration with useful aliases and signing setup
-   Upgrade script for keeping tools up to date

## Prerequisites

-   macOS
-   [Homebrew](https://brew.sh/) installed
-   [Oh My Zsh](https://ohmyz.sh/) installed
-   No existing `~/.*` dotfiles you wish to keep (the install script will overwrite them)

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

-   CLI tools: `fzf`, `gh`, `git`, `mas`, `starship`, `volta`
-   Apps: `discord`, `firefox@developer-edition`, `google-chrome`, `imageoptim`, `insomnia`, `kap`, `microsoft-edge`, `protonvpn`, `rectangle`, `vlc`, `visual-studio-code`, `hiddenbar`
-   Fonts: `font-fira-code-nerd-font`

### install.sh

Symlinks all relevant dotfiles from the repository to your home directory, overwriting any existing files.

### .config/

Custom configuration scripts:

-   `oh-my-zsh/aliases.zsh`: Useful git and shell aliases
-   `oh-my-zsh/exports.zsh`: Environment variable exports for Homebrew, Rust, Node.js, Volta, etc.
-   `upgrade.zsh`: Script to upgrade Oh My Zsh, Homebrew, and Mac App Store apps

### .zshrc

Configures Zsh with:

-   Oh My Zsh
-   Custom theme and plugins
-   Starship prompt
-   FZF integration
-   Volta for Node.js version management
-   Loads custom aliases and exports

### .gitconfig

Git configuration with:

-   User info and SSH signing
-   Editor setup
-   Useful aliases (`cleanup`, `branches`, `who`)
-   Push and pull defaults

### .editorconfig

Editor configuration for consistent line endings and indentation.

### .prettierrc

Prettier configuration for code formatting.

### .hushlogin

Suppresses login messages in the terminal (empty file).

## Upgrading

Run the upgrade script to update all tools:

```sh
upgrade
```

This will:

-   Update Oh My Zsh
-   Update and upgrade Homebrew packages and casks
-   Upgrade Mac App Store apps

## Customisation

Feel free to modify aliases, exports, and other configuration files to suit your workflow.

### Machine-Specific Configuration (`machine.zsh`)

The file `~/.config/oh-my-zsh/machine.zsh` is sourced early by `.zshrc` and is intended for:

-   Host or environment specific tweaks
-   Optional integrations (e.g. VS Code shell integration)
-   Conditional exports, PATH adjustments, or feature flags

It is safe to commit because every block should be guarded (e.g. checking a command exists or hostname patterns). Example hostname logic you can enable:

```zsh
case "$(hostname -s)" in
   work-mac*) export NODE_ENV=development ;;
   personal*) export NODE_ENV=personal ;;
esac
```

### VS Code Shell Integration

Included via `machine.zsh` when running inside the VS Code integrated terminal. It enables command decorations (success/fail markers, timing) and improved shell integration features.

Guarded snippet used:

```zsh
if [[ "$TERM_PROGRAM" == "vscode" ]] && command -v code >/dev/null 2>&1; then
   _vsc_integration_path="$(code --locate-shell-integration-path zsh 2>/dev/null)"
   if [[ -n "$_vsc_integration_path" && -f "$_vsc_integration_path" ]]; then
      source "$_vsc_integration_path"
   fi
   unset _vsc_integration_path
fi
```

To verify it loaded in a new VS Code terminal:

```zsh
echo ${VSCODE_SHELL_INTEGRATION:-not-loaded}
```

You should see a non-empty value if integration succeeded.

If the `code` CLI is missing, install it from VS Code: Command Palette → “Shell Command: Install 'code' command in PATH”.

### Private / Untracked Work Configuration (`work.zsh`)

You can keep sensitive or workplace-specific configuration in an untracked file:

Path (ignored by git): `~/.config/oh-my-zsh/work.zsh`

Uses:

-   Internal API tokens / secrets (prefer a secret manager where possible)
-   Proprietary aliases or functions
-   Host-specific PATH additions you don’t want published

It is sourced automatically by `.zshrc` if it exists. Create it after cloning:

```zsh
touch ~/.config/oh-my-zsh/work.zsh
chmod 600 ~/.config/oh-my-zsh/work.zsh
```

Example starter template:

```zsh
# ~/.config/oh-my-zsh/work.zsh (untracked)
# export INTERNAL_API_TOKEN="$(security find-generic-password -w -a you -s internal-api)"
# alias deploy-app="./scripts/deploy --env=staging"
```

Note: The file was added to `.gitignore`. If sensitive data was previously committed, consider rewriting history (e.g. with `git filter-repo`) to purge it.

## License

This repository is licensed under the MIT License.
