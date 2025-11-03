# Universal Window Manager - Stow Package

This stow package contains the universal window manager configuration.

## Structure

```
universal-wm/
├── dot-config/
│   └── universal-wm/
│       └── layouts.json    # → ~/.config/universal-wm/layouts.json
└── README.md
```

## Installation

```bash
# From dotfiles directory
stow --dotfiles universal-wm

# This creates:
# ~/.config/universal-wm/layouts.json
```

## Usage

See the main universal-layout-manager documentation:
- [Quickstart Guide](../universal-layout-manager/QUICKSTART.md)
- [Full README](../universal-layout-manager/README.md)

## Commands

```bash
# List layouts
universal-wm list

# Apply a layout
universal-wm apply code

# Apply all layouts
universal-wm apply --all
```

## Editing Configuration

Edit `~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json` and re-stow:

```bash
cd ~/dotfiles
stow --dotfiles -R universal-wm
```

Or edit the symlinked file directly at `~/.config/universal-wm/layouts.json`.
