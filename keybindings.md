# Keybindings Reference

Complete reference for all keybindings configured in this dotfiles repository.

## AeroSpace -- Window Management (macOS)

Config: `aerospace/dot-aerospace.toml`

AeroSpace uses `Alt` (Option) as its primary modifier. All bindings below are in the
**main mode** unless noted otherwise.

### App Launching

| Keys | Action |
|------|--------|
| `Cmd + Enter` | Launch Kitty terminal |

### Window Navigation (vim-style)

| Keys | Action |
|------|--------|
| `Alt + H` | Focus left |
| `Alt + J` | Focus down |
| `Alt + K` | Focus up |
| `Alt + L` | Focus right |

### Window Movement

| Keys | Action |
|------|--------|
| `Alt + Shift + H` | Move window left |
| `Alt + Shift + J` | Move window down |
| `Alt + Shift + K` | Move window up |
| `Alt + Shift + L` | Move window right |

### Monitor / Display

| Keys | Action |
|------|--------|
| `Alt + S` | Focus left monitor |
| `Alt + G` | Focus right monitor |
| `Alt + Shift + S` | Move window to left monitor |
| `Alt + Shift + G` | Move window to right monitor |
| `Alt + Shift + W` | Move workspace to next monitor |

### Resizing

| Keys | Action |
|------|--------|
| `Alt + Shift + -` | Shrink (resize smart -50) |
| `Alt + Shift + =` | Grow (resize smart +50) |

### Layout

| Keys | Action |
|------|--------|
| `Alt + Shift + R` | Toggle horizontal/vertical |
| `Alt + Shift + Y` | Mirror Y-axis |
| `Alt + Shift + X` | Mirror X-axis |
| `Alt + Shift + T` | Toggle floating/tiling |
| `Alt + Shift + M` | Toggle fullscreen |
| `Alt + Shift + E` | Balance (equalize) sizes |

### Workspace Switching

| Keys | Action |
|------|--------|
| `Alt + 1` | Workspace 1 (Start) |
| `Alt + 2` | Workspace 2 (Comms) |
| `Alt + 3` | Workspace 3 (Browser) |
| `Alt + 4` | Workspace 4 (Code) |
| `Alt + 5` | Workspace 5 (Org) |
| `Alt + 6` | Workspace 6 (Games) |

### Move Window to Workspace

| Keys | Action |
|------|--------|
| `Alt + Shift + 1-6` | Move window to workspace 1-6 |

### Workspace Cycling

| Keys | Action |
|------|--------|
| `Alt + Tab` | Next workspace |
| `Alt + Shift + Tab` | Previous workspace |
| `Alt + Shift + N` | Next workspace |
| `Alt + Shift + P` | Previous workspace |
| `Alt + Backtick` | Toggle last workspace |

### Utility

| Keys | Action |
|------|--------|
| `Alt + Shift + D` | Open dotfiles in VS Code |
| `Alt + Shift + ;` | Enter **service mode** |

### Service Mode

Press `Alt + Shift + ;` to enter. Most actions exit back to main mode.

| Keys | Action | Stays in service? |
|------|--------|-------------------|
| `Esc` | Reload config, exit | No |
| `R` | Reset layout (flatten workspace), exit | No |
| `F` | Toggle floating, exit | No |
| `T` | Toggle theme (Dracula Pro default/alucard), exit | No |
| `C` | Cycle through all theme variants | **Yes** |
| `S` | Startup: launch & organize all workspaces, exit | No |
| `O` | Organize existing windows (no launch), exit | No |
| `/` | Show keybindings reference, exit | No |
| `Backspace` | Close all windows except current, exit | No |
| `Alt+Shift + H/J/K/L` | Join window with neighbor, exit | No |

---

## Kitty -- Terminal Emulator

Config: `kitty/dot-config/kitty/kitty.conf`

The kitty modifier (`kitty_mod`) is `Ctrl+Shift`. These are custom overrides on
top of Kitty's defaults.

### Search

| Keys | Action |
|------|--------|
| `Ctrl+Shift + /` | Launch kitty-search kitten |

### Scrolling

