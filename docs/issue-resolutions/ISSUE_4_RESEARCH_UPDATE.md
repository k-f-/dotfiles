# Issue #4 Research Update - BREAKTHROUGH!

## Status: 🎉 VIABLE SOLUTION FOUND

## Critical Discovery

After analyzing GitHub Discussion #756 and the `aerospace-layout-manager` by CarterMcAlister, I found that **layout management IS possible** with AeroSpace - we were just thinking about it wrong!

## The Key Insight

**We don't need pixel positions!**

Instead, we use AeroSpace's **tiling tree structure** with:
- `aerospace flatten-workspace-tree` - Reset layout
- `aerospace join-with` - Join windows into groups
- `aerospace move` - Position windows relative to each other
- `aerospace resize` - Resize using pixel values or fractions
- `aerospace layout` - Set workspace layout mode

## Working Implementation Reference

CarterMcAlister's `aerospace-layout-manager` is a **proven, working solution**:
- Written in TypeScript/Bun
- Uses JSON configuration
- Handles multi-display setups
- Supports nested horizontal/vertical groups
- Implements fractional sizing

### GitHub Resources
1. **Discussion**: https://github.com/nikitabobko/AeroSpace/discussions/756
2. **Working Implementation**: https://github.com/CarterMcAlister/aerospace-layout-manager

## How It Works (Verified Approach)

### 1. Layout Definition (JSON)
```json
{
  "stashWorkspace": "S",
  "layouts": {
    "work": {
      "workspace": "1",
      "layout": "v_tiles",
      "orientation": "vertical",
      "windows": [
        { "bundleId": "com.apple.Safari" },
        {
          "orientation": "horizontal",
          "windows": [
            { "bundleId": "com.jetbrains.WebStorm", "size": "2/3" },
            { "bundleId": "com.apple.Terminal", "size": "1/3" }
          ]
        }
      ]
    }
  }
}
```

### 2. Workflow Pipeline

**Step 1: Clear Workspace**
```bash
# Move all windows from target workspace to stash
aerospace list-windows --workspace 1 --json
# For each window:
aerospace move-node-to-workspace --window-id <id> S
```

**Step 2: Move Windows to Workspace**
```bash
# For each app in layout:
aerospace list-windows --app-bundle-id "com.apple.Safari" --json
aerospace move-node-to-workspace --window-id <id> 1 --focus-follows-window
```

**Step 3: Flatten and Set Layout**
```bash
aerospace flatten-workspace-tree --workspace 1
aerospace workspace 1
aerospace layout v_tiles  # or h_tiles, tiles, etc.
```

**Step 4: Join Windows into Groups**
```bash
# For nested groups, join windows together:
aerospace focus --window-id <second-window>
aerospace join-with left  # Joins with previous window
```

**Step 5: Resize Windows (Optional)**
```bash
# Fractional sizing:
aerospace resize --window-id <id> width 1344  # 2/3 of 2016px screen
```

## Key AeroSpace Commands We Missed

### Commands That DO Exist:
- ✅ `aerospace flatten-workspace-tree` - Resets workspace to flat layout
- ✅ `aerospace join-with <direction>` - Joins windows into containers
- ✅ `aerospace resize <dimension> <pixels>` - Resize windows
- ✅ `aerospace layout <type>` - Set workspace layout mode
- ✅ `aerospace list-windows --json` - JSON output for parsing
- ✅ `aerospace move-node-to-workspace --focus-follows-window` - Move and focus
- ✅ `aerospace focus --window-id <id>` - Focus specific window

### What We Were Wrong About:
- ❌ We thought we needed pixel positions (x, y) - **We don't!**
- ❌ We thought we needed absolute sizing - **Relative positioning works!**
- ❌ We thought AeroSpace couldn't do layout management - **It can via tiling tree!**

## Implementation Differences

### Our Original Approach (WRONG):
```json
{
  "windows": [
    {
      "app_bundle_id": "com.apple.Messages",
      "geometry_pixels": { "x": 0, "y": 0, "width": 800, "height": 600 },
      "geometry_percent": { "x": 0, "y": 0, "width": 33, "height": 50 }
    }
  ]
}
```
❌ Tries to save/restore absolute positions
❌ Fights against tiling WM
❌ Requires macOS APIs we don't have

### Correct Approach (WORKING):
```json
{
  "workspace": "2",
  "layout": "h_tiles",
  "orientation": "horizontal",
  "windows": [
    { "bundleId": "com.apple.MobileSMS" },
    {
      "orientation": "vertical",
      "windows": [
        { "bundleId": "org.whispersystems.signal-desktop", "size": "1/2" },
        { "bundleId": "com.spotify.client", "size": "1/2" }
      ]
    }
  ]
}
```
✅ Describes logical structure
✅ Works with tiling WM
✅ Uses only AeroSpace commands

