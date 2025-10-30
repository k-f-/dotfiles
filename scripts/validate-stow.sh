#!/usr/bin/env bash
#
# Validate Stow Configuration
# Checks that all dotfile symlinks are correctly pointing from HOME to the dotfiles repo
# and that no stray symlinks exist in the repo's parent directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_PARENT="$(cd "${DOTFILES_DIR}/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

errors=0
warnings=0

echo "Validating stow configuration..."
echo "Dotfiles: ${DOTFILES_DIR}"
echo "Home: ${HOME}"
echo ""

# Check 1: No dotfiles/symlinks should exist in repo parent directory
echo "Checking for stray symlinks in ${REPO_PARENT}..."
stray_items=$(cd "${REPO_PARENT}" && find . -maxdepth 1 \( -type l -o -name "dot-*" -o -name ".bash*" -o -name ".bin" -o -name ".profile" -o -name ".zsh*" \) 2>/dev/null | grep -v "^./dotfiles" || true)

if [[ -n "${stray_items}" ]]; then
    echo -e "${RED}✗ ERROR: Found stray dotfile items in ${REPO_PARENT}:${NC}"
    echo "${stray_items}"
    echo ""
    echo "These should NOT exist. Run the following to clean up:"
    echo "  cd ${REPO_PARENT}"
    for item in ${stray_items}; do
        item_name=$(basename "${item}")
        echo "  rm -rf ${item_name}"
    done
    echo ""
    ((errors++))
else
    echo -e "${GREEN}✓ No stray symlinks in repo parent directory${NC}"
fi

# Check 2: All symlinks in HOME should point to dotfiles repo
echo ""
echo "Checking HOME directory symlinks..."
home_symlinks=$(find "${HOME}" -maxdepth 1 -type l 2>/dev/null | xargs ls -ld 2>/dev/null | grep "Documents/Code/dotfiles" || true)

if [[ -n "${home_symlinks}" ]]; then
    # Validate each symlink uses relative path correctly
    while IFS= read -r line; do
        symlink=$(echo "${line}" | awk '{print $9}')
        target=$(readlink "${symlink}")
        
        # Check if target starts with absolute path (should be relative)
        if [[ "${target}" == /* ]]; then
            echo -e "${YELLOW}⚠ WARNING: ${symlink} uses absolute path: ${target}${NC}"
            echo "  Consider: Relative paths are more portable"
            ((warnings++))
        fi
    done <<< "${home_symlinks}"
    
    echo -e "${GREEN}✓ Found $(echo "${home_symlinks}" | wc -l | tr -d ' ') dotfile symlinks in HOME${NC}"
else
    echo -e "${YELLOW}⚠ WARNING: No dotfile symlinks found in HOME${NC}"
    ((warnings++))
fi

# Check 3: Verify .config directory
echo ""
echo "Checking .config directory..."
config_symlinks=$(find "${HOME}/.config" -maxdepth 2 -type l 2>/dev/null | xargs ls -ld 2>/dev/null | grep "dotfiles" || true)

if [[ -n "${config_symlinks}" ]]; then
    echo -e "${GREEN}✓ Found $(echo "${config_symlinks}" | wc -l | tr -d ' ') symlinks in .config${NC}"
else
    echo -e "${YELLOW}⚠ No dotfile symlinks in .config (this may be normal)${NC}"
fi

# Check 4: Verify common dotfiles exist and are symlinks
echo ""
echo "Checking critical dotfiles..."
critical_files=(".bashrc" ".zshrc" ".vimrc" ".gitconfig")
for file in "${critical_files[@]}"; do
    if [[ -L "${HOME}/${file}" ]]; then
        target=$(readlink "${HOME}/${file}")
        if [[ "${target}" == *"dotfiles"* ]]; then
            echo -e "${GREEN}✓ ${file} → ${target}${NC}"
        else
            echo -e "${YELLOW}⚠ ${file} exists but points elsewhere: ${target}${NC}"
            ((warnings++))
        fi
    elif [[ -f "${HOME}/${file}" ]]; then
        echo -e "${YELLOW}⚠ ${file} exists but is NOT a symlink${NC}"
        ((warnings++))
    else
        echo -e "${YELLOW}⚠ ${file} not found${NC}"
    fi
done

# Summary
echo ""
echo "================================"
if [[ ${errors} -eq 0 ]] && [[ ${warnings} -eq 0 ]]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
elif [[ ${errors} -eq 0 ]]; then
    echo -e "${YELLOW}⚠ ${warnings} warning(s) found${NC}"
    exit 0
else
    echo -e "${RED}✗ ${errors} error(s) and ${warnings} warning(s) found${NC}"
    echo ""
    echo "To fix stow issues, run:"
    echo "  cd ${DOTFILES_DIR}"
    echo "  ./install"
    exit 1
fi
