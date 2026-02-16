#!/usr/bin/env bash
# macOS Configuration and Setup Script
# Useful reference: https://www.alchemists.io/projects/mac_os-config/

set -e  # Exit on error

# Source shared output library
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/output.sh"

#==============================================================================
# Flag Parsing
#==============================================================================
NON_INTERACTIVE=false
for arg in "$@"; do
  case $arg in
    --non-interactive|--yes)
      NON_INTERACTIVE=true
      shift
      ;;
  esac
done

# Local helper for interactive prompts (not in lib)
ask() {
    echo -e "${YELLOW}?${NC} $1"
}

#==============================================================================
# iCloud Drive Setup
#==============================================================================
out_info "Checking iCloud Drive configuration..."

ICLOUD_PATH="/Users/$USER/Library/Mobile Documents/com~apple~CloudDocs"

# Function to check if a directory is using native iCloud sync
is_icloud_synced() {
    local dir="$1"
    # Check for iCloud extended attributes (com.apple.icloud* attributes indicate native sync)
    if [ -d "$dir" ]; then
        if xattr "$dir" 2>/dev/null | grep -q "com.apple.icloud"; then
            return 0
        fi
    fi
    return 1
}

if [ -d "$ICLOUD_PATH" ]; then
    out_success "iCloud Drive detected at: $ICLOUD_PATH"

    out_info ""
    out_info "iCloud Drive Sync Options:"
    out_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    out_info "You have two options for syncing folders with iCloud:"
    out_info "  1. Native macOS iCloud sync (recommended for Documents/Desktop)"
    out_info "  2. Manual symlinks (recommended for Downloads and custom folders)"
    out_info ""
    out_info "To enable native iCloud sync for Desktop & Documents:"
    out_info "  → System Settings → Apple ID → iCloud Drive → Options"
    out_info "  → Enable 'Desktop & Documents Folders'"
    out_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    out_info ""

    # Helper function to handle folder symlink
    create_icloud_symlink() {
        local folder_name="$1"
        local home_path="$HOME/$folder_name"
        local icloud_path="$ICLOUD_PATH/$folder_name"

        # Check if using native iCloud sync
         if is_icloud_synced "$home_path"; then
             out_success "$folder_name is using native macOS iCloud sync (recommended)"
             return
         fi

         # Already a symlink
         if [ -L "$home_path" ]; then
             out_success "$folder_name is already a symlink"
             return
         fi

         # iCloud folder doesn't exist
         if [ ! -d "$icloud_path" ]; then
             out_warning "iCloud $folder_name folder not found, skipping"
             return
         fi

         # Ask user (skip if non-interactive mode)
         if [ "$NON_INTERACTIVE" = true ]; then
             response="y"
         else
             ask "Create symlink for $folder_name folder to iCloud Drive? (y/n)"
             read -r response
         fi

         if [[ "$response" =~ ^[Yy]$ ]]; then
             # Backup existing folder if it exists
             if [ -d "$home_path" ] && [ ! -L "$home_path" ]; then
                 out_warning "Backing up existing $folder_name to ${folder_name}.backup"
                 mv "$home_path" "${home_path}.backup"
             fi
             ln -svn "$icloud_path" "$home_path"
             out_success "$folder_name symlinked to iCloud Drive"
         fi
    }

    # Process each folder
    create_icloud_symlink "Downloads"
    create_icloud_symlink "Documents"
    create_icloud_symlink "Desktop"

else
    out_warning "iCloud Drive not found. Skipping iCloud symlinks."
    out_warning "If you want to use iCloud Drive, enable it in System Settings > Apple ID > iCloud"
fi

#==============================================================================
# Application Permissions
#==============================================================================
out_info "Setting up application permissions..."

# Remove quarantine attribute from SpaceId.app (allows it to run without security prompts)
if [ -d "/Applications/SpaceId.app" ]; then
    xattr -d com.apple.quarantine /Applications/SpaceId.app 2>/dev/null || true
    out_success "Removed quarantine from SpaceId.app"
