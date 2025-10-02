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

#### Workspaces
- `Alt + 1-9/0` - Switch to workspace 1-10
- `Alt + Shift + 1-9/0` - Move window to workspace 1-10
- `Alt + Tab` - Switch to previous workspace

#### Layout
- `Alt + /` - Toggle between horizontal/vertical tiles layout
- `Alt + ,` - Toggle accordion layout
- `Alt + Shift + -` - Decrease window size
- `Alt + Shift + =` - Increase window size

#### Service Mode
- `Alt + Shift + ;` - Enter service mode
  - `Esc` - Reload config and exit service mode
  - `r` - Reset layout (flatten workspace tree)
  - `f` - Toggle floating/tiling
  - `Backspace` - Close all windows except current

### Workspace Auto-Assignment

Windows are automatically assigned to workspaces based on application:

- **Workspace 1 (Start)**: Finder
- **Workspace 2 (Comms)**: Signal, Spotify, Messages
- **Workspace 3 (Browser)**: Safari, Chrome, Firefox
- **Workspace 4 (Code)**: VS Code, Kitty, Terminal

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
