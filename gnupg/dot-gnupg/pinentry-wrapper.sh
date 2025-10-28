#!/usr/bin/env bash
#
# Smart pinentry wrapper for GPG
# Automatically chooses the best available pinentry program based on:
# 1. Whether we're in a graphical environment (macOS GUI)
# 2. Whether we're in a terminal (SSH, tmux, screen)
# 3. What pinentry programs are installed

set -euo pipefail

# Detect environment
if [[ -n "${SSH_CONNECTION:-}" ]] || [[ -n "${SSH_CLIENT:-}" ]] || [[ -n "${SSH_TTY:-}" ]]; then
    # SSH session - prefer terminal-based pinentry
    USE_TERMINAL=true
elif [[ -n "${TMUX:-}" ]] || [[ -n "${STY:-}" ]]; then
    # Inside tmux or screen - prefer terminal-based pinentry
    USE_TERMINAL=true
else
    # Regular environment - prefer GUI
    USE_TERMINAL=false
fi

# Function to find pinentry program
find_pinentry() {
    local prefer_terminal="$1"

    # Possible locations for pinentry programs
    local brew_prefix
    brew_prefix="$(brew --prefix 2>/dev/null || echo "/opt/homebrew")"

    if [[ "$prefer_terminal" == "true" ]]; then
        # Prefer terminal-based pinentry
        for path in \
            "$brew_prefix/bin/pinentry-curses" \
            "/usr/local/bin/pinentry-curses" \
            "$brew_prefix/bin/pinentry-tty" \
            "/usr/local/bin/pinentry-tty" \
            "$brew_prefix/bin/pinentry" \
            "/usr/local/bin/pinentry" \
            "$brew_prefix/bin/pinentry-mac" \
            "/usr/local/bin/pinentry-mac"
        do
            if [[ -x "$path" ]]; then
                echo "$path"
                return 0
            fi
        done
    else
        # Prefer GUI pinentry
        for path in \
            "$brew_prefix/bin/pinentry-mac" \
            "/usr/local/bin/pinentry-mac" \
            "/Applications/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac" \
            "$brew_prefix/bin/pinentry" \
            "/usr/local/bin/pinentry" \
            "$brew_prefix/bin/pinentry-curses" \
            "/usr/local/bin/pinentry-curses"
        do
            if [[ -x "$path" ]]; then
                echo "$path"
                return 0
            fi
        done
    fi

    # Fallback: any pinentry we can find
    command -v pinentry-mac || command -v pinentry-curses || command -v pinentry || echo ""
}

# Find and execute the appropriate pinentry
PINENTRY_PROGRAM=$(find_pinentry "$USE_TERMINAL")

if [[ -z "$PINENTRY_PROGRAM" ]]; then
    echo "ERROR: No pinentry program found!" >&2
    echo "Install with: brew install pinentry-mac" >&2
    exit 1
fi

# Execute the chosen pinentry program with all arguments
exec "$PINENTRY_PROGRAM" "$@"
