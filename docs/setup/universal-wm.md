# Universal Window Manager Setup

Cross-platform window layout management for macOS (Aerospace), Linux (i3/Sway), and Windows (planned).

## Quick Start

The universal window manager is already configured if you've stowed your dotfiles:

```bash
# Check if it's working
universal-wm detect

# Should show:
# Platform:       macOS (or Linux/Windows)
# Window Manager: aerospace (or i3/sway/komorebi/glazewm)
# Status:         ✅ Supported
```

## What Is It?

The Universal Window Manager provides:

- **Single Configuration**: One config file works on macOS, Linux, and Windows
- **Auto-Detection**: Automatically detects your platform and window manager
- **Unified CLI**: Same commands work everywhere
- **Platform Abstraction**: Use semantic app names instead of platform-specific IDs

## Installation

### If Using Dotfiles with Stow

Already done! The `universal-wm` stow package is included.

```bash
cd ~/dotfiles
stow --dotfiles universal-wm
```

This creates:
- `~/.config/universal-wm/layouts.json` (symlinked to dotfiles)
- `~/.bin/universal-wm` (symlinked CLI)

### Manual Installation

See [universal-layout-manager/INSTALLATION.md](../../universal-layout-manager/INSTALLATION.md)

## Configuration

### Config Location

**Stowed** (recommended):
```
~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json
           ↓ symlinked to
~/.config/universal-wm/layouts.json
```

Edit either location - changes are the same since it's symlinked!

### Config Structure

```json
{
  "version": "1.0.0",
  "stashWorkspace": "S",
  "appMappings": {
    "vscode": {
      "macOS": "com.microsoft.VSCode",
      "linux_x11": "Code",
      "linux_wayland": "code-url-handler",
      "windows": "Code.exe"
    }
  },
  "layouts": {
    "code": {
      "workspace": "4",
      "layout": "h_tiles",
      "orientation": "horizontal",
      "windows": [
        {
          "app": "vscode",
          "size": "2/3"
        },
        {
          "app": "terminal",
          "size": "1/3"
        }
      ]
    }
  }
}
```

## Usage

### Basic Commands

```bash
# Show detected environment
universal-wm detect

# List available layouts
universal-wm list

# Apply a layout
universal-wm apply code

# Apply all layouts
universal-wm apply --all

# Validate configuration
universal-wm validate

# Organize without launching apps
universal-wm apply --noLaunch code
```

### Keyboard Shortcuts

#### macOS (Aerospace)

Add to `~/.aerospace.toml`:

```toml
# Apply workspace layouts
alt-shift-o = 'exec-and-forget ~/.bin/aerospace-organize'

# Apply specific layout
alt-shift-c = 'exec-and-forget universal-wm apply code'
```

#### Linux (i3)

Add to `~/.config/i3/config`:

```
# Apply workspace layouts
bindsym $mod+Shift+o exec universal-wm apply --all

# Apply specific layout
bindsym $mod+Shift+c exec universal-wm apply code
```

#### Linux (Sway)

Add to `~/.config/sway/config`:

```
# Same as i3
bindsym $mod+Shift+o exec universal-wm apply --all
bindsym $mod+Shift+c exec universal-wm apply code
```

## Adding Apps

### 1. Find Platform-Specific IDs

**macOS:**
```bash
# List running apps
osascript -e 'tell application "System Events" to get bundle identifier of every application process'

# Or check specific app
osascript -e 'id of app "Visual Studio Code"'
```

**Linux (X11):**
```bash
# List windows with classes
xprop WM_CLASS

# Or use i3/sway
i3-msg -t get_tree | grep -i "class"
swaymsg -t get_tree | grep -i "app_id"
```

**Windows:**
```powershell
# List running processes
Get-Process | Select-Object ProcessName
```

### 2. Add to Config

Edit `~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json`:

```json
{
  "appMappings": {
    "myapp": {
      "macOS": "com.example.MyApp",
      "linux_x11": "MyApp",
      "linux_wayland": "com.example.myapp",
      "windows": "MyApp.exe"
    }
  }
}
```

### 3. Use in Layouts

```json
{
  "layouts": {
    "mylayout": {
      "workspace": "6",
      "layout": "tiles",
      "orientation": "horizontal",
      "windows": [
        {
          "app": "myapp"
        }
      ]
    }
  }
}
```

### 4. Test

```bash
# Validate
universal-wm validate

# Apply
universal-wm apply mylayout
```

## Creating Layouts

### Simple Layout (Single Window)

```json
{
  "browser": {
    "workspace": "3",
    "layout": "tiles",
    "orientation": "horizontal",
    "windows": [
      {
        "app": "firefox"
      }
    ]
  }
}
```

### Layout with Sizing

```json
{
  "code": {
    "workspace": "4",
    "layout": "h_tiles",
    "orientation": "horizontal",
    "windows": [
      {
        "app": "vscode",
        "size": "2/3"
      },
      {
        "app": "terminal",
        "size": "1/3"
      }
    ]
  }
}
```

### Nested Groups

