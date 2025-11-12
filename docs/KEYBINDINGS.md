# Keybindings Reference

Complete keybinding reference for window managers and terminal emulator.

## Keybinding Paradigms

**Window Manager (AeroSpace):**
- Primary modifier: `Option` (Alt)
- Secondary modifier: `Option+Shift` (Alt+Shift)
- Example: `Option+H` to focus left, `Option+Shift+H` to move window left

**Terminal (Kitty):**
- Primary modifier: `Control+Shift` (kitty_mod)
- Example: `Control+Shift+T` for new tab, `Control+Shift+Enter` for new window

---

## Table of Contents
- [AeroSpace Window Manager](#aerospace-window-manager)
- [Kitty Terminal Emulator](#kitty-terminal-emulator)
- [Quick Reference](#quick-reference)
- [SKHD + Yabai (Alternative/Legacy)](#skhd--yabai-alternativelegacy)

---

## AeroSpace Window Manager

*Primary tiling window manager for macOS with vim-style navigation*

### Application Launching
| Keybinding | Action |
|------------|--------|
| `Cmd+Enter` | Launch Kitty terminal |

### Window Navigation
| Keybinding | Action |
|------------|--------|
| `Alt+H` | Focus window left |
| `Alt+J` | Focus window down |
| `Alt+K` | Focus window up |
| `Alt+L` | Focus window right |

### Window Movement
| Keybinding | Action |
|------------|--------|
| `Alt+Shift+H` | Move window left |
| `Alt+Shift+J` | Move window down |
| `Alt+Shift+K` | Move window up |
| `Alt+Shift+L` | Move window right |

### Monitor/Display Management
| Keybinding | Action |
|------------|--------|
| `Alt+S` | Focus left monitor |
| `Alt+G` | Focus right monitor |
| `Alt+Shift+S` | Move window to left monitor |
| `Alt+Shift+G` | Move window to right monitor |

### Window Resizing
| Keybinding | Action |
|------------|--------|
| `Alt+Shift+-` | Decrease window size (50px) |
| `Alt+Shift+=` | Increase window size (50px) |

### Layout Modifications
| Keybinding | Action |
|------------|--------|
| `Alt+Shift+R` | Rotate/toggle layout |
| `Alt+Shift+Y` | Mirror Y-axis |
| `Alt+Shift+X` | Mirror X-axis |
| `Alt+Shift+T` | Toggle floating/tiling |
| `Alt+Shift+M` | Maximize/fullscreen |
| `Alt+Shift+E` | Balance window sizes |

### Workspace Management
| Keybinding | Action |
|------------|--------|
| `Alt+1` | Switch to workspace 1 (Start) |
| `Alt+2` | Switch to workspace 2 (Comms) |
| `Alt+3` | Switch to workspace 3 (Browser) |
| `Alt+4` | Switch to workspace 4 (Code) |
| `Alt+5` | Switch to workspace 5 (Org) |
| `Alt+6` | Switch to workspace 6 (Games) |
| `Alt+Shift+1-6` | Move window to workspace 1-6 |
| `Alt+Shift+P` | Move to previous workspace |
| `Alt+Shift+N` | Move to next workspace |
| `Alt+Tab` | Next workspace |
| `Alt+Shift+Tab` | Previous workspace |
| `Alt+Backtick` | Jump to previous workspace |
| `Alt+Shift+W` | Move workspace to next monitor |

### Utility
| Keybinding | Action |
|------------|--------|
| `Alt+Shift+D` | Open dotfiles in VS Code |

### Service Mode (`Alt+Shift+;`)
*Enter service mode with `Alt+Shift+;`, then press:*

| Key | Action |
|-----|--------|
| `S` | Startup - launch and organize all workspaces |
| `O` | Organize existing windows only |
| `T` | Toggle theme and exit service mode |
| `C` | Cycle theme (stays in service mode) |
| `R` | Reset layout |
| `F` | Toggle floating |
| `Esc` | Reload config and exit |
| `Alt+Shift+H/J/K/L` | Join windows (in service mode) |

---

## Kitty Terminal Emulator

*Terminal emulator with internal window and tab management*

**Note:** `Kitty_Mod` defaults to `Ctrl+Shift` on most systems.

### Search
| Keybinding | Action |
|------------|--------|
| `Kitty_Mod+/` | Launch kitty-search plugin |

### Scrolling
| Keybinding | Action |
|------------|--------|
| `Kitty_Mod+B` | Scroll page up |
| `Kitty_Mod+F` | Scroll page down |

### Window Management
| Keybinding | Action |
|------------|--------|
| `Kitty_Mod+Enter` | New window (current directory) |
| `Kitty_Mod+J` | Previous window |
| `Kitty_Mod+K` | Next window |
| `Kitty_Mod+Up` | Move window forward |
| `Kitty_Mod+Down` | Move window backward |

### Tab Management
| Keybinding | Action |
|------------|--------|
| `Kitty_Mod+]` | Next tab |
| `Kitty_Mod+[` | Previous tab |
| `Kitty_Mod+T` | New tab (current directory) |
| `Kitty_Mod+Right` | Move tab forward |
| `Kitty_Mod+Left` | Move tab backward |

### Layout Management
| Keybinding | Action |
|------------|--------|
| `Kitty_Mod+0` | Stack layout |
| `Kitty_Mod+9` | Tall layout |
| `Kitty_Mod+8` | Fat layout |

### Font Size
| Keybinding | Action |
|------------|--------|
| `Kitty_Mod+=` | Increase font size (2pt) |
| `Kitty_Mod+-` | Decrease font size (2pt) |
| `Kitty_Mod+Backspace` | Reset font size |

### Special
| Keybinding | Action |
|------------|--------|
| `Ctrl+Space` | Send Ctrl+P (for tmux/emacs) |

---

## Quick Reference

### Core Window Management Pattern
All window managers follow a consistent vim-style philosophy:

- **H/J/K/L** = Left/Down/Up/Right navigation
- **Alt** = Primary modifier for window operations
- **Alt+Shift** = Window movement and layout modifications
- **Alt+Number** = Workspace switching

### Workspaces
1. **Start** - Initial workspace
2. **Comms** - Communication apps
3. **Browser** - Web browsers
4. **Code** - Development environment
5. **Org** - Organization/productivity
6. **Games** - Gaming/entertainment

### Common Operations

#### Focus Window
- `Alt+H/J/K/L` - Navigate left/down/up/right

#### Move Window
- `Alt+Shift+H/J/K/L` - Move window left/down/up/right

#### Toggle Floating
- `Alt+Shift+T` - Toggle window between floating and tiling

#### Balance Windows
- `Alt+Shift+E` - Equalize all window sizes

#### Maximize Window
- `Alt+Shift+M` - Toggle fullscreen/maximize

---

## SKHD + Yabai (Alternative/Legacy)

*Alternative macOS window management setup - not actively used*

### Application Launching
| Keybinding | Action |
|------------|--------|
| `Cmd+Enter` | Launch Kitty terminal |

### Window Navigation
| Keybinding | Action |
|------------|--------|
| `Alt+H` | Focus west window |
| `Alt+J` | Focus south window |
| `Alt+K` | Focus north window |
| `Alt+L` | Focus east window |
| `Alt+S` | Focus west display |
| `Alt+G` | Focus east display |

### Layout Modifications
| Keybinding | Action |
|------------|--------|
| `Shift+Alt+R` | Rotate layout 90 degrees |
| `Shift+Alt+Y` | Mirror Y-axis |
| `Shift+Alt+X` | Mirror X-axis |
| `Shift+Alt+T` | Toggle window float |
| `Shift+Alt+A` | Toggle sticky (window on all spaces) |
| `Shift+Alt+M` | Maximize window (zoom fullscreen) |
| `Shift+Alt+E` | Balance windows |

### Window Movement
| Keybinding | Action |
|------------|--------|
| `Shift+Alt+H` | Swap window west |
| `Shift+Alt+J` | Swap window south |
| `Shift+Alt+K` | Swap window north |
| `Shift+Alt+L` | Swap window east |
| `Ctrl+Alt+H` | Warp window west (move and split) |
| `Ctrl+Alt+J` | Warp window south (move and split) |
| `Ctrl+Alt+K` | Warp window north (move and split) |
| `Ctrl+Alt+L` | Warp window east (move and split) |
| `Shift+Alt+S` | Move window to west display |
| `Shift+Alt+G` | Move window to east display |
| `Shift+Alt+P` | Move window to previous space |
| `Shift+Alt+N` | Move window to next space |
| `Shift+Alt+1-7` | Move window to spaces 1-7 |

### Theme Management
| Keybinding | Action |
|------------|--------|
| `Shift+Alt+C` | Cycle through all theme variants |

### Yabai Control
| Keybinding | Action |
|------------|--------|
| `Ctrl+Alt+Q` | Stop yabai service |
| `Ctrl+Alt+S` | Start yabai service |
| `Ctrl+Alt+R` | Restart yabai service |

---

## Configuration Files

- **AeroSpace:** `~/.aerospace.toml`
- **SKHD:** `~/.config/skhd/skhdrc`
- **Yabai:** `~/.config/yabai/yabairc`
- **Kitty:** `~/.config/kitty/kitty.conf`
- **Universal WM:** `~/.config/universal-wm/layouts.json`

---

*Last updated: 2025-11-12*
