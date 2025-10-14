# Keybindings Reference

Complete reference for all keyboard shortcuts across the dotfiles configuration.

## Table of Contents

- [AeroSpace (Window Management)](#aerospace-window-management)
- [Zsh (Terminal)](#zsh-terminal)
- [macOS System](#macos-system)
- [Quick Reference Card](#quick-reference-card)

---

## AeroSpace (Window Management)

AeroSpace is an i3-like tiling window manager for macOS. Configuration: [`aerospace/dot-aerospace.toml`](aerospace/dot-aerospace.toml)

### Window Navigation

| Keybinding | Action |
|------------|--------|
| `Alt + h` | Focus window to the left |
| `Alt + j` | Focus window below |
| `Alt + k` | Focus window above |
| `Alt + l` | Focus window to the right |

### Window Movement

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + h` | Move window left |
| `Alt + Shift + j` | Move window down |
| `Alt + Shift + k` | Move window up |
| `Alt + Shift + l` | Move window right |

### Monitor/Display

| Keybinding | Action |
|------------|--------|
| `Alt + s` | Focus monitor to the west (left) |
| `Alt + g` | Focus monitor to the east (right) |
| `Alt + Shift + s` | Move window to monitor on left |
| `Alt + Shift + g` | Move window to monitor on right |
| `Alt + Shift + w` | Move workspace to next monitor |

### Workspaces

| Keybinding | Action |
|------------|--------|
| `Alt + Tab` | Next workspace (cycles 1-6) |
| `Alt + Shift + Tab` | Previous workspace |
| `Alt + Shift + p` | Previous workspace (alternative) |
| `Alt + Shift + n` | Next workspace (alternative) |
| `Alt + 1-6` | Jump to workspace 1-6 |
| `Alt + Shift + 1-6` | Move window to workspace 1-6 |
| `Alt + Backtick (~)` | Jump to previously active workspace |

**Note**: Only workspaces 1-6 are configured to avoid cycling through empty workspaces.

### Window Layout

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + -` | Decrease window size |
| `Alt + Shift + =` | Increase window size |
| `Alt + Shift + r` | Rotate layout (horizontal ↔ vertical) |
| `Alt + Shift + e` | Balance window sizes (equalize) |

### Window State

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + t` | Toggle floating/tiling |
| `Alt + Shift + m` | Toggle fullscreen (maximize) |

### Applications

| Keybinding | Action |
|------------|--------|
| `Cmd + Enter` | Launch Kitty terminal |

### Utility Commands

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + o` | Apply all workspace layouts (organize windows) |
| `Alt + Shift + d` | Open dotfiles directory in VS Code |

### Service Mode

| Keybinding | Action |
|------------|--------|
| `Alt + Shift + ;` | Enter service mode |

**While in service mode:**

| Key | Action |
|-----|--------|
| `Esc` | Reload config and exit service mode |
| `r` | Reset layout (flatten workspace tree) |
| `f` | Toggle floating/tiling |
| `Backspace` | Close all windows except current |

### Workspace Auto-Assignment

**Note**: Auto-assignment only applies to *newly opened* windows.

- **Workspace 1 (Start)**: Finder, Activity Monitor
- **Workspace 2 (Comms)**: Signal, Spotify, Messages
- **Workspace 3 (Browser)**: Safari, Chrome, Firefox, Brave
- **Workspace 4 (Code)**: VS Code, Kitty, Terminal, iTerm2
- **Workspace 5 (Org)**: Calendar, Mail
- **Workspace 6 (Games)**: Discord, Steam, League of Legends

---

## Zsh (Terminal)

Shell keybindings and shortcuts. Configuration: [`zsh/.zshrc`](zsh/.zshrc)

### Command Line Editing

| Keybinding | Action |
|------------|--------|
| `Ctrl + a` | Move to beginning of line |
| `Ctrl + e` | Move to end of line |
| `Ctrl + u` | Kill line backwards (clear before cursor) |
| `Ctrl + k` | Kill line forwards (clear after cursor) |
| `Ctrl + w` | Delete word backwards |
| `Alt + Backspace` | Delete word backwards (macOS friendly) |
| `Ctrl + x Ctrl + e` | Edit command in $EDITOR |

### Word Movement

| Keybinding | Action |
|------------|--------|
| `Ctrl + Left Arrow` | Move backward one word |
| `Ctrl + Right Arrow` | Move forward one word |
| `Alt + Left Arrow` | Move backward one word (alternative) |
| `Alt + Right Arrow` | Move forward one word (alternative) |
| `Alt + f` | Move forward one word (vi-style) |
| `Alt + b` | Move backward one word (vi-style) |

### History Navigation

| Keybinding | Action |
|------------|--------|
| `Up Arrow` | Search history backwards (matches what you've typed) |
| `Down Arrow` | Search history forwards (matches what you've typed) |
| `Ctrl + r` | FZF fuzzy history search with preview |
| `Ctrl + /` | Toggle preview in FZF history (while in Ctrl+r) |
| `Ctrl + y` | Copy command to clipboard (while in FZF history) |

### Autosuggestions

| Keybinding | Action |
|------------|--------|
| `Ctrl + Space` | Accept full suggestion |
| `End` | Accept full suggestion |
| `Ctrl + Right Arrow` | Accept one word of suggestion |
| `Alt + f` | Accept one word of suggestion |

### Special Commands

| Keybinding | Action |
|------------|--------|
| `Ctrl + l` | Clear screen |
| `Ctrl + d` | Exit shell / End of file |
| `Ctrl + z` | Suspend current process |

See also: [zsh/KEYBINDINGS.md](zsh/KEYBINDINGS.md) for more details.

---

## macOS System

Native macOS keyboard shortcuts that complement the dotfiles setup.

### Window Management (Native)

| Keybinding | Action |
|------------|--------|
| `Cmd + Tab` | Switch between applications |
| **`Alt + Backtick (\`)`** | **Cycle windows within same app** ⭐ |
| `Cmd + H` | Hide current application |
| `Cmd + M` | Minimize window |
| `Cmd + Q` | Quit application |
| `Cmd + W` | Close window |

**⭐ Important**: Use `Alt + \`` (backtick) to cycle through multiple VS Code windows or terminal windows!

### Spotlight & Search

| Keybinding | Action |
|------------|--------|
| `Cmd + Space` | Spotlight search |
| `Cmd + Shift + /` | Help menu search |

### Screenshots

| Keybinding | Action |
|------------|--------|
| `Cmd + Shift + 3` | Capture entire screen |
| `Cmd + Shift + 4` | Capture selection |
| `Cmd + Shift + 4` then `Space` | Capture window |
| `Cmd + Shift + 5` | Screenshot toolbar (Mojave+) |

---

## Quick Reference Card

### Most Important Keybindings

**Window Management:**
- `Alt + h/j/k/l` - Navigate windows (like Vim)
- `Alt + Tab` - Switch workspaces
- **`Alt + \`` - Switch windows in same app** (native macOS)
- `Alt + 1-6` - Jump to workspace
- `Cmd + Enter` - Open terminal

**Terminal:**
- `Ctrl + r` - Fuzzy search command history
- `Up/Down` - Search history by prefix
- `Ctrl + Space` - Accept autosuggestion
- `Ctrl + u` - Clear line

**Utilities:**
- `Alt + Shift + o` - Apply all workspace layouts (organize windows)
- `Alt + Shift + d` - Open dotfiles

### Aliases

Quick shell aliases (type these in terminal):

```bash
dotfiles    # Open dotfiles in editor
dots        # Short alias for dotfiles
gs          # git status -s
gg          # git grep -n
dc          # docker-compose
vim         # Actually runs nvim
cat         # Actually runs bat (with syntax highlighting)
```

See `bash/dot-bashrc.d/aliases.bash` for complete list.

### Custom Scripts

Scripts in `~/.bin/` (from `bash/dot-bin/`):

```bash
em              # Smart editor launcher (VS Code → neovim → vim)
eem             # Emacs client launcher
aerospace-organize  # Organize windows (same as Alt+Shift+o)
extract         # Universal archive extractor
screenshot      # Screenshot utility
```

---

## Configuration Files

- **AeroSpace**: `aerospace/dot-aerospace.toml`
- **Zsh**: `zsh/.zshrc`
- **Bash**: `bash/dot-bashrc` and `bash/dot-bashrc.d/`
- **Aliases**: `bash/dot-bashrc.d/aliases.bash`
- **Git**: `git/dot-gitconfig`

## Tips & Tricks

### Learning the Keybindings

1. **Start with navigation**: Master `Alt + h/j/k/l` first
2. **Then workspaces**: Get comfortable with `Alt + Tab` and `Alt + 1-6`
3. **Add window management**: Learn `Alt + Shift + h/j/k/l` for moving windows
4. **Terminal efficiency**: Use `Ctrl + r` for history search, `Up arrow` for prefix search

### VS Code Multi-Window Workflow

The key to managing multiple VS Code windows:

1. Assign all VS Code windows to workspace 4: `Alt + Shift + o`
2. Go to workspace 4: `Alt + 4`
3. Cycle between VS Code windows: **`Alt + Backtick`** (macOS native feature!)
4. Or use AeroSpace: `Alt + h/j/k/l` to focus specific windows

### Organizing Your Workspaces

Recommended setup:

1. **Workspace 1**: System stuff (Finder, Activity Monitor)
2. **Workspace 2**: Communication (Signal, Messages, Slack)
3. **Workspace 3**: Web browsing (Safari, Chrome)
4. **Workspace 4**: Development (VS Code, terminals)
5. **Workspace 5**: Productivity (Calendar, Mail, Notes)
6. **Workspace 6**: Entertainment (Discord, Spotify)

Press `Alt + Shift + o` to organize existing windows automatically!

---

## Troubleshooting

### AeroSpace keybindings not working

1. Check AeroSpace has Accessibility permissions:
   ```bash
   open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
   ```
2. Restart AeroSpace: `aerospace restart`
3. Check config syntax: `aerospace validate`

### Zsh keybindings not working

1. Reload configuration: `source ~/.zshrc`
2. Check for plugin conflicts
3. Verify terminal sends correct key codes

### macOS native shortcuts conflicting

1. Go to System Preferences → Keyboard → Shortcuts
2. Disable conflicting shortcuts
3. Common conflicts: Mission Control (`Ctrl + Up/Down`), App Switcher

---

## See Also

- [AeroSpace Documentation](https://github.com/nikitabobko/AeroSpace)
- [Zsh Keybindings Documentation](zsh/KEYBINDINGS.md)
- [AeroSpace Config](aerospace/README.md)
- [Main README](README.md)