fi
#==============================================================================
# Homebrew GNU Utilities Setup
#==============================================================================
## Requires: brew
# By default, Homebrew installs GNU utilities by prefixing each of their
# installed files with "g", thus avoiding name conflicts with existing tools.
#
# However, sometimes it is desireable to prefer the GNU version of a utility to
# the standard BSD version that ships with Darwin, without specifying the "g"
# prefix.  There are a few options: override the Homebrew installation process,
# alias commands as needed, or add to PATH and MANPATH as needed.
#
# For now, I prefer the third option, as I see this as being slightly easier
# to document my configuration.

out_info "Configuring Homebrew GNU utilities..."

# Disable Homebrew telemetry.
__HOMEBREW_PREFIX=`brew --prefix`
HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ANALYTICS

# For each specified GNU utility installed by Homebrew
for gnubrew in coreutils findutils make grep gawk gnu-units
do
    # Reference the packaged files _without_ "g" prefixes
    __libexec_prefix=$__HOMEBREW_PREFIX/opt/$gnubrew/libexec

    # Add the executables to the front of PATH
    test -d "$__libexec_prefix/gnubin" &&
        PATH=$__libexec_prefix/gnubin:$PATH

    # Add the man pages to the front of MANPATH
    test -d "$__libexec_prefix/gnuman" &&
        MANPATH=$__libexec_prefix/gnuman${MANPATH:+":$MANPATH"}
done
export PATH MANPATH

out_success "GNU utilities configured"

#==============================================================================
# macOS System Defaults
#==============================================================================
# NOTE: Some of these settings may require logging out and back in to take effect.
# NOTE: These settings were last verified on macOS Sequoia (15.x), February 2026.

out_info "Configuring macOS system defaults..."

# Screenshots - Set custom name prefix
defaults write com.apple.screencapture name kef-screenshot
out_success "Screenshot name prefix: kef-screenshot"

# Screenshots - Set save location
defaults write com.apple.screencapture location ~/Documents/Screenshots
out_success "Screenshot location: ~/Documents/Screenshots"

# Screenshots - Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true
out_success "Screenshot shadows: disabled"

# Screenshots - Set file format to PNG
defaults write com.apple.screencapture type -string "png"
out_success "Screenshot format: PNG"

# Network Browser - Show all network interfaces (useful for debugging)
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
out_success "Network Browser: show all interfaces"

# Finder - Prevent .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
out_success "Finder: disable .DS_Store on network volumes"

# Spaces - Disable spans-displays (each display has separate spaces)
defaults write com.apple.spaces spans-displays -bool false
out_success "Spaces: separate spaces per display"

# Dock - Enable autohide
defaults write com.apple.dock autohide -bool true
out_success "Dock: autohide enabled"

# Dock - Disable automatic rearranging of spaces by most recent use
defaults write com.apple.dock "mru-spaces" -bool "false"
out_success "Dock: fixed space order (disable MRU)"

# Global - Disable window animations (faster performance)
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
out_success "Window animations: disabled"

# Global - Disable quarantine for downloaded files (disables "Are you sure?" dialogs)
# WARNING: This reduces security. Only enable if you trust your download sources.
defaults write com.apple.LaunchServices LSQuarantine -bool false
out_success "Download quarantine: disabled"

# Global - Disable "natural" scrolling (makes it traditional scroll direction)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
out_success "Scroll direction: traditional (non-natural)"

# Global - Set keyboard repeat rate to fastest
defaults write NSGlobalDomain KeyRepeat -int 1
out_success "Keyboard repeat rate: fastest"

# Global - Disable automatic spelling correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
out_success "Automatic spelling correction: disabled"

# Global - Disable automatic period substitution (double-space to period)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
out_success "Automatic period substitution: disabled"

# Global - Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
out_success "Finder: show all file extensions"

# Global - Do NOT auto-hide menu bar (always visible)
defaults write NSGlobalDomain _HIHideMenuBar -bool false
out_success "Menu bar: always visible"

