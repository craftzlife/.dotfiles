#!/bin/bash

# Go to the installed dotfiles repository
cd ~/.dotfiles

# Pull the latest changes and update submodules
git pull --recurse-submodules --depth=5

# Remove existing stowed symlinks for a clean reapply
stow -D . -t ~

# Restow the current dotfiles into the home directory
stow . -t ~

echo "Successfully updated .dotfiles!"