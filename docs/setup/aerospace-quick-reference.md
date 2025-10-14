# AeroSpace Layout Manager - Quick Reference

## Installation

### Option 1: Global Install (Simplest)
```bash
curl -fsSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash
```

### Option 2: Git Submodule (Version Controlled)
```bash
cd ~/dotfiles
git submodule add https://github.com/CarterMcAlister/aerospace-layout-manager.git
cd aerospace-layout-manager
bun install && bun link
```

## Usage

```bash
# Apply single layout
aerospace-layout apply comms
aerospace-layout apply code

# Apply all layouts at once
aerospace-layout apply-all

# Get help
aerospace-layout --help
```

## Available Layouts

Defined in `~/dotfiles/aerospace/layouts.json`:

| Name | Workspace | Description |
|------|-----------|-------------|
| `comms` | 2 | Messages + Signal + Spotify |
| `code` | 4 | VS Code + Terminal |
| `browser` | 3 | Firefox |
| `org` | 5 | Calendar + Mail |
| `start` | 1 | Finder + Activity Monitor |

## Keyboard Shortcuts

Add to `~/.config/aerospace/aerospace.toml`:

```toml
# Quick layout switching
alt-shift-1 = ['workspace 1', 'exec-and-forget aerospace-layout apply start']
alt-shift-2 = ['workspace 2', 'exec-and-forget aerospace-layout apply comms']
alt-shift-3 = ['workspace 3', 'exec-and-forget aerospace-layout apply browser']
alt-shift-4 = ['workspace 4', 'exec-and-forget aerospace-layout apply code']
alt-shift-5 = ['workspace 5', 'exec-and-forget aerospace-layout apply org']

# Restore all layouts
alt-shift-r = ['exec-and-forget aerospace-layout apply-all']
```

## Common Tasks

### Update Layouts

1. Edit: `~/dotfiles/aerospace/layouts.json`
2. Copy: `cp ~/dotfiles/aerospace/layouts.json ~/.config/aerospace/`
3. Apply: `aerospace-layout apply-all`

### Update Submodule

```bash
cd ~/dotfiles/aerospace-layout-manager
git pull origin main
bun install
```

### Find App Bundle IDs

```bash
osascript -e 'id of app "Slack"'
# Output: com.tinyspeck.slackmacgap
```

## Troubleshooting

### Command not found

```bash
# Check Bun is installed
which bun

# If not, install it
curl -fsSL https://bun.sh/install | bash

# Restart shell
exec $SHELL
```

### Layout doesn't apply

- Ensure apps are running before applying layout
- Check bundleId is correct: `osascript -e 'id of app "AppName"'`
- Verify JSON syntax: `jq . ~/.config/aerospace/layouts.json`

### Submodule is empty

```bash
cd ~/dotfiles
git submodule update --init --recursive
```

## Files

```
~/dotfiles/
├── aerospace/
│   └── layouts.json                    # Your layout definitions (edit this)
├── bash/dot-bin/
│   ├── aerospace-layout                # Command you use
│   └── aerospace-layout-manager-wrapper # Wrapper with fallback logic
└── aerospace-layout-manager/           # Git submodule (optional)

~/.config/aerospace/
└── layouts.json                        # Active layouts (copied from dotfiles)
```

## Documentation

- **Full Guide**: `~/dotfiles/aerospace/README.md`
- **Setup Guide**: `~/dotfiles/AEROSPACE_LAYOUT_MANAGER_SETUP.md`
- **Issue Resolution**: `~/dotfiles/ISSUE_4_RESOLUTION.md`
- **Submodule Update**: `~/dotfiles/ISSUE_4_SUBMODULE_UPDATE.md`