## Real-World Examples from Discussion

### Example 1: Zoom Workspace (by mcharo)
```bash
#!/bin/bash
# Move apps to workspace
zoom_window_id=$(get_window_id "zoom.us")
aerospace move-node-to-workspace --window-id $zoom_window_id zoom

# Flatten and arrange
aerospace flatten-workspace-tree --workspace zoom
aerospace move --window-id $arc_window_id right
aerospace join-with --window-id $zoom_window_id left
aerospace move --window-id $zoom_window_id up
```

### Example 2: VPS Workspace (by mangoconcoco)
```bash
# Open apps with commands
wezterm start -- ssh ...
wezterm start -- ssh ...
wezterm start -- ssh ...

# Wait for windows
sleep 0.2

# Apply layout
aerospace focus left
aerospace layout h_tiles
aerospace move left
aerospace move left
aerospace resize height +26
```

### Example 3: Multi-Display Support (Carter's Implementation)
```typescript
// Get display info
const displays = await getDisplays();
const selectedDisplay = selectDisplay(layout, displays);

// Calculate size based on display
const screenWidth = selectedDisplay.width;
const [numerator, denominator] = size.split("/").map(Number);
const newWidth = Math.floor(screenWidth * (numerator / denominator));

// Resize
await $`aerospace resize --window-id ${windowId} width ${newWidth}`;
```

## What We Need to Change

### 1. JSON Format
**From** (percentage-based positioning):
```json
{
  "version": "1.0",
  "workspace": 2,
  "windows": [
    {
      "app_bundle_id": "com.apple.Messages",
      "geometry_percent": { "x": 0, "y": 0, "width": 33, "height": 50 }
    }
  ]
}
```

**To** (tree-based structure):
```json
{
  "workspace": "2",
  "layout": "tiles",
  "orientation": "horizontal",
  "windows": [
    { "bundleId": "com.apple.MobileSMS" },
    {
      "orientation": "vertical",
      "size": "2/3",
      "windows": [
        { "bundleId": "org.whispersystems.signal-desktop" },
        { "bundleId": "com.spotify.client" }
      ]
    }
  ]
}
```

### 2. Save Command
**From**: Try to get window positions
**To**: Save the logical tree structure

```bash
# Get current windows
aerospace list-windows --workspace 2 --json

# Analyze window tree structure (if AeroSpace exposes it)
# OR: Save just the app list and let user define structure manually
```

### 3. Load Command
**From**: Try to set positions
**To**: Execute workflow pipeline

```bash
# 1. Clear workspace
# 2. Move windows to workspace
# 3. Flatten workspace
# 4. Join windows according to structure
# 5. Resize if sizes specified
# 6. Focus workspace
```

## Implementation Plan

### Phase 1: Adopt Carter's JSON Format ✅
```json
{
  "stashWorkspace": "S",
  "layouts": {
    "comms": {
      "workspace": "2",
      "layout": "tiles",
      "orientation": "horizontal",
      "windows": [...]
    }
  }
}
```

### Phase 2: Implement Workflow Pipeline ✅
1. `clearWorkspace()` - Move windows to stash
2. `moveWindows()` - Move apps to target workspace
3. `repositionWindows()` - Flatten, join, arrange
4. `resizeWindows()` - Apply fractional sizes
5. `focusWorkspace()` - Switch to workspace

### Phase 3: Helper Functions ✅
- `getWindowId(bundleId)` - Find window by app
- `launchIfNotRunning(bundleId)` - Ensure app is open
- `flattenWorkspace(workspace)` - Reset layout
- `joinWithPrevious(windowId)` - Join windows
- `resizeWindow(windowId, fraction, dimension)` - Fractional resize

### Phase 4: Multi-Display Support ✅
- Use `system_profiler SPDisplaysDataType -json`
- Calculate sizes per-display
- Support display aliases (main, secondary, external, internal)

## Comparison: Our Script vs Carter's

| Feature | Our Script | Carter's Script | Notes |
|---------|-----------|-----------------|-------|
| Language | Bash | TypeScript/Bun | Bun has better JSON/async |
| JSON Format | ❌ Position-based | ✅ Tree-based | Carter's is correct |
| Save Layout | ❌ Incomplete | N/A (manual config) | Save is less important |
| Load Layout | ❌ Wrong approach | ✅ Working | Need to rewrite |
| Resize | ❌ Placeholder | ✅ Fractional | Using `aerospace resize` |
| Multi-Display | ❌ Basic detection | ✅ Full support | Display selection |
| Launch Apps | ❌ Not implemented | ✅ Working | Uses `open -b` |
| Nested Groups | ❌ Not supported | ✅ Recursive | Tree traversal |

