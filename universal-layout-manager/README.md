# Universal Window Manager Layout Configuration

A unified configuration format and toolkit for managing window layouts across multiple operating systems and window managers.

## Supported Platforms

| Platform | Window Managers | Status |
|----------|----------------|--------|
| **macOS** | Aerospace | ✅ Implemented |
| **Linux** | i3, Sway | 🚧 In Progress |
| **Windows** | komorebi, GlazeWM | 📋 Planned |

## Features

- **Single Configuration File** - Write your layouts once, use everywhere
- **Platform Abstraction** - Automatically maps apps to platform-specific identifiers
- **Layout Types** - Supports tiles, accordions, BSP, columns, and more
- **Fractional Sizing** - Define window sizes as fractions (1/3, 2/3, etc.)
- **Nested Groups** - Create complex hierarchical layouts
- **Display Targeting** - Specify layouts for main, secondary, or named displays
- **JSON Schema** - Full type safety and validation

## Configuration Structure

### Basic Layout

```json
{
  "layouts": {
    "my_layout": {
      "workspace": "1",
      "layout": "tiles",
      "orientation": "horizontal",
      "display": "main",
      "windows": [
        {
          "app": "browser"
        }
      ]
    }
  }
}
```

### App Mappings

Define universal app identifiers that map to platform-specific IDs:

```json
{
  "appMappings": {
    "browser": {
      "macOS": "org.mozilla.firefox",
      "linux_x11": "firefox",
      "linux_wayland": "org.mozilla.firefox",
      "windows": "firefox.exe"
    }
  }
}
```

### Complex Layouts with Groups

```json
{
  "layouts": {
    "code": {
      "workspace": "4",
      "layout": "h_tiles",
      "orientation": "horizontal",
      "windows": [
        {
          "app": "vscode",
          "size": "2/3"
        },
        {
          "orientation": "vertical",
          "size": "1/3",
          "windows": [
            {"app": "terminal"},
            {"app": "terminal_alt"}
          ]
        }
      ]
    }
  }
}
```

## Layout Types by Platform

| Universal | Aerospace | i3 | Sway | komorebi | GlazeWM |
|-----------|-----------|-----|------|----------|---------|
| `tiles` | tiles | default | default | bsp | tiling |
| `h_tiles` | h_tiles | splith | splith | horizontal-stack | columns |
| `v_tiles` | v_tiles | splitv | splitv | vertical-stack | rows |
| `accordion` | accordion | tabbed | tabbed | - | - |
| `h_accordion` | h_accordion | tabbed | tabbed | - | - |
| `v_accordion` | v_accordion | stacking | stacking | - | - |
| `bsp` | - | - | - | bsp | tiling |
| `columns` | - | splith | splith | horizontal-stack | columns |
| `rows` | - | splitv | splitv | vertical-stack | rows |

## Usage

### macOS (Aerospace)

```bash
# Apply a layout
bun universal-layout-manager/aerospace-adapter.ts code

# Apply all layouts
bun universal-layout-manager/aerospace-adapter.ts --all

# Only organize existing windows (don't launch apps)
bun universal-layout-manager/aerospace-adapter.ts --no-launch code
```

### Linux (i3/Sway)

```bash
# Apply a layout
bun universal-layout-manager/i3-adapter.ts code

# Apply all layouts
bun universal-layout-manager/i3-adapter.ts --all
```

### Windows (komorebi)

```powershell
# Apply a layout
bun universal-layout-manager/komorebi-adapter.ts code

# Apply all layouts
bun universal-layout-manager/komorebi-adapter.ts --all
```

## Window Identification

Each platform uses different methods to identify applications:

- **macOS (Aerospace)**: Bundle IDs (e.g., `com.google.Chrome`)
- **Linux X11 (i3)**: Window class (e.g., `Google-chrome`)
- **Linux Wayland (Sway)**: App ID (e.g., `org.mozilla.firefox`)
- **Windows (komorebi/GlazeWM)**: Process name (e.g., `chrome.exe`)

The universal config abstracts this away using the `appMappings` section.

## Configuration Options

### Layout Properties

- **workspace** - Workspace identifier (string or number)
- **layout** - Layout type (see table above)
- **orientation** - Primary orientation: `horizontal` or `vertical`
- **display** - Display target:
  - `"main"` - Primary display
  - `"secondary"` - Secondary display
  - `"internal"` - Built-in laptop display
  - `"external"` - External monitor
  - `"Display Name"` - Regex match display name
  - `1`, `2`, etc. - Display number
- **windows** - Array of window items (see below)
- **gaps** - Gap configuration (optional):
  - `inner` - Pixels between windows
  - `outer` - Pixels between windows and edges

### Window Items

#### Simple Window

```json
{
  "app": "browser"
}
```

#### Window with Size

```json
{
  "app": "vscode",
  "size": "2/3"
}
```

#### Window Group

```json
{
  "orientation": "vertical",
  "windows": [
    {"app": "terminal"},
    {"app": "terminal_alt"}
  ]
}
```

#### Window Group with Size

```json
{
  "orientation": "vertical",
  "size": "1/3",
  "windows": [
    {"app": "terminal"},
    {"app": "terminal_alt"}
  ]
}
```

### Advanced Window Properties

- **title** - Match specific window by title regex
- **instanceIndex** - Select Nth instance if multiple windows (0-indexed)

```json
{
  "app": "browser",
  "title": "GitHub.*",
  "instanceIndex": 1
}
```

## Platform-Specific Adapters

### Architecture

```
universal-layout-manager/
├── unified-layout.schema.json    # JSON schema
├── example-layouts.json          # Example config
├── core/
│   ├── types.ts                  # Shared TypeScript types
│   ├── parser.ts                 # Config parser
│   └── validator.ts              # Schema validator
├── adapters/
│   ├── aerospace.ts              # macOS Aerospace adapter
│   ├── i3.ts                     # Linux i3 adapter
│   ├── sway.ts                   # Linux Sway adapter
│   ├── komorebi.ts               # Windows komorebi adapter
│   └── glazewm.ts                # Windows GlazeWM adapter
└── cli.ts                        # Universal CLI entry point
```

## Development

### Prerequisites

- Bun runtime
- Target window manager installed and configured

### Building

```bash
cd universal-layout-manager
bun install
bun run build
```

### Testing

```bash
# Test on current platform
bun test

# Test config validation
bun run validate example-layouts.json
```

## Migration Guide

### From Aerospace Config

Your existing `~/.config/aerospace/layouts.json` can be easily migrated:

1. Copy your layouts to the unified config
2. Add appMappings for other platforms
3. Update bundle IDs to use universal app keys

### Example Migration

**Before (Aerospace-only):**
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

**After (Universal):**
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

## Contributing

Contributions are welcome! Please:

1. Follow the existing code style
2. Add tests for new features
3. Update documentation
4. Test on target platforms

## License

MIT

## Related Projects

- [Aerospace](https://github.com/nikitabobko/AeroSpace) - Tiling window manager for macOS
- [i3](https://i3wm.org/) - Tiling window manager for X11
- [Sway](https://swaywm.org/) - i3-compatible Wayland compositor
- [komorebi](https://github.com/LGUG2Z/komorebi) - Tiling window manager for Windows
- [GlazeWM](https://github.com/glzr-io/glazewm) - i3-inspired tiling manager for Windows
