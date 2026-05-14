#!/usr/bin/env bash
# Symlink everything in config/ into $HOME, backing up any pre-existing files.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m!!\033[0m %s\n" "$*"; }

link_one() {
  local src="$1"
  local rel="${src#"$CONFIG_DIR"/}"
  local dest="$HOME/$rel"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    log "Already linked: $rel"
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    warn "Backing up existing $dest"
    mv "$dest" "$BACKUP_DIR/$rel"
  fi

  ln -s "$src" "$dest"
  log "Linked $rel"
}

# Walk every regular file under config/ so nested paths (e.g. .ssh/config) get linked individually.
while IFS= read -r -d '' file; do
  link_one "$file"
done < <(find "$CONFIG_DIR" -type f -print0)

if [[ -d "$BACKUP_DIR" ]]; then
  log "Existing files backed up to $BACKUP_DIR"
fi
