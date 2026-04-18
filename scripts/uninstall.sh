#!/bin/bash

# Change to the installed dotfiles repository
cd ~/.dotfiles

# Remove stowed symlinks from the home directory
stow -D . -t ~ --verbose

echo "Dotfiles uninstalled!"

# Check if there are any local modifications
if git status --porcelain | grep -q .; then
    echo "Warning: You have local modifications to the dotfiles."
    echo "Please review the changes with: 'cd ~/.dotfiles && git status'"
    echo "To remove the dotfiles repository manually, run: 'rm -rf ~/.dotfiles'"
else
    echo "No local modifications detected. Removing dotfiles repository..."
    cd ~
    rm -rf ~/.dotfiles
    echo "Dotfiles repository removed successfully."
fi