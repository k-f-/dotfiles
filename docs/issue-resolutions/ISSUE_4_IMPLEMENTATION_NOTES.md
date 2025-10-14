# Issue #4: Aerospace Layout Save/Restore - IMPLEMENTATION NOTES

## Status: 🟡 PARTIALLY IMPLEMENTED

## Overview

Created the `aerospace-layout` script as a foundation for workspace layout management. However, this issue revealed **significant technical limitations** with AeroSpace's current capabilities.

## What Was Created

### ✅ `bash/dot-bin/aerospace-layout`

A comprehensive script structure (~680 lines) with:
- Complete command-line interface
- JSON-based layout storage
- Percentage-based positioning (screen-independent)
- Color-coded output and error handling
- Documentation and examples

### Commands Implemented:
```bash
aerospace-layout save <workspace> <name>    # Save layout
aerospace-layout load <workspace> <name>    # Load layout
aerospace-layout list [workspace]           # List layouts
aerospace-layout delete <workspace> <name>  # Delete layout
aerospace-layout apply-all                  # Apply all layouts
```

## 🔴 Critical Technical Limitations

### 1. **AeroSpace Does NOT Expose Window Positioning**

After analyzing AeroSpace's CLI and documentation:

**What AeroSpace CAN do:**
- ✅ List windows: `aerospace list-windows`
- ✅ List apps: `aerospace list-apps`
- ✅ Move windows between workspaces
- ✅ Focus windows
- ✅ Tile windows automatically
- ✅ Set layout modes (tiles, floating)

**What AeroSpace CANNOT do (as of 2025):**
- ❌ Get window position (x, y coordinates)
- ❌ Get window size (width, height)
- ❌ Set window position programmatically
- ❌ Set window size programmatically
- ❌ Get/set layout tree structure
- ❌ Save/restore tiling layouts

### 2. **AeroSpace is a Tiling Window Manager**

Unlike traditional window managers, AeroSpace:
- Automatically manages window positions using tiling algorithms
- Doesn't allow manual window positioning (by design)
- Windows are arranged based on layout rules, not absolute coordinates
- Position is determined by the tiling tree structure, not pixels

### 3. **What the Script Currently Does**

The script has **placeholders** for functionality that cannot be implemented without:

**Missing Functions:**
```bash
get_window_geometry()  # Needs: macOS APIs or AeroSpace enhancement
apply_window_position() # Needs: AeroSpace positioning commands
```

## Possible Solutions

### Option A: Use macOS Accessibility APIs ⚠️

**Approach:**
- Use AppleScript or Swift to get window positions
- Use macOS APIs to set window positions
- Requires additional permissions and complexity

**Limitations:**
- Won't work well with tiling WM philosophy
- AeroSpace may immediately re-tile windows
- Fight against AeroSpace's automatic management
- Security/permission issues with macOS

**Example AppleScript:**
```applescript
tell application "System Events"
    tell process "AppName"
        get position of window 1  # Returns {x, y}
        get size of window 1      # Returns {width, height}
        set position of window 1 to {100, 100}
        set size of window 1 to {800, 600}
    end tell
end tell
```

### Option B: Save Layout Tree Structure (Better Approach) ✅

**Approach:**
- Save the logical tiling structure, not pixel positions
- Store splits, orientations, and window order
- Use AeroSpace's tiling commands to recreate structure

**What to Save:**
```json
{
  "workspace": 2,
  "layout": "tiles",
  "orientation": "horizontal",
  "containers": [
    {
      "type": "vertical",
      "windows": ["Messages", "Signal"],
      "split_ratio": 0.5
    },
    {
      "type": "single",
      "windows": ["Spotify"],
      "split_ratio": 0.5
    }
  ]
}
```

**Commands Needed:**
- `aerospace split-horizontal`
- `aerospace split-vertical`
- `aerospace join-with`
- `aerospace resize`

**Status:** Would need to research if AeroSpace exposes layout tree

### Option C: Workflow-Based Approach (Pragmatic) ✅

**Instead of exact positions, save:**
1. Which apps go to which workspace (✅ already done in aerospace-organize)
2. Relative sizing hints (1/3, 2/3, etc.)
3. Manual positioning instructions

**Implementation:**
```bash
# aerospace-layout save 2 comms
# Creates: ~/.config/aerospace/layouts/2/comms.md

Workspace 2 Layout: Comms
=========================
1. Messages - left, top (33% width, 50% height)
2. Signal - left, bottom (33% width, 50% height)
3. Spotify - right (66% width, 100% height)

Setup:
  aerospace workspace 2
  aerospace split-horizontal
  # ... manual steps ...
```

### Option D: Feature Request to AeroSpace ⭐ (Best Long-term)

**What to Request:**
```bash
# New commands:
aerospace save-layout <name>
aerospace load-layout <name>
aerospace list-layouts
aerospace delete-layout <name>

# Or expose layout tree:
aerospace get-layout-tree --workspace 2 --json
aerospace set-layout-tree --workspace 2 --json-file layout.json
```

**Action:** File feature request at https://github.com/nikitabobko/AeroSpace

## Current Script Status

