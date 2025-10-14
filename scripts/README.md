# Scripts Documentation

This directory contains various setup and configuration scripts for different operating systems and environments.

## macOS Scripts

### `install-mac.sh` - macOS Setup and Configuration

A comprehensive macOS configuration script that sets up system preferences, symlinks, and utilities.

#### Features

1. **iCloud Drive Integration**
   - Interactive prompts to symlink Downloads, Documents, and Desktop to iCloud Drive
   - Automatic backup of existing directories
   - Detection of iCloud Drive availability

2. **System Defaults Configuration**
   - Screenshots: Custom naming, location, format (PNG), no shadows
   - Finder: Show hidden files, disable animations, list view, full paths
   - Dock: Autohide, fixed space order
   - Keyboard: Fastest repeat rate, disable auto-correct, disable double-space period
   - Safari: Enable developer tools, disable auto-open downloads
   - And many more! (See script for full list)

3. **Homebrew GNU Utilities**
   - Configures GNU utilities to work without "g" prefix
   - Adds to PATH and MANPATH
   - Includes: coreutils, findutils, make, grep, gawk, gnu-units

4. **Application Cleanup Utilities**
   - Information about `mas` (Mac App Store CLI)
   - AppCleaner integration
   - Homebrew cleanup commands

5. **Yabai Configuration**
   - Instructions for disabling SIP (optional)
   - Sudoers configuration guide

6. **Hostname Setup**
   - Interactive hostname configuration

#### Usage

```bash
# Run the script
cd ~/.dots/scripts
chmod +x install-mac.sh
./install-mac.sh
```

The script will:
1. Check for iCloud Drive and offer to create symlinks
2. Configure Homebrew GNU utilities
3. Apply all macOS system defaults
4. Provide instructions for optional Yabai setup
5. Optionally set hostname

#### Requirements

- macOS (tested on Sonoma 14.x, should work on Sequoia 15.x)
- Homebrew installed
- Some defaults may require logging out to take effect

#### Safety Features

- Interactive prompts for destructive operations
- Automatic backups before creating symlinks
- Clear warning messages for security-related changes
- Colored output for better visibility

#### Customization

Edit the script to:
- Change the hostname (search for `kef-mbp`)
- Add/remove specific defaults
- Modify screenshot location or naming
- Adjust which iCloud folders to symlink

#### macOS Sequoia Compatibility

The defaults in this script were last verified on macOS Sonoma (14.x). When testing on Sequoia (15.x), verify:
- Any deprecated defaults domains
- New security restrictions
- Changed behavior of existing settings

To check if a default is still valid:
```bash
defaults read <domain> <key>
```

#### Cleanup Commands

After running this script, you can clean up with:

```bash
# Homebrew cleanup
brew cleanup              # Remove old versions
brew autoremove           # Remove unused dependencies
brew bundle cleanup       # List packages not in Brewfile
brew doctor               # Check for issues

# Mac App Store CLI
mas list                  # List installed apps
mas uninstall <app_id>    # Uninstall an app

# Find large files
du -sh ~/Library/*        # Check library folder sizes
```

---

### `cleanup-mac.sh` - macOS Cleanup and Maintenance

A comprehensive cleanup script that helps maintain your macOS system by removing unused packages, cleaning caches, and identifying space-consuming files.

#### Features

1. **Disk Space Analysis**
   - Shows current disk usage
   - Analyzes Homebrew cache and Cellar sizes
   - Lists top 10 largest cache directories
   - Reports developer cache sizes

2. **Homebrew Package Analysis**
   - Lists all installed formulae and casks
   - Detects duplicate packages (python vs python3, node versions, etc.)
   - Shows statistics on installed packages

3. **Unused Dependencies Detection**
   - Finds leaf packages (explicitly installed)
   - Identifies unused dependencies with `brew autoremove`
   - Interactive removal with confirmation

4. **Outdated Packages**
   - Checks for outdated packages
   - Offers to update all packages interactively