| Keys | Action |
|------|--------|
| `Ctrl+Shift + B` | Scroll page up |
| `Ctrl+Shift + F` | Scroll page down |

### Window Management

| Keys | Action |
|------|--------|
| `Ctrl+Shift + Enter` | New window (current directory) |
| `Ctrl+Shift + J` | Previous window |
| `Ctrl+Shift + K` | Next window |
| `Ctrl+Shift + Up` | Move window forward |
| `Ctrl+Shift + Down` | Move window backward |

### Tab Management

| Keys | Action |
|------|--------|
| `Ctrl+Shift + T` | New tab (current directory) |
| `Ctrl+Shift + ]` | Next tab |
| `Ctrl+Shift + [` | Previous tab |
| `Ctrl+Shift + Right` | Move tab forward |
| `Ctrl+Shift + Left` | Move tab backward |

### Layout

| Keys | Action |
|------|--------|
| `Ctrl+Shift + 0` | Stack layout |
| `Ctrl+Shift + 9` | Tall layout |
| `Ctrl+Shift + 8` | Fat layout |

### Font Size

| Keys | Action |
|------|--------|
| `Ctrl+Shift + =` | Increase font size (+2pt) |
| `Ctrl+Shift + -` | Decrease font size (-2pt) |
| `Ctrl+Shift + Backspace` | Reset font size |

### Special

| Keys | Action |
|------|--------|
| `Ctrl + Space` | Send `Ctrl+P` (mapped for tmux/emacs prefix) |

---

## Zsh -- Shell

Config: `zsh/dot-zshrc`

### Line Editing

| Keys | Action |
|------|--------|
| `Ctrl + A` | Beginning of line |
| `Ctrl + E` | End of line |
| `Ctrl + U` | Kill to start of line |
| `Ctrl + K` | Kill to end of line |
| `Ctrl + X, Ctrl + E` | Edit command in `$EDITOR` |

### Word Movement

| Keys | Action |
|------|--------|
| `Ctrl + Right` | Forward word |
| `Ctrl + Left` | Backward word |
| `Alt + Right` | Forward word (alternate) |
| `Alt + Left` | Backward word (alternate) |
| `Alt + Backspace` | Delete word backward |

### History