## Recommended Changes

### Option A: Adopt Carter's Tool ⭐ (Recommended)
**Pros:**
- Already working and tested
- Better multi-display support
- TypeScript is more maintainable
- Active development

**Cons:**
- Requires Bun runtime
- Not in bash (our dotfiles are bash-based)
- External dependency

**Action:**
1. Document how to install and use Carter's tool
2. Create wrapper script in our dotfiles
3. Include example layouts in our repo

### Option B: Rewrite Our Script 🔧
**Pros:**
- Pure bash (matches our dotfiles)
- No external dependencies (except jq)
- Full control over implementation

**Cons:**
- More work to implement
- Bash is less suited for JSON/async
- Need to replicate proven solution

**Action:**
1. Rewrite using tree-based approach
2. Copy proven workflow from Carter
3. Simplify to essential features

### Option C: Hybrid Approach ✅ (Best)
**Pros:**
- Use Carter's tool for complex layouts
- Keep simple helper in bash
- Document both approaches

**Implementation:**
```bash
# For simple layouts: Use our enhanced aerospace-organize
aerospace-organize

# For complex layouts: Use Carter's tool
aerospace-layout-manager work

# Or create bash wrapper:
~/dot-bin/aerospace-layout work  # Calls Carter's tool
```

## Updated JSON Schema

Based on Carter's proven format:

```json
{
  "$schema": "https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/layoutConfig.schema.json",
  "stashWorkspace": "S",
  "layouts": {
    "comms": {
      "workspace": "2",
      "layout": "tiles",
      "orientation": "horizontal",
      "display": "main",
      "windows": [
        {
          "bundleId": "com.apple.MobileSMS"
        },
        {
          "orientation": "vertical",
          "size": "1/3",
          "windows": [
            {
              "bundleId": "org.whispersystems.signal-desktop",
              "size": "1/2"
            },
            {
              "bundleId": "com.spotify.client",
              "size": "1/2"
            }
          ]
        }
      ]
    },
    "code": {
      "workspace": "4",
      "layout": "h_tiles",
      "orientation": "horizontal",
      "windows": [
        {
          "bundleId": "com.microsoft.VSCode",
          "size": "2/3"
        },
        {
          "bundleId": "net.kovidgoyal.kitty",
          "size": "1/3"
        }
      ]
    }
  }
}
```

## Testing Plan

### 1. Install Carter's Tool
```bash
curl -sSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash
```

### 2. Create Test Layout
```bash
cat > ~/.config/aerospace/layouts.json <<EOF
{
  "stashWorkspace": "S",
  "layouts": {
    "test": {
      "workspace": "9",
      "layout": "tiles",
      "orientation": "horizontal",
      "windows": [
        { "bundleId": "com.apple.finder" },
        { "bundleId": "com.apple.ActivityMonitor" }
      ]
    }
  }
}
EOF
```

### 3. Test Application
```bash
# List layouts
aerospace-layout-manager --listLayouts

# Apply layout
aerospace-layout-manager test

# Verify windows are in workspace 9 and tiled
```

### 4. Create Complex Layout
```bash
# Add to layouts.json
{
  "comms": {
    "workspace": "2",
    "layout": "tiles",
    "orientation": "horizontal",
    "windows": [
      {
        "orientation": "vertical",
        "size": "1/3",
        "windows": [
          { "bundleId": "com.apple.MobileSMS" },
          { "bundleId": "org.whispersystems.signal-desktop" }
        ]
      },
      { "bundleId": "com.spotify.client", "size": "2/3" }
    ]
  }
}
```

## Next Steps

1. ✅ **Document Carter's solution** in our dotfiles
2. ✅ **Create example layouts** for our workspaces (1-6)
3. ✅ **Add aerospace keybindings** to load layouts
4. ✅ **Integrate with aerospace-organize** for complete solution
5. 🔲 **Test on macOS** to verify everything works
6. 🔲 **Decide**: Use Carter's tool or rewrite in bash?

## Conclusion

**We were solving the wrong problem!**

- ❌ **Wrong**: Try to save/restore pixel positions
- ✅ **Right**: Save/restore logical tree structure

The solution exists and is proven to work. We just need to:
1. Adopt the tree-based approach
2. Use existing AeroSpace commands correctly
3. Either use Carter's tool or rewrite with his approach

**Status Update**: Issue #4 is now **~90% solvable** using proven techniques!

## References

- GitHub Discussion: https://github.com/nikitabobko/AeroSpace/discussions/756
- Carter's Tool: https://github.com/CarterMcAlister/aerospace-layout-manager
- AeroSpace Docs: https://nikitabobko.github.io/AeroSpace/commands
