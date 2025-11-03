# Universal Window Manager - Quick Start Guide

Welcome to the Universal Window Manager! This guide will help you get started quickly.

## What You Have Now ✅

You've successfully migrated to the universal window manager system. Here's what's set up:

### 1. Universal CLI (`universal-wm`) ✅

A single command that works everywhere with auto-detection:

```bash
# Check what's detected
universal-wm detect

# List available layouts
universal-wm list

# Apply a layout
universal-wm apply code

# Apply all layouts
universal-wm apply --all

# Validate config
universal-wm validate
```

### 2. Updated Scripts ✅

Your existing workflow still works:

```bash
# This now uses the universal adapter
~/.bin/aerospace-organize
~/.bin/aerospace-organize --no-launch
```

### 3. Platform Adapters ✅

- **macOS (Aerospace)**: ✅ `adapters/aerospace.ts` - Ready to use!
- **Linux (i3/Sway)**: ✅ `adapters/i3-sway.ts` - Ready to test on Linux!
- **Windows (komorebi)**: 📋 Planned
- **Windows (GlazeWM)**: 📋 Planned

### 4. Migration Tool ✅

Convert platform-specific configs to universal format:

```bash
# Migrate automatically
universal-wm migrate

# Or run directly
bun universal-layout-manager/migrate-config.ts

# Preview without writing
bun universal-layout-manager/migrate-config.ts --dryRun
```

---

## Quick Usage Examples

### Basic Commands

```bash
# Show detected environment
$ universal-wm detect
🔍 Detected Environment:
   Platform:       macOS
   Window Manager: aerospace
   Status:         ✅ Supported
   Adapter:        adapters/aerospace.ts

# List layouts
$ universal-wm list
comms
code
browser
org
start

# Apply a layout
$ universal-wm apply code
Applying layout for workspace 4...
Using display: Color LCD (2294x1490) (main, internal)
✓ Layout applied for workspace 4
✓ Done!

# Organize without launching apps
$ universal-wm apply --noLaunch comms

# Apply all layouts at once
$ universal-wm apply --all
```

### Config Management

```bash
# Validate your config
$ universal-wm validate
✅ Config is valid!
   Layouts:      5
   App Mappings: 11
   Stash:        S

# Use custom config
$ universal-wm apply code --configFile ~/my-config.json
```

---

## Your Config File

**Location**: `~/.config/universal-wm/layouts.json`

**Structure**:
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
        }
      ]
    }
  }
}
```

---

## How It Works

### Auto-Detection Flow

```
universal-wm apply code
        ↓
    Detect Platform (macOS/Linux/Windows)
        ↓
    Detect Window Manager (Aerospace/i3/Sway/etc.)
        ↓
    Route to Adapter (aerospace.ts/i3-sway.ts/etc.)
        ↓
    Load Universal Config (~/.config/universal-wm/layouts.json)
        ↓
    Resolve App Identifiers (vscode → com.microsoft.VSCode)
        ↓
    Execute Layout Commands (aerospace/i3-msg/komorebic)
