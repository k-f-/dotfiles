#!/usr/bin/env bash
# macOS Cleanup and Maintenance Script
# Helps clean up Homebrew packages, caches, and identify unused applications

set -euo pipefail  # Exit on error, unset vars, pipe failures

#==============================================================================
# Color output helpers
#==============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

info() {
    echo -e "${BLUE}==>${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}!${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

ask() {
    echo -e "${YELLOW}?${NC} $1"
}

section() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $1"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
}

#==============================================================================
# Check Requirements
#==============================================================================
section "Checking Requirements"

if ! command -v brew &> /dev/null; then
    error "Homebrew is not installed. This script requires Homebrew."
    exit 1
fi
success "Homebrew is installed"

#==============================================================================
# Disk Space Analysis
#==============================================================================
section "Disk Space Analysis"

info "Current disk usage:"
df -h / | tail -n 1 | awk '{print "  Total: " $2 " | Used: " $3 " (" $5 ") | Available: " $4}'

echo ""
info "Checking large directories..."

# Check common space-consuming directories
echo ""
info "Homebrew cache size:"
if [ -d "$(brew --cache)" ]; then
    du -sh "$(brew --cache)" | awk '{print "  " $1}'
else
    echo "  Not found"
fi

info "Homebrew Cellar size:"
if [ -d "$(brew --prefix)/Cellar" ]; then
    du -sh "$(brew --prefix)/Cellar" | awk '{print "  " $1}'
else
    echo "  Not found"
fi

