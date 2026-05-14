# dotfiles

Personal macOS setup, automated. Run one command on a fresh machine and walk away.

## Install on a fresh machine

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/joshsnxw/dotfiles/main/bootstrap.sh)"
```

That single command:

1. Installs Homebrew if it isn't already.
2. Clones this repo into `~/dotfiles`.
3. Runs `brew bundle` to install everything in the `Brewfile`.
4. Installs NVM, pnpm, and uv.
5. Installs Oh My Zsh and sets up fzf key bindings.
6. Symlinks the files under `config/` into `$HOME`.
7. Applies the macOS defaults in `macos.sh`.

The script is idempotent: re-running it just installs anything new and reapplies the defaults.

## What each file does

| Path | Purpose |
| --- | --- |
| `bootstrap.sh` | Top-level entrypoint. Installs Homebrew, clones the repo, runs the rest. |
| `Brewfile` | Declarative list of CLI tools and apps installed via `brew bundle`. |
| `macos.sh` | `defaults write` calls for Dock, Finder, screenshots, and trackpad. |
| `install/symlinks.sh` | Symlinks every file under `config/` into `$HOME`, backing up anything in the way. |
| `config/.zshrc` | Shell config: Homebrew, Oh My Zsh, history, fzf, NVM, pnpm, uv, aliases. |
| `config/.gitconfig` | Git defaults: `main` default branch, auto remote setup, prune on fetch. |
| `config/.ssh/config` | SSH defaults: keychain integration, ed25519 identity file. |

## After installing

- Generate an SSH key (`ssh-keygen -t ed25519`) if you don't already have one and add it to GitHub.
- Sign into the apps installed by the Brewfile (1Password, Raycast, etc.).
- Re-run `bash ~/dotfiles/bootstrap.sh` any time to pull and apply updates.

## Backups

`install/symlinks.sh` never clobbers existing files. Anything in the way is moved to `~/.dotfiles-backup/<timestamp>/` before the symlink is created.
