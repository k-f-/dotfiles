# AeroSpace Configuration & Window Manager Toolchain

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is an i3-like tiling window manager for macOS. It's the foundation of a four-component toolchain this repo uses to drive automated layouts and themes.

## Architecture

```
macOS
 └─ AeroSpace (Swift app)
     ├─ ~/.aerospace.toml  (stowed from dotfiles/aerospace/dot-aerospace.toml)
     ├─ MAIN MODE  — Alt+hjkl nav, Alt+1-6 workspaces, Cmd+Enter→Kitty, …
     └─ SERVICE MODE  (gateway: Alt+Shift+;)
         ├─ t = ~/.bin/toggle-theme            (theme toggle: kitty + vscode)
         ├─ c = ~/.bin/toggle-theme --cycle    (stays in service mode)
         ├─ s = ~/.bin/aerospace-organize-wrapper       ← "startup"
         ├─ o = ~/.bin/aerospace-organize-wrapper --no-launch
         ├─ r = flatten-workspace-tree
         ├─ f = layout floating tiling
         ├─ / = ~/.bin/show-keybindings
         └─ Esc = reload-config

THEME FLOW
~/.bin/toggle-theme  →  dotfiles/bash/dot-bin/toggle-theme (wrapper)
  └─ bash $DOTFILES/aesthetics/scripts/toggle-theme.sh    (submodule)
       ├─ kitty:  rewrite ~/.config/kitty/theme.conf symlink
       │          + kitty @ set-colors over per-pid Unix socket
       │          + SIGUSR1 (so new windows pick up the new include)
       ├─ vscode: sed-edit settings.json + AppleScript reload-window
       └─ updates ~/.config/aesthetics/theme-state.conf

ORGANIZE FLOW (service-mode S / O)
~/.bin/aerospace-organize-wrapper
  └─ ~/.bin/aerospace-organize
       └─ bun $DOTFILES/universal-layout-manager/adapters/aerospace.ts
            ├─ reads ~/.config/universal-wm/layouts.json
            ├─ resolves semantic app names ("vscode" → "com.microsoft.VSCode")
            └─ shells out to `aerospace` CLI commands
```

### The four named components

| Name | Type | Location | Role |
|------|------|----------|------|
| **aerospace** | Native macOS app (Swift) | `/Applications/AeroSpace.app` + `~/.aerospace.toml` | The actual tiling WM. |
| **universal-layout-manager** | TS/Bun, in-repo | `dotfiles/universal-layout-manager/` | Current cross-platform layout engine. macOS (aerospace) + Linux (i3/sway, stub). |
| **universal-wm** | Stow package (config only) | `dotfiles/universal-wm/dot-config/universal-wm/layouts.json` | Single source of truth for layout definitions. Also the symlinked CLI at `~/.bin/universal-wm`. |
| **aesthetics** | Git submodule | `dotfiles/aesthetics/` | Cross-platform theme system. Drives the Alt+Shift+;>T toggle. |

### Required external tools

- `aerospace` (Homebrew cask)
- `bun` at `~/.bun/bin/bun` (used by the organize chain)
- `kitty` (referenced by `show-keybindings` and the theme toggle)
- `osascript` (system; used for notifications and the VS Code reload AppleScript)

---

## Keybindings

### Main mode

#### Window navigation (Vim-style)
- `Alt + h/j/k/l` — Focus left/down/up/right
- `Alt + Shift + h/j/k/l` — Move window left/down/up/right

#### Monitor / display focus
- `Alt + s` / `Alt + g` — Focus left / right monitor
- `Alt + Shift + s` / `Alt + Shift + g` — Move window to left / right monitor
- `Alt + Shift + w` — Move workspace to next monitor

#### Window resize
- `Alt + Shift + -` — Shrink active window
- `Alt + Shift + =` — Grow active window
- `Alt + Shift + e` — Balance sizes
- `Alt + Shift + m` — Toggle fullscreen
- `Alt + Shift + t` — Toggle floating ↔ tiling

#### Layout
- `Alt + Shift + r` — Rotate layout orientation (horizontal ↔ vertical)

#### Workspaces
- `Alt + 1-6` — Jump directly to workspace 1-6
- `Alt + Shift + 1-6` — Move active window to workspace 1-6
- `Alt + Tab` / `Alt + Shift + Tab` — Cycle next / prev workspace
- `Alt + Backtick` — Workspace back-and-forth

#### App launch
- `Cmd + Enter` — Launch Kitty