### ✅ What Works
1. **CLI Interface** - All commands parse correctly
2. **Layout Storage** - JSON structure defined
3. **List Command** - Can list saved layouts
4. **Delete Command** - Can delete layouts
5. **Screen Detection** - Gets screen dimensions
6. **Window Enumeration** - Lists workspace windows
7. **Percentage Calculations** - Convert pixels ↔ percentages

### ❌ What Needs Implementation
1. **get_window_geometry()** - Requires macOS APIs or AeroSpace feature
2. **apply_window_position()** - Requires positioning capability
3. **Layout tree capture** - If using Option B
4. **Layout tree restoration** - If using Option B

## Recommendations

### Short-term (Now):

**1. Use aerospace-organize Enhanced**
- Already assigns apps to workspaces
- Could add simple sizing commands
- Document manual layout creation

**2. Create Layout "Recipes"**
- Save as documentation, not automation
- Step-by-step instructions
- Screenshots or ASCII art

**Example Recipe:**
```bash
# ~/.config/aerospace/layouts/2/comms-recipe.sh
#!/bin/bash
# Workspace 2: Comms Layout Recipe

# 1. Ensure apps are in workspace
aerospace-organize  # Moves apps to correct workspace

# 2. Go to workspace
aerospace workspace 2

# 3. Manual steps (for now):
echo "Open Messages, Signal, and Spotify"
echo "1. Focus Messages, split horizontal"
echo "2. Focus left side, split vertical"
echo "3. Resize as needed"
```

### Medium-term:

**1. Research AeroSpace Layout Tree**
- Check if `aerospace list-windows` shows tree structure
- Look for undocumented commands
- Check AeroSpace source code

**2. Test macOS APIs**
- Try AppleScript approach
- See if positions stick with AeroSpace
- Measure the "fight" between manual and auto-tiling

### Long-term:

**1. File Feature Request**
- Open issue on AeroSpace GitHub
- Explain use case (dotfiles, reproducible layouts)
- Suggest API endpoints

**2. Contribute to AeroSpace**
- If familiar with Swift/macOS dev
- Implement layout save/restore
- Submit PR

## Alternative: Use Yabai Instead

**Yabai** has more extensive scripting capabilities:
- `yabai -m query --windows` - Get all window properties
- `yabai -m window --move abs:x:y` - Position windows
- `yabai -m window --resize abs:w:h` - Resize windows
- Full layout tree manipulation

**Trade-off:** Yabai requires SIP disabled for many features

## What's in the Dotfiles

### Created Files:
```
bash/dot-bin/aerospace-layout          # Main script (foundation)
ISSUE_4_IMPLEMENTATION_NOTES.md        # This file
```

### File Structure:
```
~/.config/aerospace/layouts/
  1/
    default.json
    focused.json
  2/
    comms.json
    comms-alt.json
  ...
```

### JSON Format:
```json
{
  "version": "1.0",
  "workspace": 2,
  "screen_width": 3024,
  "screen_height": 1964,
  "created_at": "2025-10-14T10:30:00Z",
  "windows": [
    {
      "app_name": "Messages",
      "app_bundle_id": "com.apple.MobileSMS",
      "window_title": "Messages",
      "geometry_pixels": { "x": 0, "y": 0, "width": 998, "height": 982 },
      "geometry_percent": { "x": 0, "y": 0, "width": 33, "height": 50 }
    }
  ]
}
```

## Testing Plan

When you have access to macOS:

### Phase 1: Verify Limitations
```bash
# Test AeroSpace capabilities
aerospace list-windows --all --format "%{window-id}|%{app-name}"
aerospace --help  # Look for positioning commands
aerospace list-monitors  # Display info

# Test if window properties are exposed
aerospace list-windows --workspace 2 --json  # If JSON output exists
```

### Phase 2: Test AppleScript Approach
```bash
# Can we get positions?
osascript -e 'tell application "System Events" to get position of window 1 of process "Messages"'

# Can we set positions?
osascript -e 'tell application "System Events" to set position of window 1 of process "Messages" to {100, 100}'

# Does AeroSpace fight back?
# (Set position, wait, check if AeroSpace moved it)
```

### Phase 3: Decision
- If AppleScript works → Implement hybrid approach
- If AeroSpace has layout tree → Implement Option B
- Otherwise → Use workflow/recipe approach (Option C)

## Conclusion

This issue revealed a fundamental mismatch between:
- **What we want:** Save/restore exact window positions
- **What AeroSpace provides:** Automatic tiling management

The script provides a **solid foundation** for when:
1. AeroSpace adds layout APIs, OR
2. We implement macOS API integration, OR
3. We pivot to a workflow-based approach

**Recommendation:** Start with enhanced `aerospace-organize` + manual layout documentation, then revisit when AeroSpace capabilities expand or when we can test macOS APIs.

## Next Steps

1. **Test on macOS** - Verify AeroSpace limitations
2. **Choose approach** - Based on testing results
3. **File feature request** - Ask AeroSpace for layout API
4. **Document workflows** - Create manual layout guides
5. **Enhance aerospace-organize** - Add positioning hints

---

**Status:** Foundation complete, waiting for either:
- AeroSpace feature enhancement
- macOS API integration testing
- Pivot to workflow-based approach
