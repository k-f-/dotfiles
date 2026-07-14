#!/bin/bash
# One-time oh-my-zsh bootstrap (zshrc self-clones its custom plugins on first run).
set -euo pipefail

if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    exit 0
fi

# Remove stale/empty directory (e.g. from iCloud sync) so the installer doesn't bail
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    rm -rf "$HOME/.oh-my-zsh"
fi

if ! curl -fsSL --connect-timeout 5 https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh >/dev/null 2>&1; then
    echo "Cannot reach oh-my-zsh installer (offline?); skipping" >&2
    exit 0
fi

ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
