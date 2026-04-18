#!/bin/bash

# If Zshell is not installed, warn the user and exit
if ! command -v zsh &> /dev/null
then
    echo "Zshell is not installed. Please install Zshell and try again."
    exit 1
fi

# Install prerequisites for MacOS, Ubuntu
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Check if Homebrew is installed, if not install it
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing git, curl, stow, fzf via Homebrew..."
    brew install git curl stow fzf
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu)
                sudo apt update
                echo "Installing git, curl, stow, fzf via apt..."
                sudo apt install -y git curl stow fzf
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

# Clone the dotfiles repository, including submodules
echo "Cloning dotfiles repository with submodules..."
git clone --recurse-submodules https://github.com/craftzlife/.dotfiles.git ~/.dotfiles

# Final Step: Apply dotfiles
echo "Applying dotfiles with GNU Stow..."
cd ~/.dotfiles
# stow . and display the created symlinks
stow . -t ~

echo "Installation complete!"