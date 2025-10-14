# Personal Dotfiles

> Modern, maintainable dotfiles for macOS and Linux using GNU Stow

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 📋 Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications. It uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management, making it easy to install, update, and remove configurations.

### What's Included

- **Shell**: Bash and Zsh configurations with enhanced prompts
- **Window Management**: AeroSpace (i3-like tiling WM for macOS)
- **Editor**: Vim, Emacs, and Doom Emacs
- **Development**: Git, SSH, GPG
- **Terminal**: Kitty terminal emulator
- **macOS**: Yabai, skhd, Sketchybar
- **Email**: mbsync, msmtp, mu (email workflow)
- **Other**: X11 configs, YouTube downloader settings

**📖 See [keybindings.md](docs/setup/keybindings.md) for complete keyboard shortcuts reference**

## 🚀 Quick Start

### Prerequisites

#### macOS
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Stow
brew install stow
```

#### Debian/Ubuntu
```bash
sudo apt update
sudo apt install stow
```

### Installation

1. **Clone this repository**
   ```bash
   git clone https://github.com/k-f-/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installer**
   ```bash
   # Full installation (recommended)
   ./install

   # Minimal installation (core configs only)
   ./install --minimal

   # Preview changes without applying
   ./install --dry-run
   ```

3. **Restart your shell**
   ```bash
   # For zsh
   source ~/.zshrc

   # For bash
   source ~/.bashrc
   ```

### Installation Options

```bash
./install [OPTIONS]

OPTIONS:
  --help          Show help message
  --dry-run       Preview changes without making them
  --no-packages   Skip package manager installations
  --minimal       Install only core packages (bash, git, vim, zsh)
  --verbose       Show detailed output
  --force         Skip backups and overwrite existing files
```

## ⌨️ Quick Reference

After installation, these shortcuts and commands are immediately available:

### Keyboard Shortcuts (macOS + AeroSpace)
- **`Alt + h/j/k/l`** - Navigate windows (Vim-style)
- **`Alt + Tab`** - Switch between workspaces
- **`Alt + \``** - Cycle windows within same app (native macOS)
- **`Alt + 1-6`** - Jump to workspace 1-6
- **`Alt + Shift + o`** - Apply all workspace layouts (organize windows)
- **`Alt + Shift + d`** - Open dotfiles in editor
- **`Cmd + Enter`** - Open terminal

### Terminal Commands & Aliases
```bash
dotfiles      # Open dotfiles directory in editor
dots          # Short alias
gs            # git status -s
gg            # git grep -n
em            # Smart editor (VS Code → neovim → vim)
```

### Terminal Shortcuts
- **`Ctrl + r`** - Fuzzy search command history
- **`Up/Down`** - Search history by prefix
- **`Ctrl + Space`** - Accept autosuggestion

📖 **See [KEYBINDINGS.md](KEYBINDINGS.md) for complete reference**

## 📦 Package Structure

### Core Packages (always installed)
- `bash` - Bash shell configuration
- `git` - Git configuration and aliases
- `vim` - Vim/Neovim configuration
- `zsh` - Zsh shell configuration

### Optional Packages (installed by default, skip with `--minimal`)
- `emacs` - Emacs configuration
- `doom` - Doom Emacs configuration
- `kitty` - Kitty terminal config
- `gnupg` - GPG configuration
- `mail` - Email client configs (mbsync, msmtp, mu)
- `ssh` - SSH configuration
- `yabai` - macOS tiling window manager
- `skhd` - macOS hotkey daemon
- `sketchybar` - macOS status bar
- `x-windows` - X11 configurations
- `secrets` - Private configurations
- `youtube-dl` - YouTube downloader config

## 🔧 Manual Configuration

### macOS System Preferences

The repository includes a script to configure macOS system preferences (requires manual execution):

```bash
bash scripts/install-mac.sh
```

This will:
- Set screenshot location and format
- Configure Finder preferences
- Disable animations
- Set keyboard repeat rate
- Configure Dock behavior
- And much more...

**Note:** This modifies system preferences. Review the script before running.

### Homebrew Bundle

Install all macOS applications and packages:

```bash
cd homebrew
brew bundle
```

This installs everything defined in `homebrew/Brewfile`.

## 🗑️ Uninstallation

To remove all symlinks created by this dotfiles setup:

```bash
./uninstall

# Preview what would be removed
./uninstall --dry-run

# Skip confirmation prompt
./uninstall --force
```

This removes the symlinks but keeps your dotfiles repository intact.

## 📁 Repository Structure