# Global - Set highlight color to green (0.65098 0.85490 0.58431 = green)
defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
out_success "Highlight color: green"

# Global - Set accent color to purple (6 = purple)
defaults write NSGlobalDomain AppleAccentColor -int 6
out_success "Accent color: purple"

# Global - Enable drag-on-gesture (allows dragging windows by clicking anywhere while holding modifier)
defaults write -g NSWindowShouldDragOnGesture YES
out_success "Window drag on gesture: enabled"

# Finder - Disable all animations (faster performance)
defaults write com.apple.finder DisableAllAnimations -bool true
out_success "Finder animations: disabled"

# Finder - Don't show external hard drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
out_success "Finder: hide external drives on desktop"

# Finder - Don't show hard drives on desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
out_success "Finder: hide hard drives on desktop"

# Finder - Don't show mounted servers on desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
out_success "Finder: hide mounted servers on desktop"

# Finder - Don't show removable media on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
out_success "Finder: hide removable media on desktop"

# Finder - Show hidden files
defaults write com.apple.Finder AppleShowAllFiles -bool true
out_success "Finder: show hidden files"

# Finder - Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
out_success "Finder: search current folder by default"

# Finder - Disable warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
out_success "Finder: disable extension change warning"

# Finder - Show POSIX path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
out_success "Finder: show full path in title"

# Finder - Use list view by default (Nlsv = list view)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
out_success "Finder: default view is list view"

# Finder - Hide status bar
defaults write com.apple.finder ShowStatusBar -bool false
out_success "Finder: hide status bar"

# Time Machine - Don't prompt to use new disks for backup
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
out_success "Time Machine: don't prompt for new disks"

# Safari - Disable auto-opening safe downloads
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
out_success "Safari: disable auto-open safe downloads"

# Safari - Enable Develop menu
defaults write com.apple.Safari IncludeDevelopMenu -bool true
out_success "Safari: enable Develop menu"

# Safari - Enable Web Inspector
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
out_success "Safari: enable Web Inspector"

# Mail - Don't include contact names when pasting addresses
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
out_success "Mail: paste email addresses only (no names)"

# Global - Set initial key repeat delay (lower = faster; default is 25, 15 is fast)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
out_success "Initial key repeat delay: 15 (fast)"

# Global - Enable automatic dark/light mode switching
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
out_success "Appearance: auto dark/light mode"

# Global - Small sidebar icon size (1 = small, 2 = medium, 3 = large)
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1
out_success "Sidebar icon size: small"

# Dock - Set icon size
defaults write com.apple.dock tilesize -int 70
out_success "Dock icon size: 70"

# Dock - Enable magnification
defaults write com.apple.dock magnification -bool true
out_success "Dock magnification: enabled"

# Dock - Remove autohide delay (instant show)
defaults write com.apple.dock autohide-delay -float 0
out_success "Dock autohide delay: instant"

# Dock - Disable launch bounce animation
defaults write com.apple.dock launchanim -bool false
out_success "Dock launch animation: disabled"

# Dock - Minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true
out_success "Dock: minimize to application icon"

# Dock - Don't show recent applications
defaults write com.apple.dock show-recents -bool false
out_success "Dock: hide recent applications"

# Hot Corners
# Possible values:
#  0: no-op    2: Mission Control    3: Show application windows
#  4: Desktop  5: Start screen saver 6: Disable screen saver
#  7: Dashboard (deprecated)         10: Put display to sleep
#  11: Launchpad                     12: Notification Center
#  13: Lock Screen                   14: Quick Note

# Top-right corner: disabled
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-tr-modifier -int 0
out_success "Hot corner (top-right): disabled"

# Bottom-left corner: Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0
out_success "Hot corner (bottom-left): start screen saver"

# Bottom-right corner: Disable screen saver
defaults write com.apple.dock wvous-br-corner -int 6
defaults write com.apple.dock wvous-br-modifier -int 0
out_success "Hot corner (bottom-right): disable screen saver"

