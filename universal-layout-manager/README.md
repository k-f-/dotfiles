# universal-layout-manager

Source code for JSON-driven window layout automation. Given a layout like
"VS Code on the left two-thirds, two terminals stacked on the right
third," this resolves semantic app names to platform-specific identifiers
and drives the window manager to arrange them.

Only the macOS/AeroSpace path (`adapters/aerospace.ts`) is wired into
daily use — it's what `~/.bin/aerospace-organize` calls for every AeroSpace
service-mode `s`/`o` action. An i3/Sway adapter
(`adapters/i3-sway.ts`) is implemented but nothing in this repo invokes it
automatically. There are no Windows adapters (komorebi/GlazeWM/FancyWM are
named in `cli.ts`'s routing table but the adapter files don't exist), and
there is no test suite.

This directory is plain source — it is **not** a stow package. The layout
config it reads (`~/.config/universal-wm/layouts.json`) is stowed
separately from [`../universal-wm/`](../universal-wm/).

## Files

```
cli.ts                        # Manual "universal-wm" CLI (symlinked from ~/.bin/universal-wm)
migrate-config.ts             # One-time old-config → new-config converter
example-layouts.json          # Sample config
unified-layout.schema.json    # JSON Schema for layouts.json
core/types.ts                 # Shared types, platform/WM detection, app-id resolution
adapters/aerospace.ts         # macOS AeroSpace adapter (the one that runs)
adapters/i3-sway.ts           # Linux i3/Sway adapter (implemented, standalone)
```

## Full documentation

See **[docs/setup/window-manager.md](../docs/setup/window-manager.md)** for
architecture, the config format, manual CLI usage, and troubleshooting.
