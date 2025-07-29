# dotfiles

TBD

# Contents

-   [Dotfiles Setup & Usage](#dotfiles-setup--usage)
-   [Prerequisites](#prerequisites)
-   [Installation](#installation)
-   [Usage](#usage)
    -   [Symlinked Scripts](#symlinked-scripts)
    -   [Example: Run git-cleanup](#example-run-git-cleanup)
    -   [Example: Run fzf setup](#example-run-fzf-setup)
    -   [Integration Instructions](#integration-instructions)
-   [Troubleshooting](#troubleshooting)
-   [Customisation](#customisation)
-   [Uninstall](#uninstall)
-   [Homebrew Bundle](#homebrew-bundle)
-   [Included taps, formulae, and casks](#included-taps-formulae-and-casks)

# Dotfiles Setup & Usage

This repository contains configuration files and setup scripts for your development environment on macOS. It automates symlinking, clean-up, and shell configuration for a reproducible setup.

## Prerequisites

-   **Homebrew** installed ([brew.sh](https://brew.sh/))
-   **Oh My Zsh** installed ([ohmyz.sh](https://ohmyz.sh/))
-   No important files in your home directory that would be overwritten by symlinks

## Installation

1. **Clone your dotfiles repository:**

    ```zsh
    git clone ~/Developer/dotfiles
    cd ~/Developer/dotfiles
    ```

2. **Run the install script:**
    ```zsh
    source install.sh
    ```
    This will:
    - Remove old symlinks in your home and `~/.config` directories
    - Symlink all top-level dotfiles (e.g. `.zshrc`, `.gitconfig`, etc.)
    - Symlink all files and folders inside `.config` and their contents
    - Symlink all regular files inside `.config/scripts` (e.g. `git-cleanup.sh`, `fzf.sh`)
    - Ensure `git-cleanup` is a symlink to `git-cleanup.sh` and both are executable
    - Add `~/.config/scripts` to your `$PATH` in `.zshrc` if not present
    - Reload your zsh configuration

## Usage

### Symlinked Scripts

All scripts in `~/.config/scripts` are available globally if `$HOME/.config/scripts` is in your `$PATH`.

#### Example: Run git-cleanup

```zsh
git-cleanup
```

This script will:

-   Prune remote-tracking branches
-   Remove local branches tracking deleted remotes
-   Delete local branches already merged into `main`

#### Example: Run fzf setup

```zsh
source ~/.config/scripts/fzf.sh
```

This script will:

-   Source fzf key bindings and completion
-   Set FZF default options
-   **Replace the default Ctrl-R history search with a custom FZF widget:**
    -   Filters out repetitive/noisy commands (e.g. git status, git commit -m, etc.)
    -   Deduplicates history entries so each command appears only once
    -   Works with both EXTENDED_HISTORY and plain .zsh_history formats
    -   Binds this widget to Ctrl-R, replacing the default fzf history search

##### Integration Instructions

-   Add the following to your `.zshrc` to always load the custom FZF history widget:
    ```zsh
    [ -f ~/.config/scripts/fzf.sh ] && source ~/.config/scripts/fzf.sh
    ```
-   After sourcing, press <kbd>Ctrl</kbd>+<kbd>R</kbd> in your shell to use the enhanced history search.

## Troubleshooting

-   **Too many levels of symbolic links:**
    -   Remove problematic symlinks:
        ```zsh
        rm -f ~/.config/scripts/git-cleanup ~/.config/scripts/git-cleanup.sh
        cp ~/Developer/dotfiles/.config/scripts/git-cleanup.sh ~/.config/scripts/git-cleanup.sh
        ln -sf ~/.config/scripts/git-cleanup.sh ~/.config/scripts/git-cleanup
        chmod +x ~/.config/scripts/git-cleanup ~/.config/scripts/git-cleanup.sh
        ```
-   **Symlinks not working:**
    -   Ensure the source file exists and is not a symlink.
    -   Re-run `source install.sh` after fixing any issues.

## Customisation

-   Add your own scripts to `~/Developer/dotfiles/.config/scripts/` and re-run the install script to symlink and make them executable.
-   Edit dotfiles in `~/Developer/dotfiles` and re-run the install script to update symlinks.

## Uninstall

To remove all symlinks created by this setup:

```zsh
for file in .{config,editorconfig,gitconfig,gitignore,hushlogin,prettierrc,zshrc}; do
  [ -L ~/$file ] && rm ~/$file
  [ -L ~/.config/$file ] && rm ~/.config/$file
  [ -L ~/.config/scripts/$file ] && rm ~/.config/scripts/$file
  [ -L ~/.config/scripts/$file.sh ] && rm ~/.config/scripts/$file.sh
  [ -L ~/.config/scripts/$file.zsh ] && rm ~/.config/scripts/$file.zsh
  [ -L ~/.config/scripts/$file ] && rm ~/.config/scripts/$file
  [ -L ~/.config/scripts/$file.sh ] && rm ~/.config/scripts/$file.sh
  [ -L ~/.config/scripts/$file.zsh ] && rm ~/.config/scripts/$file.zsh
  [ -L ~/.config/$file ] && rm ~/.config/$file
  [ -L ~/$file ] && rm ~/$file
  [ -L ~/.config/scripts/git-cleanup ] && rm ~/.config/scripts/git-cleanup
  [ -L ~/.config/scripts/git-cleanup.sh ] && rm ~/.config/scripts/git-cleanup.sh
  [ -L ~/.config/scripts/fzf.sh ] && rm ~/.config/scripts/fzf.sh
  [ -L ~/.config/scripts/fzf ] && rm ~/.config/scripts/fzf
  [ -L ~/.config/scripts ] && rm ~/.config/scripts
  [ -L ~/.config ] && rm ~/.config

done
```

## Homebrew Bundle

This repo includes a `Brewfile` for easy installation of essential CLI tools and apps.

### Usage

To install everything in the Brewfile:

```zsh
brew bundle --file=Brewfile
```

### Included taps, formulae, and casks

**Formulae:**

-   gh
-   git
-   mas
-   pinentry-mac
-   starship

**Casks:**

-   1password
-   firefox@developer-edition
-   flux
-   google-chrome
-   hiddenbar
-   imageoptim
-   kap
-   rectangle
-   visual-studio-code