5. **Brewfile Cleanup**
   - Compares installed packages with your Brewfile
   - Identifies packages not tracked in Brewfile
   - Helps keep Brewfile in sync with system

6. **Cache Cleanup**
   - Cleans Homebrew cache
   - Shows cache size before/after
   - Lists other manual cleanup locations

7. **Old Versions Cleanup**
   - Finds old versions of packages
   - Interactive removal of superseded versions

8. **System Diagnostics**
   - Runs `brew doctor` to check for issues
   - Reports system health

9. **Mac App Store Integration**
   - Lists installed Mac App Store apps (if mas is installed)
   - Provides commands for app management

#### Usage

```bash
# Run the cleanup script
cd ~/.dots/scripts
chmod +x cleanup-mac.sh
./cleanup-mac.sh
```

The script will:
1. Analyze disk space usage
2. Check for duplicate/unused packages
3. Offer to remove unused dependencies
4. Prompt to update outdated packages
5. Check Brewfile synchronization
6. Clean caches (with confirmation)
7. Remove old versions (with confirmation)
8. Run diagnostic checks
9. Show Mac App Store apps

#### Safety Features

- **Interactive prompts** for all destructive operations
- **Dry-run checks** before removing packages
- **Before/after reporting** for cache cleanup
- **Color-coded warnings** for potential issues
- **Summary reports** at each stage

#### What Gets Cleaned

**Automatically Analyzed:**
- Homebrew cache (`brew --cache`)
- Homebrew Cellar (`brew --prefix/Cellar`)
- User caches (`~/Library/Caches`)
- Developer caches (`~/Library/Developer`)

**Interactive Cleanup:**
- Unused Homebrew dependencies
- Outdated packages
- Old package versions
- Homebrew cache files

**Manual Cleanup Suggestions:**
- Xcode DerivedData
- Docker images/containers
- npm cache
- pip cache
- Downloads folder
- Trash bin

#### Common Duplicates Detected

The script checks for these common duplicate patterns:
- `python` vs `python3`
- `python@3.11` vs `python@3.12` vs `python@3.13`
- `node` vs `node@20` vs `node@22`
- `vim` vs `neovim`
- `grep` vs `ripgrep`

#### Best Practices

Run this script:
- **Monthly** for regular maintenance
- **After major updates** to clean up old versions
- **When disk space is low** to identify large files
- **Before backup** to reduce backup size

#### Example Output

```
╔════════════════════════════════════════════════════════════════╗
║ Disk Space Analysis
╚════════════════════════════════════════════════════════════════╝
==> Current disk usage:
  Total: 500G | Used: 350G (70%) | Available: 150G

✓ Found 156 installed formulae
✓ Found 42 installed casks
! Both python and python3 are installed (potential duplicate)

╔════════════════════════════════════════════════════════════════╗
║ Unused Dependencies
╚════════════════════════════════════════════════════════════════╝
! Found packages that can be removed:
  Would uninstall: pkg-config, readline, xz
? Remove these unused dependencies? (y/n)
```

#### Integration with Other Tools

Works well with:
- **Brewfile** (`~/.dots/homebrew/Brewfile`) - Package tracking
- **mas** - Mac App Store management
- **AppCleaner** - Complete app removal
- **brew bundle** - Brewfile operations

#### Customization

Edit the script to:
- Add more duplicate package patterns
- Change cache cleanup behavior
- Adjust which caches to analyze
- Add custom cleanup tasks

---

## Other Scripts

### `install-debian-packages.sh`
Debian/Ubuntu package installation script.

### `install.sh`
Generic installation script (cross-platform).

### Display Scripts
- `disp-external-and-laptop.sh` - Configure external display + laptop
- `disp-laptop-only.sh` - Configure laptop display only

### `gnome-terminal.sh`
GNOME Terminal configuration.

## Contributing

When modifying these scripts:
1. Test on the target platform if possible
2. Add comments explaining what each section does
3. Use colored output for user feedback
4. Add interactive prompts for destructive operations
5. Update this README with any new features
