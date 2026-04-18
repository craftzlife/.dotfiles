# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start (Automated)

Install or update dotfiles in one command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/craftzlife/.dotfiles/main/scripts/install.sh)"
```

Or, if you have already cloned the repository:

```bash
./scripts/install.sh
```

Running `install.sh` again will automatically detect an existing installation and update instead.

## Available Commands

### Install or Update Dotfiles
```bash
~/.dotfiles/scripts/install.sh
```
- First run: installs prerequisites, clones repo, applies symlinks
- Subsequent runs: detects existing installation and updates (git pull + restow)

### Uninstall Dotfiles
```bash
~/.dotfiles/scripts/uninstall.sh
```

## Scripts

All scripts are in the `scripts/` directory:

- `scripts/install.sh` - Unified install/update script:
  - Modular design with separate functions for each step
  - Auto-detects existing installation and runs update flow instead
  - Installs OS prerequisites (macOS/Ubuntu)
  - Clones repository with submodules
  - Applies dotfiles via GNU Stow
  - Initializes local config file
- `scripts/uninstall.sh` - Removes all stowed symlinks

## Manual Installation

To manually symlink configuration files without using the installer script:

```bash
cd ~/.dotfiles
stow . -t ~ --verbose
```

To remove all symlinks:

```bash
cd ~/.dotfiles
stow -D . -t ~ --verbose
```

## Docker Testing

Build the test image:
```bash
docker build -t dotfiles-test .
```

**Test fresh install:**
```bash
docker run --rm -e MODE=install -v "$(pwd)":/workspace -v dotfiles_home:/home/tester -it dotfiles-test
```

**Test update flow** (run after fresh install):
```bash
docker run --rm -e MODE=update -v "$(pwd)":/workspace -v dotfiles_home:/home/tester -it dotfiles-test
```

**Test uninstall:**
```bash
docker run --rm -e MODE=uninstall -v "$(pwd)":/workspace -v dotfiles_home:/home/tester -it dotfiles-test
```

The `dotfiles_home` named volume persists `/home/tester` across test runs, allowing you to test the full lifecycle (install → update → uninstall).

## Supported Platforms

- **macOS** - Uses Homebrew for package installation
- **Ubuntu/Linux** - Uses apt for package installation

Prerequisites installed:
- git
- curl
- stow
- fzf
- nvim

## Configuration

### Local Shell Configuration

Add any local shell configuration to `~/.config/zsh/.zshrc.local` (git-ignored). It will be sourced automatically on shell startup:

```bash
echo "export CUSTOM_VAR=value" >> ~/.config/zsh/.zshrc.local
```

## Implementation Details

### Modular Design

`scripts/install.sh` is organized into logical functions:
- Utility functions: `log()`, `error()` for consistent messaging
- Prerequisite checks: `check_zsh()`
- Update logic: `handle_update()` (runs if dotfiles already installed)
- Platform-specific installation: `install_prerequisites_macos()`, `install_prerequisites_ubuntu()`
- Setup functions: `clone_dotfiles()`, `apply_dotfiles()`, `setup_zshrc_local()`
- Main orchestrator: `main()`

This modular approach makes the script easy to test, maintain, and extend.

### How It Works

1. **Check if Zshell is installed** - Required for the dotfiles to work
2. **Auto-detect existing installation** - If `~/.dotfiles` exists, run update flow:
   - Pull latest changes from git
   - Remove and reapply symlinks
3. **Fresh install flow** - If `~/.dotfiles` doesn't exist:
   - Install OS-specific prerequisites (Homebrew on macOS, apt on Ubuntu)
   - Clone the repository with submodules
   - Apply dotfiles via GNU Stow
   - Initialize `~/.config/zsh/.zshrc.local` for local config

## Stow Ignore Patterns

Files matching `.stow-local-ignore` patterns are excluded from symlinking:
- `.git`, `.DS_Store`
- `README.md`, `Dockerfile`
- `scripts/` directory
- `.gitignore`, `.gitmodules`
- `*.local` files
