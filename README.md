# Personal Dotfiles

> Modern, maintainable dotfiles for macOS and Linux using GNU Stow

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 📋 Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications. It uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management, making it easy to install, update, and remove configurations.

### What's Included

- **Shell**: Bash and Zsh configurations with enhanced prompts
- **Window Management**: AeroSpace + universal-layout-manager - cross-platform layout automation
- **Editor**: Neovim (daily driver) and Vim
- **Development**: Git, SSH, GPG, tmux
- **Terminal**: Kitty terminal emulator
- **AI Tooling**: Claude Code, opencode
- **Secrets**: 1Password + GPG-encrypted configs
- **Email**: mbsync, msmtp, mu (email workflow)
- **Other**: YouTube downloader settings

**📖 See [keybindings.md](keybindings.md) for keyboard shortcuts**
**📖 See [docs/setup/window-manager.md](docs/setup/window-manager.md) for window management setup**

## 🚀 Quick Start

Dotfiles are managed by [chezmoi](https://chezmoi.io) (source state in `home/`,
per `.chezmoiroot`). GNU Stow is retired on migrated machines; the `stow-final`
git tag marks the last fully stow-based commit for machines not yet migrated.

### Prerequisites (macOS)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install chezmoi
```

### Installation

1. **Clone this repository** (submodules can be initialized later — a
   chezmoi run_once script handles them)
   ```bash
   git clone https://github.com/k-f-/dotfiles.git ~/Documents/Code/dotfiles
   ```

2. **Point chezmoi at it and apply**
   ```bash
   printf 'sourceDir = "%s"\n' "$HOME/Documents/Code/dotfiles" > ~/.config/chezmoi/chezmoi.toml
   chezmoi doctor     # sanity check
   chezmoi diff       # preview
   chezmoi apply      # deploy configs + run bootstrap scripts (brew bundle, oh-my-zsh, submodules)
   ```

3. **Restart your shell**

### Day-to-day

```bash
chezmoi edit ~/.zshrc   # edit the source, then:
chezmoi apply           # deploy
chezmoi diff            # what would change
chezmoi verify          # drift check ($HOME vs source)
```

Never edit templated files with `chezmoi re-add` (it destroys the template);
use `chezmoi merge` instead.

### Installation Options

```bash
./install [OPTIONS]

OPTIONS:
  --help          Show help message
  --dry-run       Preview changes without making them
  --no-packages   Skip package manager installations
  --minimal       Install only core packages (bash, git, vim, zsh)
  --full          Also install desktop packages (Homebrew Brewfile.desktop)
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

📖 **See [keybindings.md](keybindings.md) for complete reference**

## 📦 Package Structure

### Core Packages (always installed)
- `bash` - Bash shell configuration
- `git` - Git configuration and aliases
- `vim` - Vim/Neovim configuration
- `zsh` - Zsh shell configuration

### Optional Packages (installed by default, skip with `--minimal`)
- `aerospace` - AeroSpace window manager configuration (macOS)
- `aws` - AWS CLI configuration
- `claude-code` - Claude Code configuration
- `gh` - GitHub CLI configuration
- `gnupg` - GPG configuration
- `homebrew` - Homebrew Bundle files (`--full` adds desktop packages)
- `kitty` - Kitty terminal config
- `mackup` - Mackup application settings sync
- `mail` - Email client configs (mbsync, msmtp, mu)
- `opencode` - opencode configuration
- `secrets` - Private, GPG-encrypted configurations
- `ssh` - SSH configuration
- `tmux` - Tmux configuration
- `universal-wm` - Universal window manager configuration (AeroSpace/i3/Sway)
- `vscode` - VS Code configuration
- `yt-dlp` - YouTube downloader config

### Window Management

The repository includes a **universal window manager** that works across platforms:

- **macOS**: Aerospace
- **Linux**: i3, Sway
- **Windows**: komorebi, GlazeWM (planned)

Quick commands:
```bash
# Auto-detects your platform and window manager
universal-wm detect

# List available layouts
universal-wm list

# Apply a layout
universal-wm apply code

# Apply all layouts
universal-wm apply --all
```

