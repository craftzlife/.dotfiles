#!/bin/bash

# Change to the installed dotfiles repository
cd ~/.dotfiles

# Remove stowed symlinks from the home directory
stow -D . -t ~

echo "Dotfiles uninstalled!"
echo "To remove the dotfiles repository, run: `cd ~ && rm -rf ~/.dotfiles`"