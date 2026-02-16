#!/usr/bin/env bash
#
# Validate Stow Configuration
# Checks that all dotfile symlinks are correctly pointing from HOME to the dotfiles repo
# and that no stray symlinks exist in the repo's parent directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
REPO_PARENT="$(cd "${DOTFILES_DIR}/.." && pwd)"

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/output.sh"

section "Validation"
out_verbose "Dotfiles: ${DOTFILES_DIR}"
out_verbose "Home: ${HOME}"

out_verbose "Checking for stray symlinks in ${REPO_PARENT}..."
stray_items=$(cd "${REPO_PARENT}" && find . -maxdepth 1 \( -type l -o -name "dot-*" -o -name ".bash*" -o -name ".bin" -o -name ".profile" -o -name ".zsh*" \) 2>/dev/null | grep -v "^./dotfiles" || true)

if [[ -n "${stray_items}" ]]; then
    fail "Found stray dotfile items in ${REPO_PARENT}:"
    echo "${stray_items}"
    out_detail "These should NOT exist. Run the following to clean up:"
    out_detail "  cd ${REPO_PARENT}"
    for item in ${stray_items}; do
        item_name=$(basename "${item}")
        out_detail "  rm -rf ${item_name}"
    done
else
    tick
fi

out_verbose "Checking HOME directory symlinks..."
home_symlinks=$(find "${HOME}" -maxdepth 1 -type l 2>/dev/null | xargs ls -ld 2>/dev/null | grep "${DOTFILES_DIR}" || true)

if [[ -n "${home_symlinks}" ]]; then
    while IFS= read -r line; do
        symlink=$(echo "${line}" | awk '{print $9}')
        target=$(readlink "${symlink}")

        if [[ "${target}" == /* ]]; then
            out_warning "${symlink} uses absolute path: ${target}"
            out_detail "Consider: Relative paths are more portable"
        fi
    done <<< "${home_symlinks}"

    tick
else
    out_warning "No dotfile symlinks found in HOME"
fi

out_verbose "Checking .config directory..."
config_symlinks=$(find "${HOME}/.config" -maxdepth 2 -type l 2>/dev/null | xargs ls -ld 2>/dev/null | grep "dotfiles" || true)

if [[ -n "${config_symlinks}" ]]; then
    tick
else
    out_verbose "No dotfile symlinks in .config (this may be normal)"
fi

out_verbose "Checking critical dotfiles..."
critical_files=(".bashrc" ".zshrc" ".vimrc" ".gitconfig")
critical_pass=0
for file in "${critical_files[@]}"; do
    if [[ -L "${HOME}/${file}" ]]; then
        target=$(readlink "${HOME}/${file}")
        if [[ "${target}" == *"dotfiles"* ]]; then
            tick
            ((critical_pass++))
        else
            fail "${file} exists but points elsewhere: ${target}"
        fi
    elif [[ -f "${HOME}/${file}" ]]; then
        fail "${file} exists but is NOT a symlink"
    else
        fail "${file} not found"
    fi
done

section_end "${critical_pass}/${#critical_files[@]} critical files ✓"

if [[ $_TOTAL_FAILURES -eq 0 ]]; then
    final_summary
    exit 0
else
    out_error "To fix stow issues, run:"
    out_detail "cd ${DOTFILES_DIR}"
    out_detail "./install"
    final_summary
    exit 1
fi
