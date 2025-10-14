# Script Audit Plan

**Date**: October 14, 2025  
**Status**: Planning

## Overview

Comprehensive audit of all scripts in `bash/dot-bin/` and `scripts/` directories to:
1. Identify scripts for improvement/modernization
2. Remove unused/obsolete scripts
3. Make useful scripts cross-platform where applicable
4. Document remaining scripts

## Audit Methodology

### Three-Tier Classification System

For each script, classify as:

1. **KEEP & IMPROVE** - Actively used, worth maintaining and improving
   - Make cross-platform (macOS, Linux, Windows where applicable)
   - Add help text and error handling
   - Modernize bash practices (set -euo pipefail, etc.)
   - Add to documentation

2. **KEEP AS-IS** - Used but working fine, minimal effort
   - Add basic help/comments if missing
   - Leave implementation alone unless broken
   - Document existence

3. **ARCHIVE/REMOVE** - Obsolete, unused, or superseded
   - Move to archive or delete entirely
   - Document reason for removal

### Evaluation Criteria

For each script, answer:
- **When last used?** (check shell history, git log)
- **Still relevant?** (dependencies still installed, use case still valid)
- **Cross-platform value?** (would it be useful on multiple OSes?)
- **Maintenance burden?** (dependencies, complexity, breakage risk)
- **Superseded?** (better tool/script exists)

---

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
**Current**: Simple mail checking script
**Dependencies**: Mail system (mbsync, mu)
**Initial Assessment**: TBD

**Questions**:
- Still using this mail setup?
- Would benefit from cross-platform support?

**Proposed Action**: TBD

---

#### 🎨 diff-so-fancy
**Current**: Git diff formatter (likely the actual binary)
**Dependencies**: None (self-contained)
**Initial Assessment**: TBD

**Questions**:
- Is this a symlink or actual binary?
- Still using for git diffs?
- Better to install via package manager?

**Proposed Action**: TBD

---

#### 🖥️ disp-external-and-laptop.sh
**Current**: Display configuration script
**Platform**: Linux (xrandr)
**Initial Assessment**: TBD

**Questions**:
- Still using this setup?
- Specific to old hardware?

**Proposed Action**: TBD

---

#### 🖥️ disp-laptop-only.sh
**Current**: Display configuration script
**Platform**: Linux (xrandr)
**Initial Assessment**: TBD

**Questions**:
- Still using this setup?
- Specific to old hardware?

**Proposed Action**: TBD

---

#### 📝 eem
**Current**: TBD (need to examine)
**Initial Assessment**: TBD

---

#### 📝 em
**Current**: TBD (need to examine)
**Initial Assessment**: TBD

---

#### 📦 extract
**Current**: Universal archive extractor
**Dependencies**: Various (tar, unzip, etc.)
**Initial Assessment**: Likely useful

**Questions**:
- Still using?
- Could be made more robust/cross-platform?

**Proposed Action**: TBD

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
**Current**: GNOME terminal configuration
**Platform**: Linux (GNOME)
**Initial Assessment**: TBD

**Questions**:
- Still using GNOME?
- Relevant for current setup?

**Proposed Action**: TBD

---

#### 📊 gotop
**Current**: System monitor (likely the binary)
**Dependencies**: None (self-contained)
**Initial Assessment**: TBD

**Questions**:
- Is this a binary or script?
- Better to install via package manager?
- Still using?

**Proposed Action**: TBD

---

#### 🖼️ img_small
**Current**: Image resizing script
**Dependencies**: ImageMagick or similar
**Initial Assessment**: TBD

**Questions**:
- Still using?
- Could be made more robust?

**Proposed Action**: TBD

---

#### 🔒 lock
**Current**: Screen lock script
**Platform**: TBD
**Initial Assessment**: TBD

**Questions**:
- Platform-specific or cross-platform?
- Still relevant with modern OS lock screens?

**Proposed Action**: TBD

---

#### 🔐 op
**Current**: Likely 1Password CLI wrapper
**Dependencies**: 1Password CLI
**Initial Assessment**: TBD

**Questions**:
- Still using 1Password?
- Better to use official CLI directly?

**Proposed Action**: TBD

---

#### 🍎 osx-alias.sh
**Current**: macOS alias management
**Platform**: macOS only
**Initial Assessment**: TBD

**Questions**:
- Still using?
- What does it do?

**Proposed Action**: TBD

---

#### 🎨 set-capslock
**Current**: Caps lock key remapping
**Platform**: TBD
**Initial Assessment**: TBD

**Questions**:
- Platform-specific?
- Better handled by OS settings?

**Proposed Action**: TBD

---

#### 🖼️ set-wallpaper
**Current**: Wallpaper setting script
**Platform**: TBD
**Initial Assessment**: TBD

**Questions**:
- Cross-platform potential?
- Still using?

**Proposed Action**: TBD

---

#### 📜 taillog
**Current**: Log tailing script
**Dependencies**: tail (universal)
**Initial Assessment**: Likely simple wrapper

**Questions**:
- What value does it add over `tail -f`?
- Still using?

**Proposed Action**: TBD

---

#### ⏰ wake-set-capslock
**Current**: Caps lock on wake
**Platform**: TBD
**Initial Assessment**: TBD

**Questions**:
- macOS specific?
- Still needed?

**Proposed Action**: TBD

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
