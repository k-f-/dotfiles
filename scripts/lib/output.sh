#!/usr/bin/env bash
# scripts/lib/output.sh — Shared output library for dotfiles scripts
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib/output.sh"  # from root scripts
#   source "${DOTFILES_DIR}/scripts/lib/output.sh"                     # when DOTFILES_DIR set
#
# Section API (compact grouped output):
#   section "Installing packages"   → prints "==> Installing packages..."
#   tick                            → silent success counter
#   fail "pkg: reason"              → failure counter + stores message
#   section_end                     → prints summary: "24 succeeded, 0 failed"
#   section_end "54 installed"      → custom summary text
#
# Direct output (always shown):
#   out_success "message"           → ✓ message
#   out_warning "message"           → ! message
#   out_error "message"             → ✗ message (stderr)
#   out_info "message"              → ℹ message
#   out_verbose "message"           → only if VERBOSE=true
#   out_detail "message"            →     indented dim text

[[ -n "${_OUTPUT_LIB_LOADED:-}" ]] && return 0
_OUTPUT_LIB_LOADED=1

# Colors (skip if not a terminal)
if [[ -t 1 ]]; then
    _RED='\033[0;31m'
    _GREEN='\033[0;32m'
    _YELLOW='\033[1;33m'
    _BLUE='\033[0;34m'
    _DIM='\033[2m'
    _BOLD='\033[1m'
    _NC='\033[0m'
else
    _RED='' _GREEN='' _YELLOW='' _BLUE='' _DIM='' _BOLD='' _NC=''
fi

# Section state
_SECTION_NAME=""
_SECTION_OK=0
_SECTION_FAIL=0
_SECTION_FAILURES=()

# Global failure counter (for final summary)
_TOTAL_FAILURES=0

# ---------------------------------------------------------------------------
# Section tracking
# ---------------------------------------------------------------------------

section() {
    [[ -n "$_SECTION_NAME" ]] && section_end
    _SECTION_NAME="$1"
    _SECTION_OK=0
    _SECTION_FAIL=0
    _SECTION_FAILURES=()
    # Print immediately so the user sees what phase they're in
    echo -ne "${_BLUE}==>${_NC} ${_SECTION_NAME}..."
    # If stdout is a terminal, the cursor stays on the same line;
    # section_end will overwrite with the final summary via \r.
    if [[ -t 1 ]]; then
        _SECTION_INLINE=true
    else
        echo ""   # non-interactive: just newline
        _SECTION_INLINE=false
    fi
}

tick() {
    ((_SECTION_OK++)) || true
}

fail() {
    local msg="${1:-unknown error}"
    ((_SECTION_FAIL++)) || true
    ((_TOTAL_FAILURES++)) || true
    _SECTION_FAILURES+=("$msg")
}

