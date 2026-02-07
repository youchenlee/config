#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing packages from Brewfile..."
brew bundle install --file="$DOTFILES_DIR/Brewfile"

# --- Symlinks ---
echo "Creating symlinks..."
for file in .zshrc .vimrc .gitconfig .gitignore_global .inputrc; do
  [ -f "$DOTFILES_DIR/$file" ] && ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
done

# .config 子目錄
for dir in "$DOTFILES_DIR"/.config/*/; do
  dirname=$(basename "$dir")
  mkdir -p "$HOME/.config/$dirname"
  for f in "$dir"*; do
    [ -f "$f" ] && ln -sfn "$f" "$HOME/.config/$dirname/$(basename "$f")"
  done
done

echo "Done! Restart your terminal."
