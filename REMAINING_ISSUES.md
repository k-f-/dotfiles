# Remaining Issues Summary

## Issue #2: OSX Install.sh - STARTED

### Current Status
- Script exists at `scripts/install-mac.sh`
- Has basic macOS defaults configuration
- Missing several requested features

### TODO:
1. **Add iCloud Drive symlinks** (like Downloads symlink already exists)
   ```bash
   # Already has:
   ln -svn /Users/kef/Library/Mobile Documents/com~apple~CloudDocs/Downloads ~/Downloads
   
   # Need to add Documents and check for other folders
   ```

2. **Disable double-space period**
   ```bash
   # Add this line:
   defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
   ```

3. **Review all defaults for macOS Sequoia compatibility**
   - Check Apple documentation for deprecated/changed defaults
   - Test each setting on current macOS version
   - Add comments explaining what each does

4. **Find CLI uninstaller tool**
   - Research: AppCleaner CLI, mas-cli, or custom script
   - Implement or document recommended approach
   - Possibly integrate with Homebrew cleanup

### Next Steps:
- Update script with new defaults
- Add interactive prompts for symlink creation
- Test on macOS Sequoia
- Document all settings

---

## Issue #3: OSX Applications Cleanup - NOT STARTED

### Requirements:
1. **iCloud Drive symlinks option**
   - Make it interactive during install
   - Detect iCloud Drive location
   - Offer to symlink: Documents, Downloads, Desktop(?)
   - Check kef-mbp for reference setup

2. **Homebrew cleanup function**
   - Detect superseded/duplicate packages
   - Safe removal with confirmation
   - List unused dependencies
   - Integrate with `brew cleanup` and `brew autoremove`

### Suggested Approach:
```bash
# New script: scripts/cleanup-mac.sh
- List all installed brew packages
- Check for duplicates (e.g., python vs python3)
- Find unused dependencies
- Interactive removal
```

---

## Issue #4: Aerospace Layout Save/Restore - NOT STARTED

### Requirements (COMPLEX):

1. **Save workspace layout**
   - Capture current window positions/sizes
   - Store as percentages, not pixels
   - Save stack/split orientation
   - Store per-workspace in dotfiles
   - Example from issue:
     ```
     Workspace 2: Messages (top-left, 1/3 width, 50% height)
                  Signal (bottom-left, 1/3 width, 50% height)  
                  Spotify (right, 2/3 width, 100% height)
     ```

2. **Load workspace layout**
   - Read saved layout
   - Apply to current windows
   - Handle missing applications gracefully
   - Work across different screen sizes

3. **Delete saved layouts**
   - Remove layout file
   - List available layouts

4. **Auto-organize on launch**
   - Extend existing `aerospace-organize` script
   - Optionally launch missing applications
   - Position them according to saved layout

5. **Multi-display support**
   - Track which display owns workspace
   - Maintain or restore display assignment
   - Handle display configuration changes

### Suggested Implementation:

```bash
# New script: bash/dot-bin/aerospace-layout

Commands:
  aerospace-layout save <workspace> <name>    # Save current layout
  aerospace-layout load <workspace> <name>    # Load saved layout
  aerospace-layout list [workspace]           # List saved layouts
  aerospace-layout delete <workspace> <name>  # Delete layout
  aerospace-layout apply-all                  # Apply all saved layouts

Storage:
  ~/.config/aerospace/layouts/<workspace>/<name>.json

Format (JSON):
{
  "workspace": 2,
  "display": "main",
  "windows": [
    {
      "app": "Messages",
      "x_percent": 0,
      "y_percent": 0,
      "width_percent": 33,
      "height_percent": 50,
      "stack_position": "top"
    },
    ...
  ]
}
```

### Technical Challenges:
- AeroSpace may not expose all needed APIs
- Getting window positions/sizes programmatically
- Converting pixels to percentages accurately
- Handling resolution changes
- Dealing with windows that don't exist yet

### Research Needed:
- Check AeroSpace documentation for layout APIs
- Test `aerospace list-windows` command
- Determine if need to use macOS accessibility APIs
- See if yabai approach could be adapted

---

## Priority Order:
1. ✅ Issue #1 - COMPLETED
2. 🟡 Issue #2 - Quick wins, finish this next
3. 🟡 Issue #3 - Medium complexity
4. 🔴 Issue #4 - Most complex, may need architectural planning

## Notes:
- Issues #2 and #3 are somewhat related (both macOS system setup)
- Issue #4 is a substantial feature that may warrant breaking into sub-issues
- Should verify AeroSpace capabilities before committing to Issue #4 approach