# Restart Dock to apply dock/hot-corner changes
killall Dock 2>/dev/null || true
out_success "Dock restarted to apply changes"

out_success "All macOS defaults configured!"
out_warning "Some changes may require logging out and back in to take effect."

#==============================================================================
# System Integrity Protection (SIP) Status
#==============================================================================
out_info "Checking System Integrity Protection (SIP) status..."
echo ""

# Check SIP status
csrutil status

echo ""
out_info "Note: SIP is a macOS security feature. You typically want it enabled unless"
out_info "      you need advanced system modifications (e.g., loading kernel extensions)."
echo ""

#==============================================================================
# Hostname Configuration
#==============================================================================
out_info "Setting hostname..."

# Note: You may want to customize this for your machine
ask "Set hostname to kef-mbp? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    sudo scutil --set HostName kef-mbp
    out_success "Hostname set to kef-mbp"
else
    ask "Enter desired hostname (or press Enter to skip):"
    read -r hostname
    if [ -n "$hostname" ]; then
        sudo scutil --set HostName "$hostname"
        out_success "Hostname set to $hostname"
    else
        out_warning "Hostname not changed"
    fi
fi

#==============================================================================
# Window Management (universal-wm)
#==============================================================================
# The universal-wm stow package manages AeroSpace layout configuration.
# Layouts are defined in universal-wm/dot-config/universal-wm/layouts.json
# and stowed to ~/.config/universal-wm/layouts.json.
#
# See universal-layout-manager/ for the CLI tool that applies layouts.
out_info "Window management is configured via the 'universal-wm' stow package."
out_info "Run: stow --restow --target=\"\$HOME\" --dotfiles universal-wm"

#==============================================================================
# Application Cleanup Utilities
#==============================================================================
out_info "Setting up cleanup utilities..."

# Check if mas (Mac App Store CLI) is installed
if command -v mas &> /dev/null; then
    out_success "mas (Mac App Store CLI) is installed"
    out_info "You can use 'mas uninstall <app_id>' to remove Mac App Store apps"
else
    out_warning "mas (Mac App Store CLI) not found"
    ask "Install mas (Mac App Store CLI) now? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        out_info "Installing mas..."
        if brew install mas; then
            out_success "mas installed successfully"
        else
            out_error "Failed to install mas"
        fi
    else
        out_info "Skipping mas installation. Install later with: brew install mas"
    fi
fi

# Check if AppCleaner is installed
if [ -d "/Applications/AppCleaner.app" ]; then
    out_success "AppCleaner is installed"
    out_info "Use AppCleaner to completely remove applications and their files"
else
    out_warning "AppCleaner not found"
    ask "Install AppCleaner now? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        out_info "Installing AppCleaner via Homebrew..."
        if brew install --cask appcleaner; then
            out_success "AppCleaner installed successfully"
            out_info "Launch AppCleaner from /Applications to configure it"
        else
            out_error "Failed to install AppCleaner"
            out_info "Download manually from: https://freemacsoft.net/appcleaner/"
        fi
    else
        out_info "Skipping AppCleaner installation"
        out_info "Download later from: https://freemacsoft.net/appcleaner/"
        out_info "Or install via Homebrew: brew install --cask appcleaner"
    fi
fi

# Provide Homebrew cleanup commands
out_info "Homebrew cleanup commands:"
echo "  brew cleanup              # Remove old versions"
echo "  brew autoremove           # Remove unused dependencies"
echo "  brew bundle cleanup       # List packages not in Brewfile"
echo "  brew doctor               # Check for issues"
echo ""

#==============================================================================
# Completion
#==============================================================================
out_success "================================"
out_success "macOS configuration complete!"
out_success "================================"
echo ""
out_info "Next steps:"
echo "  1. Log out and back in for all changes to take effect"
echo "  2. Review SIP status if you need system modifications"
echo "  3. Run 'brew cleanup' to clean up Homebrew packages"
echo "  4. Check System Settings to verify preferences"
echo ""
