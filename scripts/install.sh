#!/bin/bash

# If Zshell is not installed, warn the user and exit
if ! command -v zsh &> /dev/null
then
    echo "Zshell is not installed. Please install Zshell and try again."
    exit 1
fi

# Load shared prerequisite functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/prereqs.sh"
ensure_prereqs

# Clone the dotfiles repository, including submodules
echo "Cloning dotfiles repository with submodules..."
git clone --recurse-submodules https://github.com/craftzlife/.dotfiles.git ~/.dotfiles

# Final Step: Apply dotfiles
echo "Applying dotfiles with GNU Stow..."
cd ~/.dotfiles
# stow . and display the created symlinks
stow . -t ~  --verbose

echo "Installation complete!"

# Create .zshrc.local if it doesn't exist
if [ ! -f ~/.config/zsh/.zshrc.local ]; then
    touch ~/.config/zsh/.zshrc.local
    echo "Created ~/.config/zsh/.zshrc.local for local configuration."
fi
# Display usage instructions for .zshrc.local
echo "Add any local configuration to ~/.config/zsh/.zshrc.local (this file is ignored by git) and it will be sourced automatically when you start a new terminal session."