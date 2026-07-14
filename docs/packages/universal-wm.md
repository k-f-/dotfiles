# universal-wm (stow package)

This stow package holds `~/.config/universal-wm/layouts.json` — the layout
definitions (which apps go where, per workspace) read by
[`universal-layout-manager`](../universal-layout-manager/). It contains
config only, no code.

```
universal-wm/
└── dot-config/
    └── universal-wm/
        └── layouts.json    # → ~/.config/universal-wm/layouts.json
```

```bash
cd ~/dotfiles
stow --dotfiles universal-wm
```

For the config format, how this file is consumed, and how to add layouts
or apps, see **[docs/setup/window-manager.md](../docs/setup/window-manager.md)**.
