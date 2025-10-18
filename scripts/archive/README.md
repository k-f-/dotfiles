# Archived Scripts

These scripts have been archived because they are obsolete or platform-specific to old hardware configurations.

## Display Configuration Scripts

### disp-external-and-laptop.sh
**Archived**: October 14, 2025
**Reason**: Linux-specific (xrandr), hardcoded to specific hardware (eDP1, HDMI1)

Hardcoded xrandr configuration for specific laptop + external monitor setup.

**Modern alternative**:
- Linux: Use GNOME/KDE display settings or `autorandr`
- macOS: System Settings → Displays
- Windows: Display settings or `DisplaySwitch.exe`

---

### disp-laptop-only.sh
**Archived**: October 14, 2025
**Reason**: Linux-specific (xrandr), hardcoded to specific hardware

Hardcoded xrandr configuration for laptop-only display.

**Modern alternative**: Same as above

---

## Terminal Configuration Scripts

### gnome-terminal.sh
**Archived**: October 14, 2025
**Reason**: Debian-specific, just runs `update-alternatives` interactively

Simple wrapper that runs:
```bash
sudo update-alternatives --config x-terminal-emulator
```

**Modern alternative**:
- Run the command directly when needed
- Set terminal preferences in desktop environment settings
- Use modern terminals like Kitty, Alacritty (configured in dotfiles)

---

## General Notes

**Why archive instead of delete**:
- Preserves history and configuration examples
- May contain useful patterns for future scripts
- Documents what was tried/used in the past

**These scripts are no longer**:
- Symlinked by install script
- Documented in README
- Maintained or updated