info "User cache size (~/Library/Caches):"
if [ -d "$HOME/Library/Caches" ]; then
    du -sh "$HOME/Library/Caches" | awk '{print "  " $1}'
    echo ""
    info "Top 10 largest cache directories:"
    du -sh "$HOME/Library/Caches"/* 2>/dev/null | sort -rh | head -n 10 | awk '{print "  " $1 "\t" $2}'
else
    echo "  Not found"
fi

info "Developer-related cache:"
if [ -d "$HOME/Library/Developer" ]; then
    du -sh "$HOME/Library/Developer" | awk '{print "  " $1}'
else
    echo "  Not found"
fi

#==============================================================================
# Homebrew Package Analysis
#==============================================================================
section "Homebrew Package Analysis"

info "Analyzing installed Homebrew packages..."
echo ""

# List all installed formulae
INSTALLED_FORMULAE=$(brew list --formula)
FORMULAE_COUNT=$(echo "$INSTALLED_FORMULAE" | wc -l | tr -d ' ')
success "Found $FORMULAE_COUNT installed formulae"

# List all installed casks
INSTALLED_CASKS=$(brew list --cask 2>/dev/null || echo "")
if [ -n "$INSTALLED_CASKS" ]; then
    CASKS_COUNT=$(echo "$INSTALLED_CASKS" | wc -l | tr -d ' ')
    success "Found $CASKS_COUNT installed casks"
else
    info "No casks installed"
fi

# Check for duplicate/similar packages
echo ""
info "Checking for potential duplicate packages..."

# Common duplicates to check for
DUPLICATES_FOUND=0

check_duplicate() {
    local pkg1=$1
    local pkg2=$2
    if echo "$INSTALLED_FORMULAE" | grep -q "^${pkg1}$" && echo "$INSTALLED_FORMULAE" | grep -q "^${pkg2}$"; then
        warning "Both $pkg1 and $pkg2 are installed (potential duplicate)"
        DUPLICATES_FOUND=$((DUPLICATES_FOUND + 1))
    fi
}

# Check common duplicates
check_duplicate "python" "python3"
check_duplicate "python@3.11" "python@3.12"
check_duplicate "python@3.12" "python@3.13"
check_duplicate "node" "node@20"
check_duplicate "node@20" "node@22"
check_duplicate "vim" "neovim"
check_duplicate "grep" "ripgrep"

if [ $DUPLICATES_FOUND -eq 0 ]; then
    success "No obvious duplicates found"
fi

#==============================================================================
# Unused Dependencies
#==============================================================================
section "Unused Dependencies"

info "Finding unused dependencies (leaves)..."
LEAVES=$(brew leaves)

if [ -n "$LEAVES" ]; then
    echo ""
    info "Leaf packages (not dependencies of other packages):"
    echo "$LEAVES" | awk '{print "  • " $0}'
    echo ""
    LEAVES_COUNT=$(echo "$LEAVES" | wc -l | tr -d ' ')
    info "Found $LEAVES_COUNT leaf packages"
    info "These are packages you explicitly installed (not dependencies)"
else
    success "No leaf packages found"
fi

echo ""
info "Checking for unused dependencies..."
AUTOREMOVE_OUTPUT=$(brew autoremove --dry-run 2>&1 || echo "")

if echo "$AUTOREMOVE_OUTPUT" | grep -q "would uninstall"; then
    warning "Found packages that can be removed:"
    echo "$AUTOREMOVE_OUTPUT" | grep "would uninstall" | sed 's/^/  /'
    echo ""
    ask "Remove these unused dependencies? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        brew autoremove
        success "Unused dependencies removed"
    else
        info "Skipping autoremove"
    fi
else
    success "No unused dependencies found"
fi

#==============================================================================
# Outdated Packages
#==============================================================================
section "Outdated Packages"

info "Checking for outdated packages..."
OUTDATED=$(brew outdated)

if [ -n "$OUTDATED" ]; then
    echo ""
    warning "Outdated packages found:"
    echo "$OUTDATED" | awk '{print "  • " $0}'
    echo ""
    ask "Update all outdated packages? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        brew upgrade
        success "All packages updated"
    else
        info "Skipping updates. You can run 'brew upgrade' manually later."
    fi
else
    success "All packages are up to date"
fi

#==============================================================================
# Brewfile Cleanup
#==============================================================================
section "Brewfile Cleanup"

# Detect DOTFILES_DIR dynamically
DOTFILES_DIR="${DOTFILES_DIR:-}"
if [ -z "$DOTFILES_DIR" ]; then
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -L)"
fi

# Check for split Brewfiles (Brewfile.core + Brewfile.desktop)
BREWFILE_CORE="${DOTFILES_DIR}/homebrew/Brewfile.core"
BREWFILE_DESKTOP="${DOTFILES_DIR}/homebrew/Brewfile.desktop"
BREWFILE_LEGACY="${DOTFILES_DIR}/homebrew/Brewfile"
BREWFILE_COMBINED="/tmp/Brewfile.combined"

# Determine which Brewfile(s) to use
if [ -f "$BREWFILE_CORE" ] && [ -f "$BREWFILE_DESKTOP" ]; then
    # Split Brewfiles: concatenate them
    cat "$BREWFILE_CORE" "$BREWFILE_DESKTOP" > "$BREWFILE_COMBINED"
    BREWFILE="$BREWFILE_COMBINED"
    BREWFILE_DIR="${DOTFILES_DIR}/homebrew"
elif [ -f "$BREWFILE_LEGACY" ]; then
    # Legacy single Brewfile
    BREWFILE="$BREWFILE_LEGACY"
    BREWFILE_DIR="$(dirname "$BREWFILE")"
else
    BREWFILE=""
    BREWFILE_DIR=""
fi

if [ -n "$BREWFILE" ] && [ -f "$BREWFILE" ]; then
    success "Found Brewfile at: $BREWFILE"
    echo ""
    info "Checking for packages not listed in Brewfile..."

    # Run brew bundle cleanup in dry-run mode
    CLEANUP_OUTPUT=$(cd "$BREWFILE_DIR" && brew bundle cleanup --file="$BREWFILE" --force --dry-run 2>&1 || echo "")

    if echo "$CLEANUP_OUTPUT" | grep -q "Would uninstall"; then
        warning "Packages not in Brewfile (would be uninstalled):"
        echo "$CLEANUP_OUTPUT" | grep "Would uninstall" | sed 's/^/  /'
        echo ""
        warning "These packages are installed but not in your Brewfile"
        ask "Do you want to see the full list? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            cd "$BREWFILE_DIR" && brew bundle cleanup --file="$BREWFILE" --force
        else
            info "Run 'cd $BREWFILE_DIR && brew bundle cleanup --file=\"$BREWFILE\"' to review later"
        fi
    else
        success "All installed packages are in your Brewfile"
    fi
    
    # Clean up temporary combined Brewfile if it was created
    if [ "$BREWFILE" = "$BREWFILE_COMBINED" ] && [ -f "$BREWFILE_COMBINED" ]; then
        rm "$BREWFILE_COMBINED"
    fi
else
    warning "Brewfile not found"
    info "Expected locations:"
    info "  - Split: $BREWFILE_CORE + $BREWFILE_DESKTOP"
    info "  - Legacy: $BREWFILE_LEGACY"
    info "Create a Brewfile to track your packages: brew bundle dump"
fi

#==============================================================================
# Cache Cleanup
#==============================================================================
section "Cache Cleanup"

info "Homebrew cache cleanup..."
CACHE_SIZE_BEFORE=$(du -sh "$(brew --cache)" 2>/dev/null | awk '{print $1}' || echo "0B")
info "Cache size before cleanup: $CACHE_SIZE_BEFORE"

ask "Clean Homebrew cache? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    brew cleanup -s
    brew cleanup --prune=all
    CACHE_SIZE_AFTER=$(du -sh "$(brew --cache)" 2>/dev/null | awk '{print $1}' || echo "0B")
    success "Cache cleaned! New size: $CACHE_SIZE_AFTER"
else
    info "Skipping cache cleanup"
fi

echo ""
info "Other cache locations you can manually clean:"
echo "  • ~/Library/Caches - User application caches"
echo "  • ~/Library/Developer/Xcode/DerivedData - Xcode build cache"
echo "  • ~/Library/Logs - Log files"
echo "  • ~/.Trash - Trash bin"
echo ""

#==============================================================================
# Old Versions Cleanup
#==============================================================================
section "Old Versions Cleanup"

info "Checking for old versions of installed packages..."
OLD_VERSIONS=$(brew cleanup -n 2>&1 | grep "Would remove:" || echo "")

if [ -n "$OLD_VERSIONS" ]; then
    warning "Found old versions:"
    echo "$OLD_VERSIONS" | sed 's/^/  /'
    echo ""
    ask "Remove old versions? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        brew cleanup
        success "Old versions removed"
    else
        info "Skipping old version cleanup"
    fi
else
    success "No old versions to clean up"
fi

#==============================================================================
# Diagnostic Check
#==============================================================================
section "Homebrew Diagnostic"

info "Running 'brew doctor' to check for issues..."
echo ""

DOCTOR_OUTPUT=$(brew doctor 2>&1 || echo "Issues found")

if echo "$DOCTOR_OUTPUT" | grep -q "Your system is ready to brew"; then
    success "Your system is ready to brew!"
else
    warning "Brew doctor found some issues:"
    echo "$DOCTOR_OUTPUT"
    echo ""
    info "Review the issues above and fix them if needed"
fi

#==============================================================================
# Mac App Store Cleanup (if mas is installed)
#==============================================================================
section "Mac App Store Applications"

if command -v mas &> /dev/null; then
    success "mas (Mac App Store CLI) is installed"
    echo ""
    info "Installed Mac App Store applications:"
    mas list | awk '{print "  • " $0}'
    echo ""
    info "You can uninstall apps with: mas uninstall <app_id>"
    info "To find outdated apps: mas outdated"
else
    warning "mas (Mac App Store CLI) not installed"
    info "Install with: brew install mas"
    info "Then you can manage Mac App Store apps from the command line"
fi

#==============================================================================
# Summary
#==============================================================================
section "Cleanup Summary"

info "Disk space after cleanup:"
df -h / | tail -n 1 | awk '{print "  Total: " $2 " | Used: " $3 " (" $5 ") | Available: " $4}'

echo ""
success "Cleanup complete!"
echo ""
info "Additional manual cleanup options:"
echo "  • Review and remove old files from ~/Downloads"
echo "  • Empty Trash: rm -rf ~/.Trash/*"
echo "  • Clean Xcode: rm -rf ~/Library/Developer/Xcode/DerivedData"
echo "  • Clean Docker: docker system prune -a"
echo "  • Clean npm: npm cache clean --force"
echo "  • Clean pip: pip cache purge"
echo ""
info "Recommended maintenance:"
echo "  • Run this script monthly"
echo "  • Keep your Brewfile updated: cd $DOTFILES_DIR/homebrew && brew bundle dump --force"
echo "  • Regular system updates: softwareupdate -l"
echo ""
