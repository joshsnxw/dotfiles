#!/usr/bin/env bash
# Bootstrap a fresh macOS install from this dotfiles repo.
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshsnxw/dotfiles/main/bootstrap.sh)"

set -euo pipefail

REPO_URL="https://github.com/joshsnxw/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m!!\033[0m %s\n" "$*"; }

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found, installing"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew already installed, skipping"
fi

if [[ "$(uname -m)" == "arm64" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi
eval "$("$BREW_PREFIX/bin/brew" shellenv)"

if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  log "Cloning dotfiles into $DOTFILES_DIR"
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  log "Dotfiles already cloned, pulling latest"
  git -C "$DOTFILES_DIR" pull --ff-only || warn "Could not fast-forward, continuing"
fi

cd "$DOTFILES_DIR"

log "Running brew bundle"
brew bundle --file="$DOTFILES_DIR/Brewfile"

if [[ ! -d "$HOME/.nvm" ]]; then
  log "Installing NVM"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  log "NVM already installed, skipping"
fi

if ! command -v pnpm >/dev/null 2>&1; then
  log "Installing pnpm"
  curl -fsSL https://get.pnpm.io/install.sh | sh
else
  log "pnpm already installed, skipping"
fi

if ! command -v uv >/dev/null 2>&1; then
  log "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  log "uv already installed, skipping"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed, skipping"
fi

log "Setting up fzf key bindings"
"$(brew --prefix)/opt/fzf/install" --key-bindings --no-completion --no-update-rc

log "Linking config files"
bash "$DOTFILES_DIR/install/symlinks.sh"

log "Applying macOS defaults"
bash "$DOTFILES_DIR/macos.sh"

log "Done. You may want to restart your shell or log out and back in."
