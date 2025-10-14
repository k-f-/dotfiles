# AeroSpace Configuration & Layout Management

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is an i3-like tiling window manager for macOS.

## Quick Links
- [Basic AeroSpace Usage](#basic-aerospace-configuration)
- [Layout Management Guide](#layout-management-complete-guide)
- [Keybindings Reference](#key-bindings)

---

# Basic AeroSpace Configuration

## Features

- **Tiling window management**: Automatic window tiling similar to i3/sway
- **Keyboard-driven**: Navigate and manage windows without touching the mouse
- **Multiple workspaces**: Organize windows across virtual desktops
- **No SIP disabling required**: Unlike yabai, AeroSpace doesn't require disabling System Integrity Protection
- **Native performance**: Written in Swift, optimized for macOS
- **Layout management**: Save and restore complex window layouts

## Configuration

The configuration file is located at `~/.aerospace.toml` and uses TOML format.

### Key Bindings

#### Navigation (Vim-style)
- `Alt + h/j/k/l` - Focus left/down/up/right window
- `Alt + Shift + h/j/k/l` - Move window left/down/up/right

#### Window Cycling (Multi-Window VS Code Solution!)
- **Alt + ` (backtick)** - Cycle between windows of same app (native macOS)
- **This is your VS Code solution!** macOS natively cycles through windows of the same app
- Press Alt+` to switch between your multiple VS Code workspaces

#### Workspaces
- `Alt + Tab` - Cycle to next workspace (only cycles through workspaces 1-6)
- `Alt + Shift + Tab` - Cycle to previous workspace
- `Alt + 1-6` - Jump directly to workspace 1-6
- `Alt + Shift + 1-6` - Move current window to workspace 1-6
- `Alt + Backtick (~)` - Jump to previously active workspace (back-and-forth)
- `Alt + Shift + p/n` - Previous/next workspace (same as Alt+Shift+Tab/Alt+Tab)
- `Alt + Shift + w` - Move workspace to next monitor

**Note**: Only workspaces 1-6 are configured to avoid cycling through empty workspaces.

#### Layout
- `Alt + Shift + r` - Rotate layout (horizontal ↔ vertical)
- `Alt + Shift + -` - Decrease window size
- `Alt + Shift + =` - Increase window size
- `Alt + Shift + t` - Toggle floating/tiling
- `Alt + Shift + m` - Toggle fullscreen
- `Alt + Shift + e` - Balance window sizes

#### Service Mode
- `Alt + Shift + ;` - Enter service mode
  - `Esc` - Reload config and exit service mode
  - `r` - Reset layout (flatten workspace tree)
  - `f` - Toggle floating/tiling
  - `Backspace` - Close all windows except current

#### Window Organization

- `Alt + Shift + o` - Apply all workspace layouts (organize windows using aerospace-layout-manager)
- `Alt + Shift + d` - Open dotfiles directory in VS Code for quick editing

### Workspace Auto-Assignment

**IMPORTANT**: Auto-assignment only applies to *newly opened* windows. To organize existing windows:

- **Press `Alt + Shift + o`** to run the organize script
- Or manually run: `aerospace-organize`

Windows are automatically assigned to workspaces based on application:

- **Workspace 1 (Start)**: Finder, Activity Monitor
- **Workspace 2 (Comms)**: Signal, Spotify, Messages
- **Workspace 3 (Browser)**: Safari, Chrome, Firefox, Brave
- **Workspace 4 (Code)**: VS Code, Kitty, Terminal, iTerm2
- **Workspace 5 (Org)**: Calendar, Mail
- **Workspace 6 (Games)**: Discord, Steam, League of Legends

## Installation

### Via Homebrew (Recommended)
```bash
brew install --cask aerospace
```

### Using Dotfiles Installer
```bash
# Install all configs including aerospace
./install

# Or install only aerospace config
cd ~/.dotfiles
stow --target="$HOME" --dotfiles aerospace
```

## Starting AeroSpace

AeroSpace is configured to start automatically at login. You can also:

```bash
# Start manually
open -a AeroSpace

# Restart AeroSpace
aerospace restart

# Reload configuration
aerospace reload-config
```

## Troubleshooting

### Configuration not loading
1. Check config syntax:
   ```bash
   aerospace list-workspaces
   ```
2. View logs:
   ```bash
   tail -f ~/Library/Logs/AeroSpace/AeroSpace.log
   ```

### Getting app IDs for auto-assignment
```bash
aerospace list-apps
```

### Keyboard shortcuts not working
- Make sure AeroSpace has Accessibility permissions:
  - System Settings → Privacy & Security → Accessibility → Enable AeroSpace
- Check for conflicts with system or other app shortcuts

## Comparison with Yabai

| Feature | AeroSpace | Yabai |
|---------|-----------|-------|
| SIP Required | No | Yes (for some features) |
| Window Gaps | ✅ | ✅ |
| Auto-tiling | ✅ | ✅ |
| Native Performance | ✅ | ✅ |
| i3-like Keybindings | ✅ | Via skhd |
| Floating Windows | ✅ | ✅ |
| Configuration Format | TOML | Shell script |
| Maturity | Newer | Mature |

## Migrating from Yabai

If you're switching from yabai:

1. Stop yabai and skhd:
   ```bash
   brew services stop yabai
   brew services stop skhd
   ```

2. Start AeroSpace:
   ```bash
   open -a AeroSpace
   ```

3. The key bindings are similar to i3/sway, which may differ from your skhd config

## Resources

- [Official Documentation](https://nikitabobko.github.io/AeroSpace/guide)
- [Configuration Examples](https://nikitabobko.github.io/AeroSpace/config-examples)
- [GitHub Repository](https://github.com/nikitabobko/AeroSpace)

---

# Layout Management: Complete Guide

## Overview

This dotfiles repository includes a comprehensive solution for saving and restoring complex AeroSpace workspace layouts. The system allows you to:

- Define workspace layouts in JSON format
- Apply layouts to specific workspaces with keyboard shortcuts
- Restore your entire workflow (6 workspaces) with one command
- Use tree-based layout definitions (tiling WM approach, not pixel positions)

## How AeroSpace Layout Management Works

### The Tree-Based Approach

Unlike traditional window managers that use pixel coordinates, AeroSpace uses a **tree-based tiling structure**. This means:

1. **No pixel positions**: Windows are positioned relative to each other in a logical tree
2. **Tiling-first**: Uses AeroSpace's built-in tiling commands (`join-with`, `flatten-workspace-tree`, `resize`)
3. **Application-based**: Identifies windows by their `bundleId` (e.g., `com.google.Chrome`)
4. **Fractional sizing**: Uses fractions like "1/3" or "2/3" for window sizes
5. **Orientation-aware**: Defines horizontal/vertical splits in the tree

### Why This Matters

The tree-based approach is **much more reliable** than pixel positioning because:
- Works across different display resolutions
- Handles monitor changes gracefully
- Aligns with how tiling window managers actually work
- Uses AeroSpace's native capabilities (no macOS Accessibility APIs needed)

## Installation

### 1. Install aerospace-layout-manager

We use [CarterMcAlister's aerospace-layout-manager](https://github.com/CarterMcAlister/aerospace-layout-manager), a proven TypeScript/Bun tool:

```bash
# One-line installation (recommended - done automatically by install-mac.sh)
curl -fsSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash

# Or manual installation
git clone https://github.com/CarterMcAlister/aerospace-layout-manager.git
cd aerospace-layout-manager
bun install
bun link
```

### 2. Copy Layout Definitions

The `layouts.json` file in this directory contains pre-configured layouts for all 6 workspaces:

```bash
# Automatically handled by install script, or manually:
cp ~/dotfiles/aerospace/layouts.json ~/.config/aerospace/layouts.json
```

## Layout JSON Schema

Layouts are defined using a tree structure in `layouts.json`:

```json
{
  "1": {
    "name": "Communication Layout",
    "orientation": "horizontal",
    "windows": [
      {
        "bundleId": "com.tinyspeck.slackmacgap",
        "size": "1/3"
      },
      {
        "orientation": "vertical",
        "size": "2/3",
        "windows": [
          {
            "bundleId": "com.apple.mail",
            "size": "1/2"
          },
          {
            "bundleId": "com.apple.iCal",
            "size": "1/2"
          }
        ]
      }
    ]
  }
}
```

### Key Properties

- **`orientation`**: `"horizontal"` or `"vertical"` - how windows split
- **`bundleId`**: Application identifier (find with: `osascript -e 'id of app "AppName"'`)
- **`size`**: Fractional size as string (`"1/2"`, `"1/3"`, `"2/3"`, etc.)
- **`windows`**: Array of window definitions or nested groups

## Pre-Configured Layouts

The dotfiles include 6 workspace layouts:

### Workspace 1: Communication
```
┌─────────┬───────────────┐
│         │     Mail      │
│  Slack  ├───────────────┤
│         │   Calendar    │
└─────────┴───────────────┘
```

### Workspace 2: Development
```
┌─────────────────────────┐
│                         │
│      VS Code / IDE      │
│                         │
└─────────────────────────┘
```

### Workspace 3: Browser Research
```
┌───────────┬─────────────┐
│           │             │
│  Chrome   │   Safari    │
│           │             │
└───────────┴─────────────┘
```

### Workspace 4: Organization
```
┌─────────┬───────────────┐
│         │   Obsidian    │
│ Todoist ├───────────────┤
│         │    Finder     │
└─────────┴───────────────┘
```

### Workspace 5: Media/Creative
```
┌─────────────────────────┐
│                         │
│     Spotify / Media     │
│                         │
└─────────────────────────┘
```

### Workspace 6: Utilities
```
┌───────────────────┬─────┐
│                   │     │
│     Terminal      │ Sys │
│                   │     │
└───────────────────┴─────┘
```

## Usage

### Apply a Single Layout

```bash
# Apply layout to workspace 1
aerospace-layout-manager apply 1

# Apply layout to workspace 3
aerospace-layout-manager apply 3
```

### Apply All Layouts

Restore your entire workflow across all 6 workspaces:

```bash
aerospace-layout-manager apply-all
```

### Keyboard Shortcuts

Add these to your `dot-aerospace.toml`:

```toml
# Quick layout switching (Alt+Shift+1 through Alt+Shift+6)
alt-shift-1 = ['workspace 1', 'exec-and-forget aerospace-layout-manager apply 1']
alt-shift-2 = ['workspace 2', 'exec-and-forget aerospace-layout-manager apply 2']
alt-shift-3 = ['workspace 3', 'exec-and-forget aerospace-layout-manager apply 3']
alt-shift-4 = ['workspace 4', 'exec-and-forget aerospace-layout-manager apply 4']
alt-shift-5 = ['workspace 5', 'exec-and-forget aerospace-layout-manager apply 5']
alt-shift-6 = ['workspace 6', 'exec-and-forget aerospace-layout-manager apply 6']

# Restore all layouts
alt-shift-r = ['exec-and-forget aerospace-layout-manager apply-all']
```

## How It Works: The Pipeline

When you apply a layout, the tool follows this workflow:

1. **Clear workspace** - `aerospace flatten-workspace-tree --workspace X`
2. **Move windows** - Traverse tree and `move` windows to correct workspace
3. **Reposition** - Use `join-with` to build tree structure (left/right/up/down)
4. **Resize** - Apply fractional sizing with `resize` commands
5. **Focus** - Set focus to first window in layout

### Example: Building a Layout

For the Communication layout (Slack left, Mail/Calendar stacked right):

```bash
# 1. Flatten workspace (clear any existing splits)
aerospace flatten-workspace-tree --workspace 1

# 2. Move all windows to workspace 1
aerospace move-node-to-workspace 1  # for each window

# 3. Build tree structure
# Mail joins below Calendar
aerospace [--window-id MAIL_ID] join-with down

# 4. Slack joins left of Mail/Calendar group
aerospace [--window-id SLACK_ID] join-with left

# 5. Resize windows
aerospace resize width 33%  # Slack gets 1/3
# Mail/Calendar split remaining 2/3 vertically

# 6. Focus Slack
aerospace focus --window-id SLACK_ID
```

## Finding Application Bundle IDs

To add new applications to your layouts:

```bash
# Method 1: Using osascript
osascript -e 'id of app "Slack"'
# Output: com.tinyspeck.slackmacgap

# Method 2: From running app
aerospace list-windows --all | grep "AppName"
# Shows bundleId in output

# Method 3: From app bundle
mdls -name kMDItemCFBundleIdentifier -r /Applications/AppName.app
```

## Customizing Layouts

Edit `~/.config/aerospace/layouts.json`:

```json
{
  "1": {
    "name": "My Custom Layout",
    "orientation": "vertical",
    "windows": [
      {
        "bundleId": "com.example.app1",
        "size": "1/4"
      },
      {
        "bundleId": "com.example.app2",
        "size": "3/4"
      }
    ]
  }
}
```

### Tips for Creating Layouts

1. **Start simple**: Begin with 2-3 windows, test, then add more
2. **Use common fractions**: `1/2`, `1/3`, `2/3`, `1/4`, `3/4` work best
3. **Nest carefully**: Too many nested groups can be hard to reason about
4. **Test incrementally**: Apply layout after each change to verify behavior
5. **Match your workflow**: Design layouts around your actual task patterns

## Troubleshooting

### Layout Doesn't Apply

```bash
# Check if apps are running
aerospace list-windows --all

# Verify bundleId is correct
osascript -e 'id of app "AppName"'

# Check JSON syntax
jq . ~/.config/aerospace/layouts.json
```

### Windows in Wrong Position

- Ensure `orientation` is correct (`horizontal` vs `vertical`)
- Verify `size` fractions add up properly in groups
- Try flattening workspace manually: `aerospace flatten-workspace-tree --workspace N`

### App Not Found

- Make sure the application is running **before** applying layout
- Some apps need to be fully launched (not just opened)
- Check for typos in `bundleId`

## Advanced: Creating Dynamic Layouts

You can create layouts programmatically:

```bash
# Generate layout from current workspace state
aerospace list-windows --workspace 1 --format '%{app-bundle-id}' \
  | jq -R -s 'split("\n") | map(select(length > 0)) |
     {name: "Current Layout", windows: map({bundleId: .})}'
```

## Integration with Dotfiles

The installation script (`scripts/install-mac.sh`) automatically:

1. Installs `aerospace-layout-manager`
2. Copies `layouts.json` to `~/.config/aerospace/`
3. Adds keybindings to `dot-aerospace.toml` (if configured)
4. Verifies installation with test command

## Real-World Example: Morning Startup

Add to your shell profile:

```bash
# Function to start your workday
function work_start() {
  echo "🚀 Starting work environment..."

  # Open all required applications
  open -a "Slack"
  open -a "Mail"
  open -a "Calendar"
  open -a "Visual Studio Code"
  open -a "Google Chrome"

  # Wait for apps to launch
  sleep 5

  # Apply all layouts
  aerospace-layout-manager apply-all

  # Focus workspace 1
  aerospace workspace 1

  echo "✅ Workspace ready!"
}
```

## Credits & References

This layout management solution is based on:

- **CarterMcAlister's aerospace-layout-manager**: [GitHub repo](https://github.com/CarterMcAlister/aerospace-layout-manager)
- **AeroSpace Discussion #756**: [Working implementations](https://github.com/nikitabobko/AeroSpace/discussions/756)
- Contributors: @mcharo, @mangoconcoco, @CarterMcAlister

## Further Reading

- [AeroSpace Commands Reference](https://nikitabobko.github.io/AeroSpace/commands)
- [Understanding Tiling Window Managers](https://github.com/nikitabobko/AeroSpace/blob/main/docs/guide.adoc#tiling-window-manager)
- [i3 User's Guide](https://i3wm.org/docs/userguide.html) (similar concepts)

- [Keybinding Reference](https://nikitabobko.github.io/AeroSpace/commands)

## Tips

1. **Start simple**: Begin with basic workspace switching and window navigation
2. **Use service mode**: `Alt+Shift+;` gives you quick access to layout controls
3. **Check the logs**: Helpful for debugging config issues
4. **Grant permissions**: Make sure Accessibility permissions are enabled
5. **Customize workspaces**: Adjust the workspace auto-assignments to your workflow