See [docs/setup/window-manager.md](docs/setup/window-manager.md) for full documentation.

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

Install core packages:

```bash
brew bundle --file=homebrew/Brewfile.core
```

Add desktop applications too:

```bash
brew bundle --file=homebrew/Brewfile.desktop
```

`./install --full` runs both automatically.

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
├── bash/                       # Bash configuration
│   ├── dot-bashrc
│   ├── dot-bashrc.d/           # Modular bash configs
│   ├── dot-profile
│   └── dot-bin/                # User scripts (→ ~/.bin/)
│       └── universal-wm        # Universal WM CLI
├── zsh/                        # Zsh configuration
│   └── dot-zshrc
├── git/                        # Git configuration
├── vim/                        # Vim/Neovim config
├── kitty/                      # Kitty terminal
├── tmux/                       # Tmux configuration
├── aerospace/                  # AeroSpace config (macOS)
│   └── dot-aerospace.toml      # → ~/.aerospace.toml
├── universal-wm/               # Universal WM config (stow package)
│   └── dot-config/
│       └── universal-wm/
│           └── layouts.json    # → ~/.config/universal-wm/layouts.json
├── universal-layout-manager/   # Universal WM source (not stowed, bun-run)
│   ├── cli.ts                  # Universal CLI
│   ├── adapters/
│   │   ├── aerospace.ts        # macOS adapter (the one that runs)
│   │   └── i3-sway.ts          # Linux adapter
│   └── core/                   # Shared types, platform detection
├── gnupg/                      # GPG configuration
├── ssh/                        # SSH configuration
├── mail/                       # Email configs
├── secrets/                    # Private, GPG-encrypted configurations
├── aws/                        # AWS CLI config
├── gh/                         # GitHub CLI config
├── claude-code/                # Claude Code config
├── opencode/                   # opencode config
├── vscode/                     # VS Code config
├── mackup/                     # Mackup application settings sync
├── yt-dlp/                     # YouTube downloader config
├── homebrew/                   # Homebrew bundles
│   ├── Brewfile.core           # Core packages
│   └── Brewfile.desktop        # Desktop packages (--full)
├── aesthetics/                 # Theme system (submodule)
├── agr-cli/                    # agr archive CLI (submodule)
├── scripts/                    # Installation scripts
├── docs/                       # Documentation
│   ├── setup/                  # User guides
│   └── development/            # Development docs
├── install                     # Unified installer
├── uninstall                   # Uninstaller
└── README.md                   # This file
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

# Then try stowing again (MUST run from dotfiles directory)
cd ~/dotfiles  # or wherever you cloned the repo
stow --target="$HOME" --dotfiles zsh
```

**⚠️ IMPORTANT**: Always run stow from the dotfiles directory root:
```bash
# ✅ CORRECT: Run from dotfiles directory with HOME as target
cd ~/dotfiles
stow --target="$HOME" --dotfiles bash

# ❌ WRONG: Running from parent directory creates symlinks in wrong location
cd ~
stow --target="$HOME" --dotfiles dotfiles/bash  # Don't do this!
```

If you accidentally created symlinks in the wrong location (e.g., `.bashrc` appears in `~/Documents/Code/` instead of just `~`), remove them and re-run the installer:
```bash
cd ~/Documents/Code
rm -f .bashrc .bashrc.d .bin .profile  # Remove incorrect symlinks
cd ~/dotfiles
./install  # Re-run installer to create correct symlinks
```

### Permission Denied

Make sure the install scripts are executable:
```bash
chmod +x install uninstall
```

### Homebrew Bundle Fails

Install packages individually or update the Brewfile:
```bash
brew bundle --file=homebrew/Brewfile.core --no-lock
```

## 📚 Further Reading

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Managing Dotfiles with Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)

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

### Recent Changes

- **2025-10-02**: Complete refactor with new installer, error handling, and documentation
- **2022-05-17**: New personal machine setup
- **2022-01-02**: Updated for Pop-OS, corrected stow usage

---

**Note**: This dotfiles repository is a work in progress and reflects my personal preferences. Your mileage may vary (ymmv).
