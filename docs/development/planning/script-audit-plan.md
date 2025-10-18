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
**Status**: **ARCHIVE** (Linux-specific, likely obsolete)
**Semantic Goal**: Check email and notify of new messages

**Current**: Linux-only email sync script
**Dependencies**: nmcli, mbsync, mu4e/Emacs
**Platform**: Linux-only

**Evaluation**:
- Very specific to old Linux mail setup (nmcli, mbsync, notmuch/mu4e)
- Not used on macOS
- Modern email clients (Mail.app, Thunderbird, web clients) handle this better

**Action**: **ARCHIVE** - Superseded by modern tools

---

#### 🎨 diff-so-fancy
**Status**: **ARCHIVE** (Use package manager instead)
**Semantic Goal**: Enhanced git diff formatter

**Current**: Fatpacked Perl script (1059 lines, self-contained)
**Dependencies**: Perl (built-in on macOS/Linux)
**Platform**: Cross-platform

**Evaluation**:
- Large fatpacked Perl script (hard to maintain in dotfiles)
- Available via package managers:
  - macOS: `brew install diff-so-fancy`
  - Linux: `apt install diff-so-fancy` or `dnf install diff-so-fancy`
  - Windows: `scoop install diff-so-fancy` or `choco install diff-so-fancy`
- Better to install via package manager (gets updates, easier to manage)
- Can still be configured in git config

**Action**: **ARCHIVE** - Document installation via package manager, remove from dot-bin

---

#### 🖥️ disp-external-and-laptop.sh / disp-laptop-only.sh
**Status**: **ARCHIVED** (Moved to scripts/archive/)
**Semantic Goal**: Configure display layout (multiple displays vs laptop only)

**Current**: Hardcoded xrandr configuration scripts (Linux-only)
**Platform**: Linux-only (xrandr, X11)
**Issues**: Hardcoded to specific hardware (eDP1, HDMI1)

**Evaluation**:
- Very specific to old laptop hardware configuration
- Hardcoded monitor identifiers and resolutions
- X11-specific (xrandr)
- Not portable or reusable
- Modern alternatives better:
  - Linux: GNOME/KDE display settings, `autorandr` (saves/loads profiles)
  - macOS: System Settings → Displays
  - Windows: Display settings, `DisplaySwitch.exe`

**Action**: **ARCHIVED** - Moved to scripts/archive/, not maintained

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

#### 📦 extract
**Status**: ✅ KEEP & IMPROVE (Just updated!)
**Semantic Goal**: Extract any archive format to current directory

**Current**: Cross-platform universal archive extractor
**Platform**: macOS, Linux, Windows (with tools installed)

**Cross-Platform Implementation**:
- Uses standard tools: `tar`, `unzip`, `7z`, `unrar`, etc.
- Cross-platform path resolution (realpath/readlink/fallback)
- Tool availability checks with helpful error messages
- Works with: tar.gz, tar.bz2, tar.xz, zip, rar, 7z, gz, bz2, xz, lzma, Z, exe

**Semantic Interface**: `extract [-c] <archive>`
- `-c` flag to extract in current directory
- Default: creates directory from archive name
- `--help` flag for usage information
- Verbose output showing extracted files
- Consistent output: "✓ Extraction complete"

**Action**: ✅ COMPLETED - Modernized with bash best practices

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
**Status**: **ARCHIVED** (Moved to scripts/archive/)
**Semantic Goal**: Configure terminal emulator settings

**Current**: Debian alternatives wrapper (Linux-only)
**Platform**: Debian/Ubuntu-only (`update-alternatives`)

**Evaluation**:
- Just runs: `sudo update-alternatives --config x-terminal-emulator`
- No value over running command directly
- Debian-specific (update-alternatives)
- Modern alternatives better:
  - Configure terminal in dotfiles (kitty/, alacritty config)
  - Use desktop environment settings
  - Run command directly when needed

**Action**: **ARCHIVED** - Moved to scripts/archive/, superseded by direct config

---

#### 📊 gotop
**Status**: **ARCHIVE** (Use package manager instead)
**Semantic Goal**: System monitor/resource viewer

**Current**: Binary executable (not a script)
**Dependencies**: None (self-contained binary)
**Platform**: Platform-specific binaries needed

**Evaluation**:
- This is a compiled binary, not a script
- Binaries don't belong in dotfiles (platform-specific, large, no source)
- Available via package managers:
  - macOS: `brew install gotop`
  - Linux: `snap install gotop` or download from GitHub releases
  - Windows: `scoop install gotop`
- Better to install via package manager (gets updates, correct architecture)

**Action**: **ARCHIVE** - Document installation via package manager, remove binary from dot-bin

---

#### 🖼️ img_small
**Status**: **KEEP & IMPROVE** (Fix bug, add help text)
**Semantic Goal**: Resize/compress images

**Current**: Image compression script using ImageMagick
**Dependencies**: ImageMagick (`magick` command)
**Platform**: Cross-platform (ImageMagick available on all platforms)
**Current Issues**:
- Bug: Uses undefined variable `$FILE` instead of `$FILE1`
- No help text or error handling
- Hardcoded output suffix and quality