```
dotfiles/
├── bash/              # Bash configuration
│   ├── .bashrc
│   ├── .bashrc.d/     # Modular bash configs
│   └── .profile
├── zsh/               # Zsh configuration
│   ├── .zshrc
│   └── .zshrc.d/      # Modular zsh configs
├── git/               # Git configuration
├── vim/               # Vim/Neovim config
├── emacs/             # Emacs configuration
├── doom/              # Doom Emacs config
├── kitty/             # Kitty terminal
├── yabai/             # macOS window manager
├── skhd/              # macOS hotkey daemon
├── sketchybar/        # macOS status bar
├── gnupg/             # GPG configuration
├── ssh/               # SSH configuration
├── mail/              # Email configs
├── secrets/           # Private configurations
├── homebrew/          # Homebrew bundle
│   └── Brewfile       # macOS packages
├── scripts/           # Installation scripts
│   ├── install.sh           # Legacy installer
│   ├── install-mac.sh       # macOS preferences
│   └── install-debian-packages.sh
├── install            # New unified installer
├── uninstall          # Uninstaller
└── README.md          # This file
```

## 🛠️ Customization

### Adding New Configurations

1. Create a new directory for your config:
   ```bash
   mkdir -p ~/.dotfiles/newapp
   ```

2. Add your config files with dots in the filename:
   ```bash
   # Stow will create ~/.config/newapp/config
   mkdir -p ~/.dotfiles/newapp/dot-config/newapp
   echo "setting=value" > ~/.dotfiles/newapp/dot-config/newapp/config
   ```

3. Stow the package:
   ```bash
   cd ~/.dotfiles
   stow --target="$HOME" --dotfiles newapp
   ```

4. Add it to the installer by editing `install` and adding `newapp` to the package list.

### Modifying Existing Configs

Just edit the files in `~/.dotfiles/` and the changes will be reflected immediately (since they're symlinked to your home directory).

## 💡 Tips & Tricks

### Selective Installation

Install only specific packages:
```bash
cd ~/.dotfiles
stow --target="$HOME" --dotfiles zsh git vim
```

### Removing a Package

```bash
cd ~/.dotfiles
stow --delete --target="$HOME" packagename
```

### Finding Broken Symlinks

```bash
find ~ -maxdepth 3 -xtype l
```

### Testing on a Clean System

Use Docker or a VM:
```bash
# Using Docker
docker run -it --rm -v $(pwd):/dotfiles ubuntu:latest bash
cd /dotfiles
./install --minimal
```

## 🐛 Troubleshooting

### Stow Complains About Existing Files

The installer should automatically backup conflicting files, but if you run stow manually:

```bash
# Move the conflicting file
mv ~/.zshrc ~/.zshrc.backup

# Then try stowing again
stow --target="$HOME" --dotfiles zsh
```

### Permission Denied

Make sure the install scripts are executable:
```bash
chmod +x install uninstall
```

### Homebrew Bundle Fails

Install packages individually or update the Brewfile:
```bash
brew bundle --file=homebrew/Brewfile --no-lock
```

## 📚 Further Reading

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Managing Dotfiles with Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)

## 🔄 Migration from Old Setup

If you're coming from the old install scripts:

1. **Backup your current setup**
   ```bash
   cp -r ~/.dotfiles ~/.dotfiles.backup
   ```

2. **Pull the latest changes**
   ```bash
   cd ~/.dotfiles
   git pull origin refactor/improvements
   ```

3. **Unstow old configs** (if you used the old scripts)
   ```bash
   # The new uninstall script will handle this
   ./uninstall
   ```

4. **Run the new installer**
   ```bash
   ./install
   ```

## 📝 Notes

- **Backups**: The installer automatically backs up conflicting files to `~/.dotfiles-backup-TIMESTAMP/`
- **Platform Detection**: The installer automatically detects macOS vs Linux
- **Idempotent**: Safe to run multiple times
- **Dry Run**: Always test with `--dry-run` first on a new system

## 📜 License

MIT License - feel free to use and modify as needed.

## 🤝 Contributing

This is a personal dotfiles repo, but feel free to:
- Open issues for bugs or suggestions
- Fork for your own use
- Submit PRs for general improvements

## 📖 Changelog

See [REFACTOR_PLAN.md](REFACTOR_PLAN.md) for detailed improvement plans and changes.

### Recent Changes

- **2025-10-02**: Complete refactor with new installer, error handling, and documentation
- **2022-05-17**: New personal machine setup
- **2022-01-02**: Updated for Pop-OS, corrected stow usage

---

**Note**: This dotfiles repository is a work in progress and reflects my personal preferences. Your mileage may vary (ymmv).
