#!/bin/bash

ensure_prereqs() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
      echo "Homebrew is not installed. Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing git, curl, stow, fzf, nvim via Homebrew..."
    brew install git curl stow fzf nvim
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      case "$ID" in
        ubuntu)
          sudo apt update
          echo "Installing git, curl, stow, fzf, neovim via apt..."
          sudo apt install -y git curl stow fzf neovim
          ;;
        *)
          echo "Unsupported Linux distribution: $ID"
          exit 1
          ;;
      esac
    else
      echo "Cannot determine Linux distribution. Please install git, curl, and stow manually."
      exit 1
    fi
  else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}