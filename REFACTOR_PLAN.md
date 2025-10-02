# Dotfiles Refactor & Improvement Plan

**Branch:** `refactor/improvements`
**Date:** October 2, 2025

## Current State Analysis

### Strengths
- ✅ Uses GNU Stow for symlink management
- ✅ Supports multiple platforms (macOS, Linux)
- ✅ Modular configuration structure
- ✅ Brewfile for macOS package management

### Issues Identified

1. **Repetitive Code**: The `install.sh` script has 15+ repetitive `stow` commands
2. **Hard-coded Paths**: Multiple references to `~/.dotfiles` assume specific location
3. **No Error Handling**: Scripts don't check if commands succeed/fail
4. **Platform Detection**: No automatic OS detection in main install script
5. **Manual Updates**: Package lists need manual synchronization
6. **Deprecated Tools**: `youtube-dl` is deprecated (use `yt-dlp` instead)
7. **No Idempotency**: Scripts don't check if actions already completed
8. **Documentation Gaps**: Installation instructions scattered/incomplete
9. **Hard Dependency on External Services**: Dropbox folder linking in install.sh
10. **No Backup Strategy**: No mechanism to backup existing configs before symlinking

---

## Proposed Improvements

### 1. **Create a Unified Installation Script**

**Priority:** High
**Effort:** Medium

Create a single `install` script that:
- Auto-detects the operating system
- Runs appropriate package manager installations
- Handles stow operations in a loop
- Provides interactive prompts for optional components
- Includes proper error handling and logging

**Files to create:**
- `install` (main entry point)
- `lib/utils.sh` (shared functions)
- `lib/detect.sh` (OS/platform detection)

**Benefits:**
- Single command to set up everything
- Easier maintenance
- Better user experience

---

### 2. **Refactor Stow Operations**

**Priority:** High
**Effort:** Low

Replace repetitive stow commands with a loop:

```bash
# Instead of 15+ individual stow commands
STOW_PACKAGES=(
  bash emacs doom git gnupg kitty mail vim
  x-windows secrets youtube-dl ssh zsh yabai skhd
)

for package in "${STOW_PACKAGES[@]}"; do
  stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles "$package"
done
```

**Benefits:**
- Easier to add/remove packages
- Reduces code duplication
- Less prone to copy-paste errors

---

### 3. **Add Configuration File**

**Priority:** Medium
**Effort:** Low

Create a `.dotfilesrc` or `config.yaml` file:

```yaml
# Example structure
dotfiles_dir: ~/.dotfiles
stow_target: $HOME
stow_options:
  verbose: 4
  ignore: '^README.*'
  dotfiles: true

packages:
  core:
    - bash
    - zsh
    - git
    - vim
  optional:
    - emacs
    - doom
    - kitty
    - yabai
    - skhd

platforms:
  macos:
    package_manager: homebrew
    brewfile: homebrew/Brewfile
  linux:
    package_manager: apt
    package_script: scripts/install-debian-packages.sh
```

**Benefits:**
- Centralized configuration
- Easy customization per machine
- Self-documenting

---

### 4. **Improve Error Handling & Safety**

**Priority:** High
**Effort:** Medium

Add proper checks:

```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: stow is not installed"
    exit 1
fi

# Backup existing configs
backup_existing_configs() {
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    # ... backup logic
}

# Verify stow succeeded
if ! stow --target="$HOME" "$package" 2>&1; then
    echo "Warning: Failed to stow $package"
    continue
fi
```

**Benefits:**
- Prevents data loss
- Better debugging
- More reliable installations

---

### 5. **Modularize Platform-Specific Code**

**Priority:** Medium
**Effort:** Medium

Create platform-specific modules:

```
lib/
├── platform/
│   ├── macos.sh      # macOS-specific setup
│   ├── linux.sh      # Linux-specific setup
│   └── common.sh     # Shared functionality
```

**Benefits:**
- Cleaner separation of concerns
- Easier to test individual platforms
- Simpler to add new platforms (e.g., WSL)

---

### 6. **Add Dependency Management**

**Priority:** Medium
**Effort:** Low

Track dependencies between packages:

```bash
# Define package dependencies
declare -A PACKAGE_DEPS=(
    [doom]="emacs"
    [yabai]="skhd"
)

# Install in correct order
```

**Benefits:**
- Ensures proper installation order
- Prevents missing dependencies

---

### 7. **Modernize Package Lists**

