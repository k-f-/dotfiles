# useful url: https://www.alchemists.io/projects/mac_os-config/

# Put downloads folder into iCloud
ln -svn /Users/kef/Library/Mobile Documents/com~apple~CloudDocs/Downloads ~/Downloads

# Allow SpaceId.app
xattr -d com.apple.quarantine /Applications/SpaceId.app
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

# macOS Settings
echo "Changing macOS defaults..."
defaults write com.apple.screencapture name kef-screenshot
defaults write com.apple.screencapture location ~/Documents/Screenshots
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write -g NSWindowShouldDragOnGesture YES
