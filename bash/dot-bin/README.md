# Editor Launcher Scripts

This directory contains smart editor launcher scripts that work across macOS, Linux, and other Unix-like systems.

## Scripts

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

## See Also

- Other scripts in this directory: `checkmail`, `extract`, `screenshot`, etc.
- Main dotfiles README: `../../README.md`
