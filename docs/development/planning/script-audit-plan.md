# Script Audit Plan

**Date**: October 14, 2025
**Status**: Planning

## Overview

Comprehensive audit of all scripts in `bash/dot-bin/` and `scripts/` directories to:

1. Make scripts **semantically equivalent across platforms** (macOS, Linux, Windows)
2. Follow the **screenshot script model**: Detect OS → Use native tool → Produce consistent output
3. Classify scripts using three-tier system
4. Remove unused/obsolete scripts
5. Document all remaining scripts

## Core Principle: Cross-Platform Semantic Equivalence

### The Screenshot Model

Our modernized `screenshot` script demonstrates the ideal approach:

```bash
# 1. Detect OS once
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    esac
}

# 2. Use OS-native tools for the same task
take_screenshot() {
    case "$os" in
        macos)   screencapture -i "$output_file" ;;
        linux)   scrot --select "$output_file" ;;
        windows) # Windows Snipping Tool
    esac
}

# 3. Produce identical output/behavior
# - Same command-line interface (screenshot --select)
# - Same output location (iCloud/Dropbox/Pictures)
# - Same result (path copied to clipboard)
```

**Key Pattern**:
- ✅ Single command works everywhere: `screenshot --select`
- ✅ Uses native OS tools: `screencapture` (macOS), `scrot` (Linux), Snipping Tool (Windows)
- ✅ Consistent behavior: Always saves to predictable location, copies path to clipboard
- ✅ Graceful degradation: Checks for tool availability, provides helpful errors

### Application to All Scripts

For each script, ask:

1. **What is the semantic goal?** (What does the user want to accomplish?)
2. **What are the OS-native equivalents?** (What tool does this on each OS?)
3. **Can we abstract the interface?** (Can one command work everywhere?)
4. **Is the output consistent?** (Same result regardless of underlying tool?)

**Examples**:

| Script | Semantic Goal | macOS Tool | Linux Tool | Windows Tool |
|--------|---------------|------------|------------|--------------|
| `screenshot` | Take screenshot | `screencapture` | `scrot`/`gnome-screenshot` | Snipping Tool API |
| `lock` | Lock screen | `pmset displaysleepnow` | `xdg-screensaver lock` | `rundll32.exe user32.dll,LockWorkStation` |
| `set-wallpaper` | Change wallpaper | `osascript` | `feh`/`gsettings` | `SystemParametersInfo` |
| `extract` | Extract archive | `tar`/`unzip` | `tar`/`unzip` | `tar`/`Expand-Archive` |

---

## Audit Methodology

### Three-Tier Classification System

For each script, classify as:

1. **KEEP & IMPROVE** - Make cross-platform with OS-native tools
   - Implement OS detection
   - Map semantic goal to native tools for each OS
   - Ensure consistent interface and output
   - Add help text and error handling
   - Follow screenshot model pattern

2. **KEEP AS-IS** - Platform-specific by nature OR already working cross-platform
   - Document platform limitations clearly
   - Add basic help/comments if missing
   - Leave implementation alone unless broken

3. **ARCHIVE/REMOVE** - Obsolete, unused, or superseded
   - Move to archive or delete entirely
   - Document reason for removal

### Evaluation Criteria

For each script, answer:

- **What's the semantic goal?** (User intent, not implementation)
- **Cross-platform potential?** (Can this work on macOS, Linux, Windows?)
- **OS-native tools available?** (What's the equivalent on each platform?)
- **Still relevant?** (Dependencies installed, use case still valid)
- **When last used?** (Check shell history, git log)
- **Maintenance burden?** (Dependencies, complexity, breakage risk)
- **Superseded?** (Better tool/script exists)

### Cross-Platform Implementation Pattern

```bash
#!/usr/bin/env bash
# [Script name and purpose]
#
# Usage: script-name [OPTIONS]
# Works on: macOS, Linux, Windows

set -euo pipefail

# 1. OS Detection (reusable function)
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# 2. Main logic with OS-specific implementations
do_semantic_task() {
    local os=$(detect_os)

    case "$os" in
        macos)
            # macOS native tool
            ;;
        linux)
            # Linux native tool(s) with fallbacks
            ;;
        windows)
            # Windows native tool
            ;;
        *)
            echo "Error: Unsupported OS" >&2
            exit 1
            ;;
    esac
}

# 3. Consistent output/behavior regardless of OS
main() {
    do_semantic_task
    # Same result on all platforms
}
```---

## Script Inventory

### bash/dot-bin/

#### ✅ COMPLETED: aerospace-organize
**Status**: ✅ KEEP & IMPROVE (Just updated!)
- Cross-platform: macOS only (AeroSpace is macOS-specific)
- Recently created: Uses aerospace-layout-manager
- Well documented
- **Action**: None - already modernized

#### ✅ COMPLETED: screenshot
**Status**: ✅ KEEP & IMPROVE (Just updated!)
- Cross-platform: macOS, Linux, (Windows partial)
- Recently modernized with help text, error handling
- Smart directory detection (iCloud, Dropbox, defaults)
- **Action**: None - already modernized

---

#### 📧 checkmail
**Semantic Goal**: Check email and notify of new messages

**Current**: Simple mail checking script
**Dependencies**: Mail system (mbsync, mu)

**Cross-Platform Potential**:
- macOS: Mail.app automation, `notmuch`, `mu`
- Linux: `mbsync`, `offlineimap`, `notmuch`, `mu`
- Windows: Outlook automation, PowerShell email cmdlets

**Questions**:
- Still using this mail setup?
- What's the desired behavior? (count? notification? summary?)

**Proposed Action**: TBD

---

#### 🎨 diff-so-fancy
**Semantic Goal**: N/A (Binary tool, not a script)

**Current**: Git diff formatter (likely the actual binary)
**Dependencies**: None (self-contained)

**Questions**:
- Is this a symlink or actual binary?
- Still using for git diffs?
- Better to install via package manager? (brew, apt, choco)

**Proposed Action**: TBD - Likely ARCHIVE (use package manager instead)

---

#### 🖥️ disp-external-and-laptop.sh / disp-laptop-only.sh
**Semantic Goal**: Configure display layout (multiple displays vs laptop only)

**Current**: Display configuration scripts
**Platform**: Linux-only (xrandr)

**Cross-Platform Potential**:
- macOS: `displayplacer` or native System APIs
- Linux: `xrandr`, `wlr-randr` (Wayland)
- Windows: `DisplaySwitch.exe`, PowerShell `Set-DisplayResolution`

**Questions**:
- Still using this setup?
- Generic display switching or specific to old hardware config?
- Worth consolidating into single `display-mode` script?

**Proposed Action**: TBD - High value if made generic

---

#### � eem / em
**Semantic Goal**: TBD (need to examine - likely editor wrappers)

**Current**: Unknown (need to read files)

**Cross-Platform Potential**: Depends on what they do
- If editor launchers: Could use `$EDITOR` env var
- If Emacs-specific: `emacs`, `emacsclient` exist on all platforms

**Questions**:
- What do these do?
- Still used in workflow?

**Proposed Action**: TBD - Need examination

---

#### � extract
**Semantic Goal**: Extract any archive format to current directory

**Current**: Universal archive extractor
**Dependencies**: Various (tar, unzip, 7z, etc.)

**Cross-Platform Potential**: ⭐ HIGH VALUE
- macOS: `tar`, `unzip`, `7z` (via homebrew)
- Linux: `tar`, `unzip`, `7z`, `unrar`
- Windows: `tar` (built-in), `Expand-Archive` (PowerShell), `7z`

**Semantic Interface**: `extract file.{tar.gz,zip,7z,rar,...}`
- Detects archive type from extension
- Uses appropriate tool per OS
- Extracts to current directory
- Consistent output: "Extracted N files to ./directory"

**Proposed Action**: KEEP & IMPROVE - Perfect candidate for screenshot model

---

#### 🔧 git-completion.sh
**Current**: Git completion for bash
**Dependencies**: Git
**Initial Assessment**: TBD

**Questions**:
- Still needed? (many shells have built-in git completion now)
- Better to use package manager version?

**Proposed Action**: TBD

---

#### 🖥️ gnome-terminal.sh
**Semantic Goal**: Configure terminal emulator settings

**Current**: GNOME terminal configuration
**Platform**: Linux-only (GNOME)

**Cross-Platform Potential**:
- macOS: Terminal.app/iTerm2 settings, Kitty config
- Linux: gnome-terminal, konsole, Kitty
- Windows: Windows Terminal settings, Alacritty

**Questions**:
- Still using GNOME?
- Could be generalized to "terminal-setup" script?

**Proposed Action**: TBD - Likely ARCHIVE (terminal-specific configs better in dotfiles)

---

#### 📊 gotop
**Semantic Goal**: N/A (Binary tool, not a script)

**Current**: System monitor (likely the binary)
**Dependencies**: None (self-contained)

**Questions**:
- Is this a binary? (`file bash/dot-bin/gotop`)
- Better to install via package manager? (brew, apt, choco)

**Proposed Action**: TBD - Likely ARCHIVE (use package manager instead)

---

#### 🖼️ img_small
**Semantic Goal**: Resize/compress images

**Current**: Image resizing script
**Dependencies**: ImageMagick, sips, or similar

**Cross-Platform Potential**: ⭐ HIGH VALUE
- macOS: `sips` (built-in), ImageMagick
- Linux: ImageMagick, GraphicsMagick
- Windows: ImageMagick, PowerShell Image cmdlets

**Semantic Interface**: `img_small input.jpg [quality] [max-dimension]`
- Auto-detects image format
- Uses best available tool per OS
- Consistent output: optimized image with metadata preserved

**Proposed Action**: KEEP & IMPROVE - Good candidate for cross-platform

---

#### 🔒 lock
**Status**: ✅ KEEP & IMPROVE (Just updated!)
**Semantic Goal**: Lock screen / start screensaver

**Current**: Cross-platform screen lock utility
**Platform**: macOS, Linux, Windows

**Cross-Platform Implementation**:
- macOS: `pmset displaysleepnow` (with osascript fallback)
- Linux: `loginctl lock-session`, `xdg-screensaver lock`, multiple fallbacks
- Windows: `rundll32.exe user32.dll,LockWorkStation`

**Semantic Interface**: `lock [--help]`
- One command works everywhere
- Immediately locks screen using native OS tools
- Help text with --help flag

**Action**: ✅ COMPLETED - Modernized following screenshot model

---

#### 🔐 op
**Semantic Goal**: N/A (1Password CLI wrapper or alias)

**Current**: Likely 1Password CLI wrapper
**Dependencies**: 1Password CLI

**Questions**:
- Still using 1Password?
- What's the wrapper doing? (alias or actual script?)
- Better to use official CLI directly?

**Proposed Action**: TBD - Examine first, likely ARCHIVE

---

#### 🍎 osx-alias.sh
**Semantic Goal**: Manage macOS Finder aliases

**Current**: macOS alias management
**Platform**: macOS-only (Finder aliases)

**Cross-Platform Potential**: Low (Finder-specific feature)

**Questions**:
- Still using?
- What exactly does it do?

**Proposed Action**: TBD - Likely KEEP AS-IS (platform-specific by nature)

---

#### 🎨 set-capslock
**Semantic Goal**: Remap Caps Lock key

**Current**: Caps lock key remapping
**Platform**: TBD (need to examine)

**Cross-Platform Potential**:
- macOS: `hidutil` property mapping
- Linux: `setxkbmap`, `xmodmap`
- Windows: Registry modification, PowerShell

**Questions**:
- What does it remap to? (Ctrl? Esc?)
- Better handled by OS settings/tools like Karabiner?

**Proposed Action**: TBD - Examine implementation first

---

#### 🖼️ set-wallpaper
**Current**: Wallpaper setting script
**Platform**: TBD
**Initial Assessment**: TBD

**Questions**:
#### 🖼️ set-wallpaper
**Semantic Goal**: Change desktop wallpaper

**Current**: Wallpaper setting script
**Platform**: TBD (need to examine)

**Cross-Platform Potential**: ⭐ HIGH VALUE
- macOS: `osascript` (AppleScript) to set wallpaper
- Linux: `feh --bg-scale`, `gsettings` (GNOME), `nitrogen` (generic)
- Windows: `SystemParametersInfo` via PowerShell/C#

**Semantic Interface**: `set-wallpaper /path/to/image.jpg`
- Single command works everywhere
- Sets wallpaper on all desktops/monitors
- Handles image formats appropriately

**Proposed Action**: KEEP & IMPROVE - Excellent candidate for screenshot model

---

#### 📜 taillog
**Semantic Goal**: Follow log files with enhancements

**Current**: Log tailing script
**Dependencies**: tail (universal)

**Cross-Platform Potential**: Depends on what it adds
- If just `tail -f` wrapper: Not much value
- If adds colorization/filtering: Could use different tools per OS

**Questions**:
- What value does it add over `tail -f`?
- Still using?
- Worth keeping vs direct `tail` or modern tools like `lnav`?

**Proposed Action**: TBD - Examine, likely ARCHIVE unless adds real value

---

#### ⏰ wake-set-capslock
**Semantic Goal**: Set Caps Lock state on system wake

**Current**: Caps lock on wake
**Platform**: TBD (need to examine)

**Cross-Platform Potential**: Platform-specific implementation likely
- macOS: launchd with `SleepService` trigger
- Linux: systemd sleep hooks
- Windows: Task Scheduler with power event trigger

**Questions**:
- Still needed?
- What state does it set? (always on/off?)
- Modern OS better handles this?

**Proposed Action**: TBD - Examine, possibly ARCHIVE if obsolete

---

### scripts/

#### 🗄️ archive-old-docs.sh
**Status**: ✅ KEEP AS-IS
- Recently created for documentation management
- Working well
- Well documented
- **Action**: None

---

#### 🧹 cleanup-mac.sh
**Status**: ✅ KEEP AS-IS
- Recently created/enhanced
- macOS specific (by design)
- Working well
- **Action**: None

---

#### 🖥️ disp-external-and-laptop.sh
**Status**: DUPLICATE (also in dot-bin)
**Action**: Determine which location is correct, remove duplicate

---

#### 🖥️ disp-laptop-only.sh
**Status**: DUPLICATE (also in dot-bin)
**Action**: Determine which location is correct, remove duplicate

---

#### 🖥️ gnome-terminal.sh
**Status**: DUPLICATE (also in dot-bin)
**Action**: Determine which location is correct, remove duplicate

---

#### 📦 install-debian-packages.sh
**Current**: Debian package installation
**Platform**: Debian/Ubuntu
**Initial Assessment**: TBD

**Questions**:
- Still using Debian systems?
- Kept for historical reference?

**Proposed Action**: TBD

---

#### 🍎 install-mac.sh
**Status**: ✅ KEEP AS-IS
- Recently enhanced
- Core installation script
- Working well
- **Action**: None

---

## Audit Process

### Phase 1: Information Gathering (This Phase)
1. ✅ List all scripts
2. ✅ Create initial assessment document
3. ⏳ Examine each script's contents
4. ⏳ Check usage history
5. ⏳ Classify each script

### Phase 2: Decision Making
1. Review classifications
2. Get user confirmation on removals
3. Prioritize improvements
4. Identify quick wins

### Phase 3: Implementation
1. Archive/remove obsolete scripts
2. Improve high-priority scripts
3. Add documentation
4. Update README files

### Phase 4: Documentation
1. Update main README
2. Update dot-bin README
3. Create script reference guide
4. Document remaining scripts

---

## Quick Assessment Commands

```bash
# Check when scripts were last modified
ls -lt bash/dot-bin/ scripts/

# Search shell history for script usage
history | grep -E "checkmail|eem|em|extract|lock|op"

# Check if binaries or scripts
file bash/dot-bin/* scripts/*

# Find scripts that haven't been touched in over a year
find bash/dot-bin scripts -type f -mtime +365 -ls

# Check dependencies
for script in bash/dot-bin/*; do
    echo "=== $script ==="
    grep -E "^(command|which|type) .*&>/dev/null" "$script" || true
done
```

---

## Notes

- **Duplicates Found**: Some scripts appear in both `bash/dot-bin/` and `scripts/`
  - Need to determine canonical location
  - Probably `bash/dot-bin/` for user-facing commands
  - Probably `scripts/` for installation/maintenance scripts

- **Binaries vs Scripts**: Some entries might be compiled binaries
  - Consider removing binaries (better via package managers)
  - Keep only shell scripts in dotfiles

- **Platform-Specific**: Some scripts are inherently platform-specific
  - That's okay! Document clearly
  - Consider making wrappers that detect OS and delegate

---

## Next Steps

1. Examine contents of all TBD scripts
2. Run usage analysis commands
3. Make classification decisions
4. Get user approval for removals
5. Begin implementation phase