#### Multi-window cycling (native macOS)
- `Alt + Backtick (`` ` ``)` — Cycle windows of the same app (e.g. multiple VS Code windows)

#### Utility
- `Alt + Shift + d` — Open dotfiles directory (`~/.bin/open-dotfiles`)

### Service mode (gateway: `Alt + Shift + ;`)

| Key | Action | Exits service mode? |
|-----|--------|---------------------|
| `Esc` | Reload config | Yes |
| `t` | Toggle theme (primary ↔ alucard) | Yes |
| `c` | Cycle through all theme variants | **No** (rapid cycling) |
| `s` | "Startup" — launch all apps + organize into workspaces | Yes |
| `o` | Organize existing windows only (no launch) | Yes |
| `r` | Reset / flatten workspace tree | Yes |
| `f` | Toggle floating / tiling | Yes |
| `/` (`?`) | Show keybindings overlay | Yes |
| `Backspace` | Close all windows except current | Yes |
| `Alt + Shift + h/j/k/l` | Join with window in direction (i3 tabbed/stacked) | Yes |

---

## Workspace auto-assignment

These rules only apply to **newly opened** windows. To organize existing windows, use `Alt + Shift + ; → o` or run `~/.bin/aerospace-organize --no-launch`.

| Workspace | Apps |
|-----------|------|
| 1 (Start) | Finder |
| 2 (Comms) | Spotify, Signal, Messages |
| 3 (Browser) | Firefox, Brave, Safari, Chrome |
| 4 (Code) | VS Code, Kitty, iTerm2, Terminal |
| 5 (Org) | Calendar, Mail |
| 6 (Games) | League of Legends, Riot client, Steam, Discord |

Apps that always float (regardless of workspace): System Preferences, 1Password, Calculator, Dictionary, App Store, Activity Monitor, VLC, VirtualBox, archive utility, game clients (LoL / Riot / Steam — intentional, since AeroSpace lacks per-workspace floating defaults).

---

## Installation

### Prerequisites

```bash
brew install --cask aerospace
brew install bun                # for the organize chain
```

### Stow the configs

```bash
cd ~/Documents/Code/dotfiles
stow --target="$HOME" aerospace bash universal-wm universal-layout-manager
```

This places `~/.aerospace.toml`, scripts under `~/.bin/`, and `~/.config/universal-wm/layouts.json`.

### AeroSpace launches at login via `start-at-login = true` in the config.

---

## Layout definitions

Layouts live in `~/.config/universal-wm/layouts.json` (stowed from `dotfiles/universal-wm/dot-config/universal-wm/layouts.json`). The format uses **semantic app names** that the adapter maps to platform-specific bundle IDs:

```json
{
  "code": {
    "name": "Code Layout",
    "orientation": "horizontal",
    "windows": [
      { "app": "vscode", "size": "2/3" },
      { "app": "kitty",  "size": "1/3" }
    ]
  }
}
```

The aerospace adapter at `universal-layout-manager/adapters/aerospace.ts` resolves `"vscode"` → `"com.microsoft.VSCode"` via `appMappings` and then drives `aerospace` CLI commands (`flatten-workspace-tree`, `move-node-to-workspace`, `join-with`, `resize`).

### Why this approach

- **Tree-based, not pixel-based** — layouts survive resolution and monitor changes.
- **Cross-platform** — semantic names allow the same `layouts.json` to drive i3/sway adapters (Linux support is stubbed).
- **No macOS Accessibility APIs needed** — uses AeroSpace's native tree primitives.

---

## Troubleshooting

### Config not loading
```bash
aerospace list-workspaces           # syntax check
tail -f ~/Library/Logs/AeroSpace/AeroSpace.log
```

### Theme toggle doesn't recolor live Kitty windows
- `kitty.conf` requires `allow_remote_control socket-only` and `listen_on unix:/tmp/mykitty-{kitty_pid}` to be set. After editing, **full Cmd+Q + relaunch** of Kitty is required — config reload alone does NOT open the socket.
- Verify: `ls /tmp/mykitty-*` should show one socket per kitty.app instance.
- Smoke test: `kitty @ --to unix:/tmp/mykitty-<pid> ls`.

### Organize fails / log
```bash
tail -f /tmp/aerospace-organize.log
```

### Finding app bundle IDs
```bash
aerospace list-apps
osascript -e 'id of app "AppName"'
```

### Accessibility permissions
System Settings → Privacy & Security → Accessibility → enable AeroSpace.

---

## Resources

- [AeroSpace official guide](https://nikitabobko.github.io/AeroSpace/guide)
- [AeroSpace commands reference](https://nikitabobko.github.io/AeroSpace/commands)
- [AeroSpace GitHub](https://github.com/nikitabobko/AeroSpace)