| Keys | Action |
|------|--------|
| `Ctrl + R` | FZF history search |
| `Up` | Search history by prefix (what's already typed) |
| `Down` | Search history by prefix (forward) |

#### Inside FZF history search

| Keys | Action |
|------|--------|
| `Ctrl + /` | Toggle preview |
| `Ctrl + Y` | Copy selection to clipboard |

### Autosuggestions

| Keys | Action |
|------|--------|
| `Ctrl + Space` | Accept full suggestion |
| `End` | Accept full suggestion |
| `Ctrl + Right` | Accept one word |
| `Alt + F` | Accept one word (vi-style) |

---

## OpenCode -- AI CLI

Config: `opencode/dot-config/opencode/opencode.json` (no keybind overrides; all defaults)

OpenCode uses `Ctrl+X` as its **leader key**. Leader sequences are two-step:
press `Ctrl+X`, release, then press the second key.

### Application

| Keys | Action |
|------|--------|
| `Ctrl + C` / `Ctrl + D` | Exit |
| `Ctrl + P` | Command palette |
| `Ctrl + T` | Cycle model variant |
| `Ctrl + Z` | Suspend to terminal |

### Sessions (leader sequences)

| Keys | Action |
|------|--------|
| `<leader> N` | New session |
| `<leader> L` | List sessions |
| `<leader> G` | Session timeline |
| `<leader> X` | Export session |
| `<leader> C` | Compact session |
| `<leader> Right` | Next child session |
| `<leader> Left` | Previous child session |
| `<leader> Up` | Parent session |

### UI (leader sequences)

| Keys | Action |
|------|--------|
| `<leader> B` | Toggle sidebar |
| `<leader> S` | Status view |
| `<leader> E` | Open in editor |
| `<leader> T` | Theme list |
| `<leader> M` | Model list |
| `<leader> A` | Agent list |
| `<leader> H` | Toggle tips / conceal |

### Messages (leader sequences)

| Keys | Action |
|------|--------|
| `<leader> Y` | Copy messages |
| `<leader> U` | Undo |
| `<leader> R` | Redo |

### Agent / Model Cycling

| Keys | Action |
|------|--------|
| `Tab` | Cycle agent |
| `Shift + Tab` | Cycle agent (reverse) |
| `F2` | Cycle recent model |
| `Shift + F2` | Cycle recent model (reverse) |

### Message Scrolling

| Keys | Action |
|------|--------|
| `PageUp` / `Ctrl+Alt+B` | Page up |
| `PageDown` / `Ctrl+Alt+F` | Page down |
| `Ctrl+Alt + Y` | Line up |
| `Ctrl+Alt + E` | Line down |
| `Ctrl+Alt + U` | Half page up |
| `Ctrl+Alt + D` | Half page down |
| `Ctrl + G` / `Home` | First message |
| `Ctrl+Alt + G` / `End` | Last message |

### Input Editing

| Keys | Action |
|------|--------|
| `Return` | Submit |
| `Shift+Return` / `Ctrl+J` | Newline |
| `Ctrl + A` / `Ctrl + E` | Line home / end |
| `Ctrl + K` / `Ctrl + U` | Delete to end / start of line |
| `Ctrl + D` | Delete char forward |
| `Ctrl + W` | Delete word backward |
| `Alt + F` / `Alt + Right` | Word forward |
| `Alt + B` / `Alt + Left` | Word backward |
| `Ctrl + -` | Undo |
| `Ctrl + .` | Redo |

### macOS Conflicts

| OpenCode Binding | Conflict | Workaround |
|------------------|----------|------------|
| `Ctrl + Left` (word back) | macOS Mission Control: move space left | Use `Alt + Left` or `Alt + B` instead |
| `Ctrl + Right` (word fwd) | macOS Mission Control: move space right | Use `Alt + Right` or `Alt + F` instead |

Or disable the macOS shortcuts in **System Settings > Desktop & Dock > Shortcuts**.

---

## Universal WM -- Layout Manager

CLI tool, not a keybinding config. Invoked by AeroSpace service mode:

| Service Mode Key | Command |
|------------------|---------|
| `S` (startup) | `universal-wm apply --all` (launch + organize) |
| `O` (organize) | `universal-wm apply --all --noLaunch` (organize only) |

Available layouts: `start` (WS 1), `comms` (WS 2), `browser` (WS 3), `code` (WS 4), `org` (WS 5)

Config: `universal-wm/dot-config/universal-wm/layouts.json`

---

## Git -- Aliases

Config: `git/dot-gitconfig`

| Alias | Command |
|-------|---------|
| `git st` | `status -sb` |
| `git co` | `checkout` |
| `git br` | `branch` |
| `git cm` | `commit -m` |
| `git amend` | `commit --amend` |
| `git aa` | `add --all` |
| `git dc` | `diff --cached` |
| `git lg` | Log graph with colors |
| `git hist` | Log graph with short dates |
| `git sum` | Log oneline, no merges |
| `git loc` | Count lines of code |
| `git pr` | `pull-request` |
| `git unstage` | `reset HEAD` |
| `git checkout-pr <N>` | Fetch and checkout PR #N |

---

## macOS System -- Key Native Shortcuts

These are macOS defaults worth knowing alongside the above:

| Keys | Action |
|------|--------|
| `Cmd + Tab` | Switch application |
| `Cmd + Backtick` | Switch windows within same app |
| `Cmd + Space` | Spotlight search |
| `Cmd + Shift + 3/4/5` | Screenshot (full/area/options) |
| `Ctrl + Up` | Mission Control (conflicts with some TUI apps) |
| `Ctrl + Down` | App Expose (conflicts with some TUI apps) |
| `Ctrl + Left/Right` | Switch spaces (conflicts with terminal word movement) |

---

## Legacy

The `skhd` + `yabai` window management system was the predecessor to AeroSpace.
All keybindings have been migrated to AeroSpace. The skhd/yabai config
directories are retained in the repo but are empty/inactive.
