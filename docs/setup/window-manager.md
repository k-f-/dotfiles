# Window Manager Layout Automation

Automated window layout management for AeroSpace on macOS, with an
unfinished path toward other window managers. This is the single source of
truth for the system — it replaces five older, duplicative, and partly
inaccurate documents.

## What it is

A layout is a JSON description of which apps go where in a workspace (e.g.
"VS Code on the left two-thirds, two terminals stacked on the right
third"). Applying a layout launches (or finds) those apps' windows and
arranges them via the `aerospace` CLI. Layouts are defined once in a JSON
config using semantic app names ("vscode") rather than raw bundle IDs, and
resolved to platform-specific identifiers at run time.

In practice, only the macOS/AeroSpace path is wired into daily use. An
i3/Sway adapter exists and is structurally complete, but nothing in this
repo currently invokes it automatically.

## Architecture

Two separate directories work together:

```
dotfiles/
├── universal-layout-manager/     # Source code (NOT stowed)
│   ├── cli.ts                    # Manual multiplexer CLI ("universal-wm")
│   ├── migrate-config.ts         # One-time migration helper (old → new config format)
│   ├── example-layouts.json      # Sample config
│   ├── unified-layout.schema.json
│   ├── core/
│   │   └── types.ts              # Shared types, platform/WM detection, app-id resolution
│   └── adapters/
│       ├── aerospace.ts          # macOS AeroSpace adapter — the one that actually runs
│       └── i3-sway.ts            # Linux i3/Sway adapter — implemented, not wired up
│
└── universal-wm/                 # Stow package (config ONLY, no code)
    └── dot-config/
        └── universal-wm/
            └── layouts.json      # → ~/.config/universal-wm/layouts.json
```

There is no `core/parser.ts`, `core/validator.ts`, standalone
`aerospace-adapter.ts`, or `komorebi`/`glazewm`/`fancywm` adapter file.
`cli.ts` knows the *names* of those window managers (for detection and
routing) but the adapter files behind them don't exist — it prints
"Adapter not implemented" and exits if you try. There is no test suite;
`bun test` in `universal-layout-manager/` has nothing to run.

### The automated chain (service mode)

This is what actually fires when you use AeroSpace's service mode
(`Alt+Shift+;` then `s` or `o`):

```
AeroSpace service mode: s ("startup") or o ("organize, no-launch")
  └─ ~/.bin/aerospace-organize-wrapper       (background, silences output)
       └─ ~/.bin/aerospace-organize [--no-launch]
            └─ for each layout in the config:
                 bun $DOTFILES_DIR/universal-layout-manager/adapters/aerospace.ts [--noLaunch] <layout>
                      ├─ reads ~/.config/universal-wm/layouts.json
                      ├─ resolves semantic app names ("vscode" → "com.microsoft.VSCode")
                      └─ shells out to `aerospace` CLI commands
                           (flatten-workspace-tree, move-node-to-workspace, join-with, resize, …)
```

`~/.config/universal-wm/layouts.json` is a symlink created by stowing the
`universal-wm` package — it points at
`dotfiles/universal-wm/dot-config/universal-wm/layouts.json`.

Logs land in `/tmp/aerospace-organize.log`.

### The manual CLI (`universal-wm`)

`~/.bin/universal-wm` is a symlink straight to `cli.ts`:

```
~/.bin/universal-wm -> ~/dotfiles/universal-layout-manager/cli.ts
```

It's a working multiplexer — `universal-wm apply <layout>`, `list`,
`validate`, `detect`, `migrate` — that auto-detects your platform/WM and
routes to the matching adapter. It is **not** part of the automated
service-mode chain above; `aerospace-organize` calls the adapter script
directly instead of going through `cli.ts`. Use `universal-wm` for manual
testing and debugging.

## Config format: `layouts.json`

Top-level fields:

```json
{
  "version": "1.0.0",
  "stashWorkspace": "S",
  "appMappings": { "...": "..." },
  "layouts": { "...": "..." }
}
```

- `stashWorkspace` — scratch workspace used while reorganizing windows
  (default `"S"` if omitted).
- `appMappings` — maps a semantic app key to platform-specific identifiers.
- `layouts` — named layout definitions.

### App mappings

Each key maps a semantic app name to per-platform identifiers:

```json
"vscode": { "macOS": "com.microsoft.VSCode", "linux_x11": "Code", "linux_wayland": "code-url-handler", "windows": "Code.exe" }
```

Only `macOS` is consulted by the AeroSpace adapter; the other keys exist
for the i3/Sway adapter and for the unimplemented Windows adapters.

### Layout properties

- `workspace` — workspace identifier (string or number)
- `layout` — layout type: `tiles`, `h_tiles`, `v_tiles`, `accordion`,
  `h_accordion`, `v_accordion` (AeroSpace understands these names
  directly; the i3/Sway adapter maps them to `splith`/`splitv`/`tabbed`/etc.)
- `orientation` — `horizontal` or `vertical`
- `display` — display target: `"main"`, `"secondary"`, `"internal"`,
  `"external"`, a regex-matched display name, or a display number.
  Every layout currently shipped in this repo uses `"main"`.
- `windows` — array of window items (see below)
- `gaps` — optional `{ inner, outer }` pixel spacing

### Window items

```json
// Simple window
{ "app": "browser" }

// With fractional size
{ "app": "vscode", "size": "2/3" }

// Group (nested nesting is supported)
{
  "orientation": "vertical",
  "size": "1/3",
  "windows": [
    { "app": "kitty" },
    { "app": "iterm" }
  ]
}
```

Optional per-window matching: `title` (regex) and `instanceIndex`
(0-indexed, for picking the Nth window of an app with multiple windows
open).

### Layouts currently defined

All five ship in `universal-wm/dot-config/universal-wm/layouts.json` and
all target `"display": "main"`:

| Layout | Workspace | Contents |
|--------|-----------|----------|
| `start` | 1 | Finder (2/3), Activity Monitor (1/3) |
| `comms` | 2 | Messages + Signal stacked (1/3), Spotify (2/3) |
| `browser` | 3 | Firefox |
| `code` | 4 | VS Code (2/3), Kitty + iTerm stacked (1/3) |
| `org` | 5 | Calendar (1/2), Mail (1/2) |

## Manual usage

```bash
# Multiplexer CLI (auto-detects platform/WM, routes to an adapter)
universal-wm detect                # show detected platform + window manager
universal-wm list                  # list layout names
universal-wm apply code            # apply one layout
universal-wm apply --all           # apply every layout
universal-wm apply --noLaunch code # organize existing windows, don't launch apps
universal-wm validate              # sanity-check layouts.json
universal-wm migrate               # convert an old aerospace-only config (see below)

# Or call the AeroSpace adapter directly, bypassing the CLI
bun ~/dotfiles/universal-layout-manager/adapters/aerospace.ts code
bun ~/dotfiles/universal-layout-manager/adapters/aerospace.ts --noLaunch --all
bun ~/dotfiles/universal-layout-manager/adapters/aerospace.ts --listLayouts

# The actual automated entry point (what service-mode s/o run)
~/.bin/aerospace-organize
~/.bin/aerospace-organize --no-launch
```

`migrate-config.ts` (`universal-wm migrate`, or run directly with
`--dryRun`) is a one-time compatibility tool that converts a legacy
Aerospace-only config (bundle IDs inline, no `appMappings`) into the
current format — not something you'll need on a fresh setup.

## Platform / adapter status

| Platform | Window manager | Adapter file | Status |
|----------|----------------|---------------|--------|
| macOS | AeroSpace | `adapters/aerospace.ts` | Implemented, wired into `aerospace-organize` |
| Linux | i3 / Sway | `adapters/i3-sway.ts` | Implemented, standalone — nothing in this repo calls it |
| Windows | komorebi / GlazeWM / FancyWM | — | Named in `cli.ts`'s detection/routing table only; no adapter file exists. `universal-wm apply` on Windows will print "Adapter not implemented" and exit. |

## Installation (stow)

```bash
cd ~/dotfiles
stow --dotfiles universal-wm       # ~/.config/universal-wm/layouts.json
ln -sf ~/dotfiles/universal-layout-manager/cli.ts ~/.bin/universal-wm  # usually already done
```

`universal-layout-manager/` itself is source code, not a stow package —
nothing under it gets symlinked into your home directory.

## Troubleshooting

**"Window Manager not detected"**
```bash
universal-wm detect
ps aux | grep AeroSpace       # macOS: is AeroSpace actually running?
echo $I3SOCK; echo $SWAYSOCK  # Linux
```

**"No windowId found for app"** — the app isn't running yet, or the bundle
ID in `appMappings` is wrong.
```bash
osascript -e 'application id "com.microsoft.VSCode" is running'
aerospace list-apps
```

**Layout not applying correctly**
```bash
universal-wm apply --noLaunch mylayout       # rules out app-launch timing issues
bun ~/dotfiles/universal-layout-manager/adapters/aerospace.ts mylayout  # run adapter directly, see raw output
tail -f /tmp/aerospace-organize.log
```

**Config not found** — check the symlink exists:
```bash
ls -la ~/.config/universal-wm/layouts.json
```
If missing, re-stow: `cd ~/dotfiles && stow --dotfiles universal-wm`.

## See also

- [aerospace/README.md](../../aerospace/README.md) — AeroSpace itself: keybindings, service mode, workspace auto-assignment, the theme-toggle half of the toolchain.
- [keybindings.md](../../keybindings.md) — full keybinding reference.
