# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start (Automated)

You can install all dependencies and apply the dotfiles automatically using the provided installation script:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/craftzlife/.dotfiles/main/install.sh)"
```

Or, if you have already cloned the repository:

```bash
./install.sh
```

## Manual Installation

To symlink the configuration files to your home directory manually, run the following command from the root of this repository:

```bash
stow . -t ~
```

This will create the following symlinks in your home directory:
- `~/.zshenv` -> `~/.dotfiles/.zshenv`
- `~/.config/zsh/` -> `~/.dotfiles/.config/zsh/`

### Specific Commands

To remove the symlinks:

```bash
stow -D . -t ~
```
