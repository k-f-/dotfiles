# Universal Window Manager - Installation Guide

## Quick Install (Stow Method) ✅ RECOMMENDED

If you're using the dotfiles repository with stow:

```bash
cd ~/dotfiles

# Stow the configuration
stow --dotfiles universal-wm

# This creates:
# ~/.config/universal-wm/layouts.json → dotfiles/universal-wm/dot-config/universal-wm/layouts.json

# Install the CLI symlink (if not already done)
ln -sf ~/dotfiles/universal-layout-manager/cli.ts ~/.bin/universal-wm

# Test it
universal-wm detect
universal-wm list
```

## Directory Structure

### Stow Package (Configuration)

```
dotfiles/
└── universal-wm/                           # Stow package
    ├── dot-config/
    │   └── universal-wm/
    │       └── layouts.json                # Your config
    ├── .stow-local-ignore
    └── README.md
```

**After stowing**:
```
~/.config/universal-wm/layouts.json → ~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json
```

### Layout Manager (Code)

```
dotfiles/
└── universal-layout-manager/               # Not stowed (code directory)
    ├── cli.ts                              # Universal CLI
    ├── migrate-config.ts                   # Migration tool
    ├── core/
    │   └── types.ts                        # Shared types
    ├── adapters/
    │   ├── aerospace.ts                    # macOS adapter
    │   ├── i3-sway.ts                      # Linux adapter
    │   ├── komorebi.ts                     # Windows (planned)
    │   └── glazewm.ts                      # Windows (planned)
    ├── README.md
    ├── QUICKSTART.md
    ├── IMPLEMENTATION_STATUS.md
    └── TESTING_RESULTS.md
```

**CLI symlink**:
```
~/.bin/universal-wm → ~/dotfiles/universal-layout-manager/cli.ts
```

## Installation Methods

### Method 1: Full Dotfiles Setup (Recommended)

If you have the full dotfiles repo:

```bash
cd ~/dotfiles

# 1. Stow the config
stow --dotfiles universal-wm

# 2. Create CLI symlink (if not exists)
ln -sf ~/dotfiles/universal-layout-manager/cli.ts ~/.bin/universal-wm

# 3. Update existing scripts (already done if you pulled latest)
# ~/.bin/aerospace-organize now uses the new adapter

# 4. Test
universal-wm detect
universal-wm list
universal-wm apply code
```

### Method 2: Manual Installation

If you want to install without stow:

```bash
# 1. Create config directory
mkdir -p ~/.config/universal-wm

# 2. Copy or create config
cp ~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json \
   ~/.config/universal-wm/layouts.json

# 3. Create CLI symlink
ln -sf ~/dotfiles/universal-layout-manager/cli.ts ~/.bin/universal-wm

# 4. Make it executable
chmod +x ~/.bin/universal-wm

# 5. Test
universal-wm --version
```

### Method 3: Fresh Migration

If you're migrating from old aerospace-layout-manager:

```bash
# 1. Run migration
universal-wm migrate

# This will:
# - Read ~/.config/aerospace/layouts.json
# - Convert to universal format
# - Write to ~/.config/universal-wm/layouts.json

# 2. Move to stow directory
mkdir -p ~/dotfiles/universal-wm/dot-config/universal-wm
mv ~/.config/universal-wm/layouts.json \
   ~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json

# 3. Stow it
cd ~/dotfiles
stow --dotfiles universal-wm

# 4. Test
universal-wm validate
universal-wm list
```

## Verification

### Check Stow Setup

```bash
# Should show symlink
ls -la ~/.config/universal-wm/layouts.json

# Output:
# lrwxr-xr-x ... layouts.json -> ../../Documents/Code/dotfiles/universal-wm/dot-config/universal-wm/layouts.json
```

### Check CLI

```bash
# Should show version
universal-wm --version

# Output:
# universal-wm v1.0.0
```

### Check Detection

```bash
# Should detect your platform and WM
universal-wm detect

# Output (macOS example):
# 🔍 Detected Environment:
#    Platform:       macOS
#    Window Manager: aerospace
#    Status:         ✅ Supported
#    Adapter:        adapters/aerospace.ts
```

### Check Config

```bash
# Should validate successfully
universal-wm validate

# Output:
# ✅ Config is valid!
#    Layouts:      5
#    App Mappings: 11
#    Stash:        S
```

## Updating

### Update Configuration

```bash
# Edit the source file
vim ~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json

# Re-stow (if needed, though symlink updates automatically)
cd ~/dotfiles
stow --dotfiles -R universal-wm

# Validate
universal-wm validate
```

### Update Code

```bash
# Pull latest from git
cd ~/dotfiles
git pull

# No need to re-stow (symlinks still point to code)

# Test
universal-wm --version
```

## Uninstallation

```bash
# Unstow config
cd ~/dotfiles
stow --dotfiles -D universal-wm

# Remove CLI symlink
rm ~/.bin/universal-wm

# Optional: Remove config directory
rm -rf ~/.config/universal-wm
```

## Platform-Specific Notes

### macOS (Aerospace)

```bash
# Make sure Aerospace is running
ps aux | grep AeroSpace

# Config location (stowed)
~/.config/universal-wm/layouts.json

# Test
universal-wm apply code
```

### Linux (i3/Sway)

```bash
# Make sure i3 or Sway is running
echo $I3SOCK      # i3
echo $SWAYSOCK    # Sway

# Same config location
~/.config/universal-wm/layouts.json

# Test
universal-wm apply code
```

### Windows (Planned)

```powershell
# Will support komorebi and GlazeWM
# Same config location: %USERPROFILE%\.config\universal-wm\layouts.json
```

## Integration with Existing Workflow

### Aerospace Organize Script

Your existing `~/.bin/aerospace-organize` already updated to use the new adapter:

```bash
# Still works the same
~/.bin/aerospace-organize
~/.bin/aerospace-organize --no-launch
```

### Keybindings

**Aerospace** (`~/.aerospace.toml`):
```toml
# Use universal CLI
[[on-window-detected]]
if.app-id = 'net.kovidgoyal.kitty'
run = 'universal-wm apply code'
```

**i3** (`~/.config/i3/config`):
```
# Same commands work
bindsym $mod+Shift+1 exec universal-wm apply code
```

## Troubleshooting

### Issue: "Config file not found"

```bash
# Check if stowed correctly
ls -la ~/.config/universal-wm/layouts.json

# If missing, re-stow
cd ~/dotfiles
stow --dotfiles universal-wm
```

### Issue: "Command not found: universal-wm"

```bash
# Check if symlink exists
ls -la ~/.bin/universal-wm

# If missing, create it
ln -sf ~/dotfiles/universal-layout-manager/cli.ts ~/.bin/universal-wm

# Make sure ~/.bin is in PATH
echo $PATH | grep .bin
```

### Issue: "Permission denied"

```bash
# Make sure CLI is executable
chmod +x ~/dotfiles/universal-layout-manager/cli.ts
chmod +x ~/.bin/universal-wm
```

## Next Steps

After installation:

1. **Validate**: `universal-wm validate`
2. **Test**: `universal-wm apply browser`
3. **Customize**: Edit `~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json`
4. **Commit**: `cd ~/dotfiles && git add . && git commit -m "Add universal-wm config"`

See [QUICKSTART.md](./QUICKSTART.md) for usage examples.

---

**Last Updated**: 2025-11-03
**Version**: 1.0.0
