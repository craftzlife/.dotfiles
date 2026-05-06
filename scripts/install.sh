#!/bin/bash

set -e

# ============================================================================
# Utility Functions
# ============================================================================

log() {
  echo "[dotfiles] $*"
}

error() {
  echo "[dotfiles] ERROR: $*" >&2
  exit 1
}

# ============================================================================
# Prerequisites Check
# ============================================================================

check_zsh() {
  if command -v zsh &>/dev/null || [ -x /bin/zsh ] || [ -x /usr/bin/zsh ] || [ -x /home/linuxbrew/.linuxbrew/bin/zsh ]; then
    log "Zshell is installed."
  else
    error "Zshell is not installed. Please install Zshell and try again."
  fi
}

# ============================================================================
# Update Logic
# ============================================================================

handle_update() {
  log "Dotfiles already installed. Updating..."
  cd ~/.dotfiles

  log "Pulling latest changes..."
  git pull --recurse-submodules --depth=5

  log "Removing existing symlinks..."
  stow -D . -t ~ --verbose

  log "Reapplying symlinks..."
  stow . -t ~ --verbose

  setup_zprofile_local
  setup_zsh_history
  log "Successfully updated dotfiles!"
}

# ============================================================================
# Platform-Specific Installation
# ============================================================================

install_homebrew() {
  log "Homebrew is not installed. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_prerequisites_macos() {
  log "Installing prerequisites on macOS..."

  if ! command -v brew &>/dev/null; then
    install_homebrew
  fi

  log "Installing git, curl, stow, fzf, nvim via Homebrew..."
  brew install git stow fzf nvim ripgrep
}

install_prerequisites_ubuntu() {
  log "Installing prerequisites on Ubuntu..."

  sudo apt update
  log "Installing git, curl, stow, fzf, neovim via apt..."
  sudo apt install -y git stow fzf neovim ripgrep
}

install_prerequisites() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    install_prerequisites_macos
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      case "$ID" in
      ubuntu)
        install_prerequisites_ubuntu
        ;;
      *)
        error "Unsupported Linux distribution: $ID"
        ;;
      esac
    else
      error "Cannot determine Linux distribution. Please install git, curl, and stow manually."
    fi
  else
    error "Unsupported operating system: $OSTYPE"
  fi
}

# ============================================================================
# Dotfiles Installation
# ============================================================================

clone_dotfiles() {
  log "Cloning dotfiles repository with submodules..."
  git clone --recurse-submodules https://github.com/craftzlife/.dotfiles.git ~/.dotfiles
}

apply_dotfiles() {
  log "Applying dotfiles with GNU Stow..."
  cd ~/.dotfiles
  stow . -t ~ --verbose
  log "Installation complete!"
}

# ============================================================================
# Configuration Setup
# ============================================================================

setup_zshrc_local() {
  if [ ! -f ~/.config/zsh/.zshrc.local ]; then
    mkdir -p ~/.config/zsh
    touch ~/.config/zsh/.zshrc.local
    log "Created ~/.config/zsh/.zshrc.local for local configuration."
  fi
  log "Add any local configuration to ~/.config/zsh/.zshrc.local (this file is ignored by git) and it will be sourced automatically when you start a new terminal session."
}

setup_zprofile_local() {
  if [[ "$OSTYPE" != "darwin"* ]]; then
    return 0
  fi

  local zprofile_local="$HOME/.config/zsh/.zprofile.local"
  local brew_eval='eval "$(/opt/homebrew/bin/brew shellenv)"'

  mkdir -p "$(dirname "$zprofile_local")"

  if [ ! -f "$zprofile_local" ]; then
    echo "$brew_eval" >"$zprofile_local"
    log "Created $zprofile_local with Homebrew shell environment."
  elif ! grep -qF "brew shellenv" "$zprofile_local"; then
    echo "$brew_eval" >>"$zprofile_local"
    log "Added Homebrew shell environment to $zprofile_local."
  else
    log "Homebrew shell environment already configured in $zprofile_local."
  fi
}

setup_zsh_history() {
  mkdir -p ~/.local/share/zsh
  if [ ! -f ~/.local/share/zsh/zsh_history ]; then
    touch ~/.local/share/zsh/zsh_history
    log "Created ~/.local/share/zsh/zsh_history for persistent shell history."
  fi
}

# ============================================================================
# Main
# ============================================================================

main() {
  install_prerequisites
  check_zsh

  # Check if already installed
  if [ -d ~/.dotfiles ]; then
    handle_update
    return 0
  fi

  # Fresh installation
  clone_dotfiles
  apply_dotfiles
  setup_zprofile_local
  setup_zsh_history
  setup_zshrc_local
}

main
