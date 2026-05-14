#!/usr/bin/env bash
# Apply opinionated macOS defaults.
# Re-running is safe: each `defaults write` just overwrites the value.

set -euo pipefail

log() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }

log "Trackpad: tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

log "Mission Control: fixed space order"
defaults write com.apple.dock mru-spaces -bool false

log "Dock: auto-hide and resize"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 32

log "Finder: show extensions and hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

log "Screenshots: save to ~/Downloads"
defaults write com.apple.screencapture location -string "$HOME/Downloads"

log "Restarting Dock and Finder"
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

log "macOS defaults applied"
