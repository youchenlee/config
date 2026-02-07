# config

Personal dotfiles and Mac setup.

## New Mac Setup

```bash
git clone --recursive <repo-url> ~/config
~/config/install.sh
```

`install.sh` will:
1. Install Homebrew (if missing)
2. Install all packages, casks, and VS Code extensions from `Brewfile`
3. Symlink dotfiles and `.config/` directories

## Updating Brewfile

After installing or removing packages:

```bash
brew bundle dump --file=~/config/Brewfile --force
```

## Structure

```
.config/         # XDG configs (ghostty, tmux, workmux, ...)
bin/              # Custom scripts
claude/           # Claude Code settings
Brewfile          # Homebrew packages, casks, VS Code extensions
install.sh        # Setup script
```
