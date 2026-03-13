# dotfiles

Small macOS dotfiles repo with one default setup.

The repo keeps tracked config readable and installs it conservatively:

- `install.sh` links tracked files only.
- `.config` is linked file-by-file instead of as one giant symlink.
- Private machine overrides stay out of git.
- Homebrew uses one canonical config.

## Install

```sh
git clone https://github.com/j-mes/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

Optional install flows:

```sh
./install.sh --auto-brew
./install.sh --verify
./install.sh --dry-run
```

Supported flags:

- `--auto-brew`: run `brew bundle --file=.config/homebrew/Brewfile`
- `--repair-links`: repair broken symlinks that already point into this repo
- `--verify`: report whether `$HOME` resolves back to this repo without making changes, and exit non-zero on mismatches or missing files
- `--dry-run`: print link actions without mutating anything
- `--force`: allow links even when the destination parent already resolves inside the repo

If `~/.gitconfig` does not exist, `install.sh` copies `.gitconfig.example` into place.

## Layout

Tracked shell config lives in `.zshrc` and `.config/oh-my-zsh`.

`.zshrc` stays thin and loads:

- `exports.zsh` for PATH and environment setup
- `aliases.zsh` for shell aliases
- `machine.zsh` for safe machine-specific logic
- `local.zsh` for private overrides

Shared package and editor config lives in:

- `.config/homebrew/Brewfile`
- `.config/zed/settings.json`

## Private Files

Keep sensitive or machine-specific shell config in `~/.config/oh-my-zsh/local.zsh`. That file is git-ignored.

Your real `~/.gitconfig` is intentionally not tracked. Use `.gitconfig.example` as the starting point. The template uses `zed --wait` as the default editor.

## Maintenance

The `upgrade` alias runs `.config/upgrade.zsh`, which updates Oh My Zsh, Homebrew, and Mac App Store packages when those tools are installed.

## Tests

Run the installer regression test with:

```sh
zsh ./tests/install.sh
```