```

### App Identifier Resolution

The universal config uses semantic app keys that map to platform-specific identifiers:

| App Key | macOS | Linux X11 | Linux Wayland | Windows |
|---------|-------|-----------|---------------|---------|
| `vscode` | `com.microsoft.VSCode` | `Code` | `code-url-handler` | `Code.exe` |
| `firefox` | `org.mozilla.firefox` | `firefox` | `org.mozilla.firefox` | `firefox.exe` |
| `kitty` | `net.kovidgoyal.kitty` | `kitty` | `kitty` | `WindowsTerminal.exe` |

---

## Configuration Tips

### Adding a New App

Edit `~/.config/universal-wm/layouts.json`:

```json
{
  "appMappings": {
    "myapp": {
      "macOS": "com.example.MyApp",
      "linux_x11": "MyApp",
      "linux_wayland": "com.example.myapp",
      "windows": "MyApp.exe"
    }
  },
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

### Creating a New Layout

```json
{
  "layouts": {
    "focus": {
      "workspace": "7",
      "layout": "tiles",
      "orientation": "vertical",
      "display": "main",
      "windows": [
        {
          "app": "vscode",
          "size": "1/2"
        },
        {
          "app": "terminal",
          "size": "1/2"
        }
      ]
    }
  }
}
```

### Nested Groups

```json
{
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
```

---

## Advanced Usage

### Custom Config Location

```bash
# Set in environment
export UNIVERSAL_WM_CONFIG=~/dotfiles/layouts.json

# Or specify per-command
universal-wm apply code --configFile ~/dotfiles/layouts.json
```

### Integration with Keybindings

**Aerospace** (macOS):
```toml
# ~/.aerospace.toml
[[on-window-detected]]
if.app-id = 'net.kovidgoyal.kitty'
run = 'universal-wm apply code --noLaunch'
```

**i3** (Linux):
```
# ~/.config/i3/config
bindsym $mod+Shift+1 exec universal-wm apply code
bindsym $mod+Shift+2 exec universal-wm apply browser
```

**Sway** (Linux):
```
# ~/.config/sway/config
bindsym $mod+Shift+1 exec universal-wm apply code
bindsym $mod+Shift+2 exec universal-wm apply browser
```

---

## Troubleshooting

### Issue: "Window Manager not detected"

```bash
# Check detection
universal-wm detect

# Make sure your WM is running
# macOS: check if Aerospace is running
# Linux: check $I3SOCK or $SWAYSOCK environment variables
```

### Issue: "No windowId found for app"

**Check app mappings**:
```bash
# Validate config
universal-wm validate

# Check if app is running
# macOS: osascript -e 'application id "com.microsoft.VSCode" is running'
# Linux: wmctrl -l or i3-msg -t get_tree
```

**Update app mapping**:
```json
{
  "appMappings": {
    "myapp": {
      "macOS": "com.correct.BundleID"
    }
  }
}
```

### Issue: "Layout not applying correctly"

```bash
# Test without launching apps
universal-wm apply --noLaunch mylayout

# Check logs (macOS)
tail -f /tmp/aerospace-organize.log

# Run adapter directly for debugging
bun universal-layout-manager/adapters/aerospace.ts mylayout
```

---

## Migration Guide

### From Old Aerospace Config

If you have an existing `~/.config/aerospace/layouts.json`:

```bash
# Automatic migration
universal-wm migrate

# Or manual migration
bun universal-layout-manager/migrate-config.ts \
  --input ~/.config/aerospace/layouts.json \
  --output ~/.config/universal-wm/layouts.json

# Preview first
bun universal-layout-manager/migrate-config.ts --dryRun
```

**Before** (Aerospace-only):
```json
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

**After** (Universal):
```json
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

---

## Next Steps

### 1. Test on Your System

```bash
# Apply a simple layout
universal-wm apply browser

# Apply your full workspace setup
universal-wm apply --all
```

### 2. Customize Your Layouts

Edit `~/.config/universal-wm/layouts.json` to match your workflow.

### 3. Set Up Keybindings

Add keyboard shortcuts to quickly apply layouts.

### 4. Share Across Machines

```bash
# Copy config to dotfiles
cp ~/.config/universal-wm/layouts.json ~/dotfiles/

# On another machine
cp ~/dotfiles/layouts.json ~/.config/universal-wm/

# Works on macOS, Linux, and Windows (when adapters are ready)!
```

---

## Platform Roadmap

| Platform | Status | Adapter | Notes |
|----------|--------|---------|-------|
| **macOS (Aerospace)** | ✅ Ready | `aerospace.ts` | Fully tested |
| **Linux (i3)** | ✅ Ready | `i3-sway.ts` | Ready to test |
| **Linux (Sway)** | ✅ Ready | `i3-sway.ts` | Ready to test |
| **Windows (komorebi)** | 📋 Planned | `komorebi.ts` | 90% feasible |
| **Windows (GlazeWM)** | 📋 Planned | `glazewm.ts` | 88% feasible |

---

## Resources

### Documentation
- [README.md](./README.md) - Full documentation
- [IMPLEMENTATION_STATUS.md](./IMPLEMENTATION_STATUS.md) - Technical details
- [TESTING_RESULTS.md](./TESTING_RESULTS.md) - Test results

### Examples
- [example-layouts.json](./example-layouts.json) - Sample configurations
- [unified-layout.schema.json](./unified-layout.schema.json) - JSON schema

### Tools
- `cli.ts` - Universal CLI (auto-detection)
- `migrate-config.ts` - Migration tool
- `adapters/aerospace.ts` - macOS adapter
- `adapters/i3-sway.ts` - Linux adapter

---

## Getting Help

### Commands
```bash
# Show help
universal-wm --help

# Show version
universal-wm --version

# Validate config
universal-wm validate

# Show detection
universal-wm detect
```

### Debug Mode
```bash
# Run adapter directly for verbose output
bun universal-layout-manager/adapters/aerospace.ts code

# Check logs (macOS)
tail -f /tmp/aerospace-organize.log
```

---

**Last Updated**: 2025-11-03
**Version**: 1.0.0
**Status**: ✅ Ready for Production
