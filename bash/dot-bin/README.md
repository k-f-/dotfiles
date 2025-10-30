# User Scripts

This directory contains utility scripts for dotfiles management, window organization, theme switching, and editor launching.

## Window Management

### `aerospace-organize` - AeroSpace Layout Manager

Organize windows into predefined layouts using AeroSpace window manager.

**Usage:**
```bash
aerospace-organize                    # Interactive layout selection
aerospace-organize --layout comms     # Apply specific layout
aerospace-organize --no-launch        # Organize only, don't launch apps
```

**Features:**
- Predefined layouts for different workflows (comms, dev, etc.)
- Automatic app launching and workspace assignment
- Integration with AeroSpace layout manager submodule

**Configuration:**
- Layouts defined in `~/.config/aerospace/layouts.json`
- See `aerospace-layout-manager` submodule for details

### `aerospace-organize-wrapper` - AeroSpace Wrapper

Thin wrapper that passes arguments to `aerospace-organize`. Used for keybindings.

### `aerospace-organize-comms` - Communications Layout

Pre-configured script to apply the communications layout (Slack, email, etc.).

## Theme Management

### `toggle-theme` - Theme Switcher

Toggle between light and dark themes across all configured applications.

**Usage:**
```bash
toggle-theme        # Toggle between light/dark
```

**Supported applications:**
- Kitty terminal
- Additional apps via aesthetics submodule

**Implementation:**
- Wrapper for `aesthetics/scripts/toggle-theme.sh`
- Automatically resolves symlinks to find aesthetics submodule
- Sends macOS notification on theme change

**Keybinding:**
- AeroSpace: `Option+Shift+;` then `t`

## Editor Scripts

### `em` - Universal Editor Launcher

Smart editor launcher with fallback priority:

1. **Visual Studio Code** (preferred)
2. **Neovim** (with config support from `~/.config/nvim`)
3. **Vim**
4. **Emacs** (last resort)

**Usage:**
```bash
em file.txt
em .                    # Open current directory
em /path/to/file
```

**Cross-platform support:**
- macOS: Checks multiple VS Code installation locations
- Linux: Supports `code` and `code-insiders`
- Windows (Git Bash/WSL): Supports `code.cmd`

### `eem` - Emacs Client Launcher

Dedicated Emacs launcher using emacsclient for fast startup.

**Usage:**
```bash
eem file.txt
eem /path/to/file
```

**Features:**
- Connects to existing Emacs server if running
- Starts new Emacs instance if no server exists
- Creates new frame for each file
- Runs in background (doesn't block terminal)

**Emacs server setup:**
Add to your Emacs config (`~/.emacs` or `~/.emacs.d/init.el`):
```elisp
(server-start)
```

## Installation

These scripts are automatically installed via the dotfiles `install` script using GNU Stow.

Manual installation:
```bash
# Make executable
chmod +x em eem

# Add to PATH (if not already via dotfiles)
ln -s ~/Documents/Code/dotfiles/bash/dot-bin/em ~/.local/bin/em
ln -s ~/Documents/Code/dotfiles/bash/dot-bin/eem ~/.local/bin/eem
```

## Neovim Configuration

If you have a Neovim config at `~/.config/nvim`, the `em` script will automatically use it.

To set up a basic Neovim config:
```bash
mkdir -p ~/.config/nvim
# Add your init.lua or init.vim
```

## Environment Variables

The scripts respect these standard environment variables:
- `NVIM_APPNAME` - Neovim app name (set by script if config exists)

## Troubleshooting

### "No editor found" error
Install one of the supported editors:
```bash
# macOS
brew install --cask visual-studio-code
brew install neovim

# Linux (Debian/Ubuntu)
sudo apt install code neovim

# Linux (Fedora)
sudo dnf install code neovim
```

### VS Code not detected on macOS
The script checks these locations:
- `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`
- `/Applications/Visual Studio Code - Insiders.app/...`
- `~/Applications/Visual Studio Code.app/...`
- `/usr/local/bin/code`
- `/opt/homebrew/bin/code`

If installed elsewhere, add it to your PATH or symlink to one of these locations.

### Emacs server not starting
Make sure Emacs server is enabled in your config:
```elisp
;; In ~/.emacs or ~/.emacs.d/init.el
(server-start)
```

Or start manually:
```bash
emacs --daemon
```

## System Utilities

### `extract` - Universal Archive Extractor

Extract any archive format with automatic detection.

**Usage:**
```bash
extract archive.tar.gz
extract file.zip
extract package.deb
```

**Supported formats:**
- tar (`.tar`, `.tar.gz`, `.tgz`, `.tar.bz2`, `.tbz2`, `.tar.xz`, `.txz`)
- zip (`.zip`)
- rar (`.rar`)
- 7z (`.7z`)
- deb/rpm packages
- And more...

### `lock` - Screen Locker

Lock the screen using native OS tools.

**Usage:**
```bash
lock
```

**Platform support:**
- macOS: Uses `pmset displaysleepnow`
- Linux: Uses `loginctl lock-session` or `xdg-screensaver lock`
- Windows (Git Bash/WSL): Uses `rundll32.exe`

### `screenshot` - Screenshot Tool

Cross-platform screenshot capture.

### `checkmail` - Mail Checker

Check for new mail (requires mail configuration).

### `set-wallpaper` - Wallpaper Setter

Set desktop wallpaper from aesthetics/wallpapers.

### `set-capslock` - Caps Lock Manager

Enable/disable Caps Lock programmatically.

### `wake-set-capslock` - Wake Handler

Re-enable Caps Lock after system wake (for macOS sleep/wake cycle).

## Removed Scripts

See `REMOVED_BINARIES.md` for documentation of scripts that were archived or replaced:
- `diff-so-fancy` - Now installed via package manager
- `gotop` - Now installed via package manager
- Display management scripts - Archived (use built-in display settings)

## See Also

- Main dotfiles README: `../../README.md`
- AeroSpace setup guide: `../../docs/setup/aerospace-layout-manager.md`
- AeroSpace quick reference: `../../docs/setup/aerospace-quick-reference.md`
- Keybindings reference: `../../docs/setup/keybindings.md`