```json
{
  "dev": {
    "workspace": "4",
    "layout": "h_tiles",
    "orientation": "horizontal",
    "windows": [
      {
        "app": "vscode",
        "size": "2/3"
      },
      {
        "orientation": "vertical",
        "size": "1/3",
        "windows": [
          {
            "app": "terminal"
          },
          {
            "app": "browser"
          }
        ]
      }
    ]
  }
}
```

### Multi-Display

```json
{
  "dual_screen": {
    "workspace": "1",
    "layout": "tiles",
    "orientation": "horizontal",
    "display": "external",
    "windows": [
      {
        "app": "vscode"
      }
    ]
  }
}
```

Display options:
- `"main"` - Primary display
- `"secondary"` - Secondary display
- `"internal"` - Laptop screen
- `"external"` - External monitor
- `"Display Name"` - Regex match display name
- `1`, `2`, etc. - Display number

## Migration from Old Setup

If you have an existing `~/.config/aerospace/layouts.json`:

```bash
# Automatic migration
universal-wm migrate

# Or preview first
bun ~/dotfiles/universal-layout-manager/migrate-config.ts --dryRun
```

This converts:
```json
// Old (Aerospace-only)
{
  "layouts": {
    "code": {
      "windows": [
        {"bundleId": "com.microsoft.VSCode"}
      ]
    }
  }
}
```

To:
```json
// New (Universal)
{
  "appMappings": {
    "vscode": {
      "macOS": "com.microsoft.VSCode",
      "linux_x11": "Code",
      "windows": "Code.exe"
    }
  },
  "layouts": {
    "code": {
      "windows": [
        {"app": "vscode"}
      ]
    }
  }
}
```

## Troubleshooting

### "Window Manager not detected"

```bash
# Check detection
universal-wm detect

# macOS: Make sure Aerospace is running
ps aux | grep AeroSpace

# Linux: Check environment variables
echo $I3SOCK      # for i3
echo $SWAYSOCK    # for Sway
```

### "No windowId found for app"

**Check app is running:**
```bash
# macOS
osascript -e 'application id "com.microsoft.VSCode" is running'

# Linux
i3-msg -t get_tree | grep -i "vscode"
```

**Update app mapping:**
```json
{
  "appMappings": {
    "vscode": {
      "macOS": "com.microsoft.VSCode"  // ← Verify this is correct
    }
  }
}
```

### "Config validation fails"

```bash
# Check syntax
cat ~/.config/universal-wm/layouts.json | jq .

# Validate
universal-wm validate

# Check schema
less ~/dotfiles/universal-layout-manager/unified-layout.schema.json
```

### Layout not applying correctly

```bash
# Test without launching apps
universal-wm apply --noLaunch mylayout

# Run adapter directly for debugging
bun ~/dotfiles/universal-layout-manager/adapters/aerospace.ts mylayout

# Check logs (macOS)
tail -f /tmp/aerospace-organize.log
```

## Platform Differences

### Layout Type Names

| Universal | Aerospace | i3/Sway | komorebi | GlazeWM |
|-----------|-----------|---------|----------|---------|
| `tiles` | tiles | default | bsp | tiling |
| `h_tiles` | h_tiles | splith | horizontal-stack | columns |
| `v_tiles` | v_tiles | splitv | vertical-stack | rows |
| `accordion` | accordion | tabbed | - | - |

The universal-wm automatically translates these.

### App Identification

- **macOS**: Bundle ID (`com.microsoft.VSCode`)
- **Linux X11**: Window class (`Code`)
- **Linux Wayland**: App ID (`code-url-handler`)
- **Windows**: Process name (`Code.exe`)

## Advanced Topics

### Custom Config Location

```bash
# Set in environment
export UNIVERSAL_WM_CONFIG=~/custom/layouts.json

# Or per-command
universal-wm apply code --configFile ~/custom/layouts.json
```

### Scripting

```bash
#!/bin/bash
# Apply different layouts based on time of day

hour=$(date +%H)

if [ $hour -lt 12 ]; then
    universal-wm apply morning
elif [ $hour -lt 18 ]; then
    universal-wm apply work
else
    universal-wm apply evening
fi
```

### Git Integration

Since config is stowed from dotfiles:

```bash
# Edit config
vim ~/dotfiles/universal-wm/dot-config/universal-wm/layouts.json

# Commit
cd ~/dotfiles
git add universal-wm/
git commit -m "Update workspace layouts"

# Sync to other machines
git push

# On other machine
git pull
# Config automatically updates via symlink!
```

## Further Reading

- [QUICKSTART.md](../../universal-layout-manager/QUICKSTART.md) - Quick reference guide
- [INSTALLATION.md](../../universal-layout-manager/INSTALLATION.md) - Detailed installation
- [README.md](../../universal-layout-manager/README.md) - Full documentation
- [IMPLEMENTATION_STATUS.md](../../universal-layout-manager/IMPLEMENTATION_STATUS.md) - Technical details

## Legacy Documentation

For the old aerospace-only setup, see:
- [aerospace-layout-manager.md](./aerospace-layout-manager.md) (deprecated)
- [aerospace-quick-reference.md](./aerospace-quick-reference.md) (deprecated)

**Note**: The old `aerospace-layout-manager` submodule is deprecated in favor of the new universal system.

---

**Last Updated**: 2025-11-03
**Version**: 1.0.0