**Cross-Platform Potential**: ⭐ HIGH VALUE
- macOS: `sips` (built-in), ImageMagick
- Linux: ImageMagick, GraphicsMagick
- Windows: ImageMagick, PowerShell Image cmdlets

**Semantic Interface**: `img_small input.jpg [quality] [max-dimension]`
- Auto-detects image format
- Uses best available tool per OS
- Consistent output: optimized image with metadata preserved

**Action**: **KEEP & IMPROVE** - Fix bug, modernize with help text and options

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
**Status**: **KEEP AS-IS** (Already cross-platform!)
**Semantic Goal**: Open files/URLs with default application

**Current**: Cross-platform "open" command wrapper
**Platform**: macOS + Linux (already cross-platform!)
**Dependencies**: `open` (macOS), `xdg-open` (Linux)

**Implementation**:
```bash
if [[ $(uname) == Darwin ]]; then
  open "$@"
else
  xdg-open "$@" &> /dev/null
fi
```

**Evaluation**:
- ✅ Already follows our cross-platform pattern!
- ✅ Uses OS detection (uname)
- ✅ Uses native tools (open/xdg-open)
- ✅ Consistent interface
- Simple, effective, well-implemented

**Action**: **KEEP AS-IS** - Perfect example of cross-platform done right!

---

#### 🍎 osx-alias.sh
**Status**: **KEEP AS-IS** (Platform-specific by design)
**Semantic Goal**: Create macOS Finder aliases

**Current**: macOS Finder alias creation via AppleScript
**Platform**: macOS-only (by design)
**Dependencies**: Finder, AppleScript (built-in on macOS)

**Evaluation**:
- Finder aliases are macOS-specific feature (not symlinks)
- Well-implemented with AppleScript
- Handles files and folders
- Platform-specific by nature (like creating .app bundles)
- No cross-platform equivalent (Finder aliases ≠ symlinks ≠ Windows shortcuts)

**Action**: **KEEP AS-IS** - Platform-specific tool, well-implemented

---

#### 🎨 set-capslock
**Status**: **ARCHIVE** (Linux-specific, obsolete)
**Semantic Goal**: Remap Caps Lock key to Control

**Current**: X11 key remapping script
**Dependencies**: setxkbmap, xcape (X11 tools)
**Platform**: Linux-only (X11)

**Evaluation**:
- Very X11-specific (setxkbmap, xcape)
- Modern alternatives better:
  - macOS: System Settings or Karabiner-Elements
  - Linux: GNOME Tweaks, KDE settings, or compositor config
  - Windows: PowerToys Keyboard Manager, registry edits
- Better handled at OS/desktop environment level

**Action**: **ARCHIVE** - Superseded by OS-native settings

---

#### 🖼️ set-wallpaper
**Current**: Wallpaper setting script
**Platform**: TBD
**Initial Assessment**: TBD

#### 🖼️ set-wallpaper
**Status**: **KEEP & IMPROVE** (Good cross-platform candidate)
**Semantic Goal**: Change desktop wallpaper

**Current**: Simple wallpaper setter (Linux-only)
**Platform**: Linux-only (feh)
**Current Issue**: Hardcoded to ~/.wallpaper/plant02.png

**Cross-Platform Potential**: ⭐ HIGH VALUE
- macOS: `osascript` (AppleScript) to set wallpaper
- Linux: `feh --bg-scale`, `gsettings` (GNOME), `nitrogen` (generic)
- Windows: `SystemParametersInfo` via PowerShell/C#

**Semantic Interface**: `set-wallpaper /path/to/image.jpg`
- Single command works everywhere
- Sets wallpaper on all desktops/monitors
- Handles image formats appropriately

**Action**: **KEEP & IMPROVE** - Modernize following screenshot model

---

#### 📜 taillog
**Status**: **KEEP AS-IS** (Simple and useful)
**Semantic Goal**: Follow log files with syntax highlighting

**Current**: Wrapper around `tail -f` + `bat` for colored output
**Dependencies**: `bat` (syntax highlighter)
**Platform**: Cross-platform (`tail` universal, `bat` available everywhere)

**Evaluation**:
- Simple 3-line script: `tail -f $@ | bat --paging=never -l log`
- Adds value: syntax highlighting and color to log tailing
- Already works cross-platform (both tools available on all OSes)
- No improvements needed

**Action**: **KEEP AS-IS** - Working well, minimal and effective

---

#### ⏰ wake-set-capslock
**Status**: **ARCHIVE** (Linux-specific, obsolete)
**Semantic Goal**: Set Caps Lock state on system wake

**Current**: Linux sleep/wake hook script
**Dependencies**: systemd sleep hooks, setxkbmap, xcape
**Platform**: Linux-only

**Evaluation**:
- Companion to `set-capslock` - runs on system wake
- Very specific to old Linux setup with systemd hooks
- Not portable across platforms
- Obsolete - modern OSes persist keyboard settings across sleep

**Action**: **ARCHIVE** - Obsolete, not needed on modern systems

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
