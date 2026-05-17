# ~/.zshrc -- managed by dotfiles

# Homebrew (must come before $PATH-dependent tools)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell-chevron"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# zsh-syntax-highlighting (must be sourced after oh-my-zsh)
[[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# History (override OMZ defaults)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# Tools
[[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]] && \
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# uv
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ll='eza -lah --git --group-directories-first'
alias ls='eza'
alias cat='bat --paging=never'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gs='git status'