section_end() {
    [[ -z "$_SECTION_NAME" ]] && return

    _stop_spinner

    local custom_summary="${1:-}"
    local line=""

    if [[ -n "$custom_summary" ]]; then
        if [[ $_SECTION_FAIL -eq 0 ]]; then
            line="${_BLUE}==>${_NC} ${_SECTION_NAME}: ${custom_summary}"
        else
            line="${_BLUE}==>${_NC} ${_SECTION_NAME}: ${custom_summary}, ${_RED}${_SECTION_FAIL} failed${_NC}"
        fi
    else
        if [[ $_SECTION_FAIL -eq 0 ]]; then
            line="${_BLUE}==>${_NC} ${_SECTION_NAME}: ${_SECTION_OK} succeeded"
        else
            line="${_BLUE}==>${_NC} ${_SECTION_NAME}: ${_SECTION_OK} succeeded, ${_RED}${_SECTION_FAIL} failed${_NC}"
        fi
    fi

    if [[ "${_SECTION_INLINE:-false}" == "true" ]]; then
        printf '\r\033[K'
    fi
    echo -e "${line}"

    if [[ ${#_SECTION_FAILURES[@]} -gt 0 ]]; then
        for f in "${_SECTION_FAILURES[@]}"; do
            echo -e "    ${_RED}✗${_NC} ${f}"
        done
    fi

    _SECTION_NAME=""
    _SECTION_INLINE=false
}

# ---------------------------------------------------------------------------
# Spinner — animated progress for long-running commands
# ---------------------------------------------------------------------------

_SPINNER_PID=""

_start_spinner() {
    [[ -t 1 ]] || return 0
    local msg="${1:-}"
    (
        local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
        local i=0 elapsed=0
        while true; do
            printf '\r\033[K%b %b %b(%ds)' \
                "${_BLUE}==>${_NC}" "${msg}" "${_DIM}${frames[$i]}${_NC}" "${elapsed}"
            i=$(( (i + 1) % ${#frames[@]} ))
            sleep 0.5
            elapsed=$(( (elapsed * 2 + 1) / 2 ))
            sleep 0.5
            ((elapsed++))
        done
    ) &
    _SPINNER_PID=$!
    disown "$_SPINNER_PID" 2>/dev/null
}

_stop_spinner() {
    if [[ -n "${_SPINNER_PID:-}" ]]; then
        kill "$_SPINNER_PID" 2>/dev/null
        wait "$_SPINNER_PID" 2>/dev/null || true
        _SPINNER_PID=""
        printf '\r\033[K'
    fi
}

# run_with_status "message" command [args...]
#   Runs a command in the background while showing a spinner.
#   Captures stdout+stderr; sets RWS_OUTPUT and returns the command's exit code.
#   The spinner replaces the section's "==>" line and section_end overwrites it.
RWS_OUTPUT=""
run_with_status() {
    local msg="$1"; shift

    local tmpfile
    tmpfile=$(mktemp)

    _start_spinner "${msg}"
    "$@" > "$tmpfile" 2>&1
    local rc=$?
    _stop_spinner

    RWS_OUTPUT=$(<"$tmpfile")
    rm -f "$tmpfile"
    return $rc
}

# ---------------------------------------------------------------------------
# Direct output
# ---------------------------------------------------------------------------

_clear_inline() {
    if [[ "${_SECTION_INLINE:-false}" == "true" ]]; then
        printf '\r\033[K'
        _SECTION_INLINE=false
    fi
}

out_success() { _clear_inline; echo -e "${_GREEN}✓${_NC} $1"; }
out_warning() { _clear_inline; echo -e "${_YELLOW}!${_NC} $1"; }
out_error()   { _clear_inline; echo -e "${_RED}✗${_NC} $1" >&2; }
out_info()    { _clear_inline; echo -e "${_BLUE}ℹ${_NC} $1"; }
out_detail()  { _clear_inline; echo -e "    ${_DIM}$1${_NC}"; }

out_verbose() {
    [[ "${VERBOSE:-false}" == "true" ]] && echo -e "  $1"
    return 0
}

# Aliases (legacy compat — some scripts use print_* naming)
print_success() { out_success "$@"; }
print_warning() { out_warning "$@"; }
print_error()   { out_error "$@"; }
print_info()    { out_info "$@"; }
print_verbose() { out_verbose "$@"; }
print_detail()  { out_detail "$@"; }
print_header()  { echo -e "\n${_BLUE}==>${_NC} ${_BOLD}$1${_NC}"; }

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------

banner() {
    local title="${1:-dotfiles}"
    echo -e "${_BOLD}${title}${_NC}"
}

# ---------------------------------------------------------------------------
# Final summary
# ---------------------------------------------------------------------------

final_summary() {
    echo ""
    if [[ $_TOTAL_FAILURES -eq 0 ]]; then
        echo -e "${_GREEN}✓${_NC} ${_BOLD}Done${_NC} (0 failures)"
    else
        echo -e "${_YELLOW}!${_NC} ${_BOLD}Done${_NC} (${_RED}${_TOTAL_FAILURES} failures${_NC} — review above)"
    fi
}