**Priority:** Medium
**Effort:** Low

Updates needed:
- Replace `youtube-dl` → `yt-dlp` (actively maintained fork)
- Review deprecated packages
- Add modern alternatives where appropriate
- Consider adding:
  - `delta` (better git diffs)
  - `fd` (faster find)
  - `exa`/`eza` (modern ls replacement)
  - `lazygit` (terminal UI for git)

---

### 8. **Add Interactive Setup Wizard**

**Priority:** Low
**Effort:** Medium

Create an interactive installer:

```bash
./install --interactive

# Prompts:
# - Which packages to install? (Select from list)
# - Install GUI apps? (y/n)
# - Configure macOS defaults? (y/n)
# - Link cloud storage? (y/n)
```

**Benefits:**
- User-friendly for new machines
- Skip unwanted components
- Faster minimal installations

---

### 9. **Improve Documentation**

**Priority:** High
**Effort:** Low

Enhance README.md with:
- Clear installation instructions
- Requirements section
- Troubleshooting guide
- Package descriptions
- Architecture overview
- Contributing guidelines

Add per-directory READMEs explaining what each config does.

---

### 10. **Add Testing & Validation**

**Priority:** Low
**Effort:** High

Create test scripts:
- Verify symlinks are correct
- Check for broken links
- Validate config syntax
- Test on fresh VM/container
- Add GitHub Actions CI to test on multiple platforms

---

### 11. **Create Uninstall Script**

**Priority:** Low
**Effort:** Low

Add `uninstall` script to:
- Remove all symlinks
- Optionally restore backups
- Clean up installed packages

---

### 12. **Bootstrap Script for Fresh Machines**

**Priority:** Medium
**Effort:** Low

Create a one-liner to get started:

```bash
# On fresh machine:
curl -fsSL https://raw.githubusercontent.com/k-f-/dotfiles/main/bootstrap.sh | bash
```

The bootstrap script would:
1. Install git
2. Clone the repo
3. Run the main installer

---

## Implementation Priority

### Phase 1: Foundation (Do First)
1. ✅ Create refactor branch (DONE)
2. Create unified install script with error handling
3. Refactor stow operations (eliminate repetition)
4. Improve documentation

### Phase 2: Safety & Reliability
5. Add backup functionality
6. Add dependency management
7. Improve error handling throughout

### Phase 3: Enhancements
8. Add configuration file
9. Modularize platform-specific code
10. Modernize package lists
11. Create bootstrap script

### Phase 4: Polish
12. Add interactive setup wizard
13. Create uninstall script
14. Add testing & CI

---

## Quick Wins (Easy Improvements to Start With)

1. **Loop the stow commands** - 5 minutes
2. **Add `set -euo pipefail`** - 1 minute
3. **Replace youtube-dl with yt-dlp** - 2 minutes
4. **Add basic error messages** - 10 minutes
5. **Create better README** - 20 minutes

---

## Files to Create

```
dotfiles/
├── install                          # NEW: Main entry point
├── uninstall                        # NEW: Removal script
├── bootstrap.sh                     # NEW: One-liner installer
├── .dotfilesrc.example             # NEW: Configuration template
├── lib/                            # NEW: Shared libraries
│   ├── utils.sh                    # Helper functions
│   ├── detect.sh                   # OS detection
│   ├── backup.sh                   # Backup logic
│   └── platform/
│       ├── macos.sh                # macOS setup
│       ├── linux.sh                # Linux setup
│       └── common.sh               # Shared code
├── docs/                           # NEW: Better documentation
│   ├── INSTALLATION.md
│   ├── TROUBLESHOOTING.md
│   └── PACKAGES.md
└── tests/                          # NEW: Validation scripts
    ├── test-symlinks.sh
    └── test-install.sh
```

---

## Breaking Changes to Consider

- Move from `~/.dotfiles` to any directory (use `$DOTFILES_DIR`)
- Rename `scripts/` to `bin/` or `libexec/`
- Split macOS settings into separate opt-in script
- Remove hard-coded Dropbox dependencies

---

## Next Steps

1. Review this plan
2. Decide which improvements to implement
3. Start with Phase 1 (foundation)
4. Test on a VM or separate user account
5. Gradually migrate to new structure

---

## Notes

- Keep the old scripts as `.legacy` files during transition
- Test each change individually
- Document breaking changes
- Consider semantic versioning for releases
- Add CHANGELOG.md to track changes
