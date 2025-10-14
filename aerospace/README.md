# AeroSpace Configuration

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is an i3-like tiling window manager for macOS.

## Features

- **Tiling window management**: Automatic window tiling similar to i3/sway
- **Keyboard-driven**: Navigate and manage windows without touching the mouse
- **Multiple workspaces**: Organize windows across virtual desktops
- **No SIP disabling required**: Unlike yabai, AeroSpace doesn't require disabling System Integrity Protection
- **Native performance**: Written in Swift, optimized for macOS

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

- `Alt + Shift + o` - Organize existing windows into workspaces (runs `aerospace-organize` script)
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
- [Keybinding Reference](https://nikitabobko.github.io/AeroSpace/commands)

## Tips

1. **Start simple**: Begin with basic workspace switching and window navigation
2. **Use service mode**: `Alt+Shift+;` gives you quick access to layout controls
3. **Check the logs**: Helpful for debugging config issues
4. **Grant permissions**: Make sure Accessibility permissions are enabled
5. **Customize workspaces**: Adjust the workspace auto-assignments to your workflow
