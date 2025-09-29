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
   There are two Brewfiles included so you can keep personal and work machines separate. They live under
   `.config/homebrew/` in the repo:

    - `.config/homebrew/Brewfile.personal` — personal laptop defaults (includes apps like Discord, ProtonVPN)
    - `.config/homebrew/Brewfile.work` — work laptop defaults (excludes some personal apps)

    You can run a bundle directly, for example:

    ```sh
    brew bundle --file=.config/homebrew/Brewfile.personal
    # or
    brew bundle --file=.config/homebrew/Brewfile.work
    ```

3. **Symlink dotfiles to your home directory and (optionally) install apps:**

    ```sh
    ./install.sh
    ```

    `install.sh` can now be driven either interactively or via flags/env vars. Usage examples:

    - Interactive (prompts for profile and whether to run brew bundle):

    ```sh
    ./install.sh
    ```

    - Non-interactive using env var to choose profile (will skip brew bundle unless `--auto-brew` is used):

    ```sh
    DOTFILES_PROFILE=work ./install.sh
    ```

    - Non-interactive and auto-run brew bundle for chosen profile:

    ```sh
    ./install.sh --profile=work --auto-brew
    ```

    Flags supported:

    - `--profile=personal|work` — select profile explicitly (overrides `DOTFILES_PROFILE`)
    - `--auto-brew` — automatically run `brew bundle --file=.config/homebrew/Brewfile.<profile>` without prompting
    - `--no-brew` — explicitly skip brew bundle
    - `--install-vscode-extensions` — install VS Code extensions listed in `.config/vscode/extensions-<profile>.txt`
    - `--yes` — non-interactive shortcut that implies `--auto-brew` and `--install-vscode-extensions`

    If a matching Brewfile isn't present under `.config/homebrew/`, the script will skip the bundle step and continue with symlinking.

    VS Code: there's a `.config/vscode/` folder for keeping VS Code profiles and per-profile extension lists. Use `--install-vscode-extensions` to have `install.sh` automatically install extension lists.

    A small helper is provided at `.config/vscode/import-profile.sh` to open a template `.code-profile` file in VS Code and remind you how to import it via the Command Palette. Importing profiles into VS Code remains a manual UI action.
    This will create symbolic links for:

    - `.config`
    - `.editorconfig`
    - `.gitignore`
    - `.hushlogin`
    - `.prettierrc`
    - `.zshrc`
      (Your personal `.gitconfig` is no longer tracked; a template is provided.)

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

### .gitconfig.example

Template Git configuration (the real `~/.gitconfig` is not tracked to avoid leaking personal info). It includes:

-   Alias examples (`cleanup`, `branches`, `who`)
-   SSH commit signing setup using `gpg.format = ssh`
-   `autoSetupRemote` and fast‑forward only pulls

Usage:

```sh
cp .gitconfig.example ~/.gitconfig
sed -i '' 's/you@example.com/you@yourdomain.com/' ~/.gitconfig
sed -i '' 's/Your Name/Your Real Name/' ~/.gitconfig
```

Then edit further as needed.
Note: `.gitconfig` is intentionally ignored via `.gitignore` to prevent committing personal identity/signing details. Use the example as a base; maintain your personal `~/.gitconfig` directly (no auxiliary local include file is used by design).

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

## Verification

`install.sh` now includes a `--verify` flag that checks the repository is correctly linked into your home directory without making any changes. The verifier inspects:

-   Top-level dotfiles (`.editorconfig`, `.gitignore`, `.hushlogin`, `.prettierrc`, `.zshrc`) — each must be a symlink resolving to the corresponding file in the repository.
-   Entries under `.config/` — a top-level `~/.config/<name>` symlink that points to `repo/.config/<name>` is treated as the source of truth and accepted (children are available through the parent symlink).

Usage:

```zsh
cd ~/Developer/dotfiles
# Run verification (safe; makes no changes)
zsh ./install.sh --verify
```

Notes:

-   The command prints a human-friendly report listing OK/MISMATCH/EXISTS/MISSING items and a short summary.
-   The verifier exits with code `0` currently even if mismatches are found; if you prefer a non-zero exit code on failures, open an issue or request and I can make the verifier return a failure code when any mismatch/missing item is detected.

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
