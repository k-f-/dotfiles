#!/usr/bin/env bash
#
# Brew Audit Script
# Bidirectional sync between installed packages and Brewfiles
#
# Usage: ./scripts/brew-audit.sh [--dry-run] [--help]

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

format_message() {
    if [[ "${DRY_RUN}" == "true" ]]; then
        printf '[DRY RUN] %s' "$1"
    else
        printf '%s' "$1"
    fi
}

print_header() { echo -e "\n${BLUE}==>${NC} $(format_message "$1")"; }
print_success() { echo -e "${GREEN}✓${NC} $(format_message "$1")"; }
print_warning() { echo -e "${YELLOW}!${NC} $(format_message "$1")"; }
print_error() { echo -e "${RED}✗${NC} $(format_message "$1")" >&2; }
print_info() { echo -e "${BLUE}ℹ${NC} $(format_message "$1")"; }

DRY_RUN=false
DOTFILES_DIR=""
BREWFILE_CORE=""
BREWFILE_DESKTOP=""

added_taps=0
added_formulas=0
added_casks=0
added_mas=0
removed_taps=0
removed_formulas=0
removed_casks=0
removed_mas=0

usage() {
    cat <<'EOF'
Usage: ./scripts/brew-audit.sh [OPTIONS]

Bidirectional sync between installed Homebrew packages and split Brewfiles
(homebrew/Brewfile.core and homebrew/Brewfile.desktop).

OPTIONS:
  --dry-run   Show what would change without modifying files
  --help      Show this help message

Checks:
  - Taps:     brew tap  vs  tap "name" entries in Brewfiles
  - Formulas: brew leaves  vs  brew "name" entries in Brewfiles
  - Casks:    brew list --cask  vs  cask "name" entries in Brewfiles
  - MAS:      mas list  vs  mas "Name", id: XXXXX entries in Brewfiles

Direction 1: Untracked installs (installed but not in Brewfiles)
Direction 2: Stale entries (in Brewfiles but not installed)

Interactive prompts will ask to add or remove entries. If changes are made,
the script can optionally commit them locally (no push).
EOF
}

log_dry_run() {
    print_info "$1"
}

command_exists() { command -v "$1" &>/dev/null; }

ensure_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        print_error "This script only runs on macOS (Darwin)."
        exit 1
    fi
}

detect_dotfiles_dir() {
    DOTFILES_DIR="${DOTFILES_DIR:-}"
    if [[ -z "${DOTFILES_DIR}" ]]; then
        DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -L)"
    fi
}

check_brewfiles() {
    BREWFILE_CORE="${DOTFILES_DIR}/homebrew/Brewfile.core"
    BREWFILE_DESKTOP="${DOTFILES_DIR}/homebrew/Brewfile.desktop"

    if [[ ! -f "${BREWFILE_CORE}" ]] || [[ ! -f "${BREWFILE_DESKTOP}" ]]; then
        print_error "Missing Brewfiles:"
        [[ ! -f "${BREWFILE_CORE}" ]] && print_error "- ${BREWFILE_CORE}"
        [[ ! -f "${BREWFILE_DESKTOP}" ]] && print_error "- ${BREWFILE_DESKTOP}"
        exit 1
    fi
}

read_confirm() {
    local prompt="$1"
    local response
    read -r -p "${prompt} " response
    if [[ "${response}" =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

choose_brewfile() {
    local response
    while true; do
        read -r -p "Add to (c)ore or (d)esktop? " response
        case "${response}" in
            c|C)
                echo "${BREWFILE_CORE}"
                return 0
                ;;
            d|D)
                echo "${BREWFILE_DESKTOP}"
                return 0
                ;;
            *)
                print_warning "Please choose 'c' or 'd'."
                ;;
        esac
    done
}

append_after_last_type() {
    local file="$1"
    local type="$2"
    local line="$3"
    local last_line

    last_line=$(grep -n "^${type} " "${file}" | tail -1 | cut -d: -f1 || true)

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_dry_run "Would append to ${file}: ${line}"
        return 0
    fi

    if [[ -z "${last_line}" ]]; then
        printf '\n%s\n' "${line}" >> "${file}"
    else
        sed -i '' "${last_line}a\\
${line}
" "${file}"
    fi
}

remove_line_from_file() {
    local file="$1"
    local pattern="$2"

    if [[ "${DRY_RUN}" == "true" ]]; then
        log_dry_run "Would remove from ${file}: ${pattern}"
        return 0
    fi

    local tmp_file
    tmp_file=$(mktemp)
    grep -v "${pattern}" "${file}" > "${tmp_file}"
    mv "${tmp_file}" "${file}"
}

get_brewfile_entries() {
    local type="$1"
    grep "^${type} " "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}" 2>/dev/null || true
}

get_entry_names() {
    local type="$1"
    get_brewfile_entries "${type}" | sed -E "s/^${type} \"([^\"]+)\".*/\1/" | sort -u
}

get_brewfile_entries_with_file() {
    local type="$1"
    grep -n "^${type} " "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}" 2>/dev/null || true
}

get_installed_taps() {
    brew tap | sort -u
}

get_installed_formulas() {
    brew leaves | sort -u
}

get_installed_casks() {
    brew list --cask | sort -u
}

get_installed_mas() {
    if command_exists mas; then
        mas list | sort -u
    fi
}

get_mas_ids() {
    get_installed_mas | awk '{print $1}' | sort -u
}

get_mas_name_by_id() {
    local id="$1"
    get_installed_mas | awk -v target="${id}" '$1==target { $1=""; sub(/^ /, ""); sub(/ \([^\)]*\)$/, ""); print }'
}

add_tap() {
    local tap="$1"
    if read_confirm "Add ${tap} to Brewfile? (y/N)"; then
        local file
        file=$(choose_brewfile)
        append_after_last_type "${file}" "tap" "tap \"${tap}\""
        added_taps=$((added_taps + 1))
    fi
}

add_formula() {
    local formula="$1"
    if read_confirm "Add ${formula} to Brewfile? (y/N)"; then
        local file
        local desc
        file=$(choose_brewfile)
        desc=$(brew desc "${formula}" 2>/dev/null | head -1 | sed -E "s/^${formula}: //" || true)
        if [[ -n "${desc}" ]]; then
            append_after_last_type "${file}" "brew" "brew \"${formula}\"  # ${desc}"
        else
            append_after_last_type "${file}" "brew" "brew \"${formula}\""
        fi
        added_formulas=$((added_formulas + 1))
    fi
}

add_cask() {
    local cask="$1"
    if read_confirm "Add ${cask} to Brewfile? (y/N)"; then
        local file
        local desc
        file=$(choose_brewfile)
        desc=$(brew desc --cask "${cask}" 2>/dev/null | head -1 | sed -E "s/^${cask}: //" || true)
        if [[ -n "${desc}" ]]; then
            append_after_last_type "${file}" "cask" "cask \"${cask}\"  # ${desc}"
        else
            append_after_last_type "${file}" "cask" "cask \"${cask}\""
        fi
        added_casks=$((added_casks + 1))
    fi
}

add_mas() {
    local id="$1"
    local name
    name=$(get_mas_name_by_id "${id}")
    if [[ -z "${name}" ]]; then
        name="Unknown"
    fi
    if read_confirm "Add ${name} (${id}) to Brewfile? (y/N)"; then
        local file
        file=$(choose_brewfile)
        append_after_last_type "${file}" "mas" "mas \"${name}\", id: ${id}"
        added_mas=$((added_mas + 1))
    fi
}

remove_entry() {
    local type="$1"
    local name="$2"
    local pattern="$3"
    local entry

    while read -r entry; do
        local file
        local line
        file=$(echo "${entry}" | cut -d: -f1)
        line=$(echo "${entry}" | cut -d: -f3-)

        if read_confirm "Remove ${name} from Brewfile? (y/N)"; then
            remove_line_from_file "${file}" "${pattern}"
            case "${type}" in
                tap) removed_taps=$((removed_taps + 1)) ;;
                brew) removed_formulas=$((removed_formulas + 1)) ;;
                cask) removed_casks=$((removed_casks + 1)) ;;
                mas) removed_mas=$((removed_mas + 1)) ;;
            esac
        fi
    done < <(get_brewfile_entries_with_file "${type}" | grep "${pattern}" || true)
}

check_taps() {
    print_header "Taps"
    local installed
    local tracked
    installed=$(get_installed_taps || true)
    tracked=$(get_entry_names "tap" || true)

    local untracked
    local stale
    untracked=$(comm -23 <(printf '%s\n' "${installed}") <(printf '%s\n' "${tracked}") || true)
    stale=$(comm -13 <(printf '%s\n' "${installed}") <(printf '%s\n' "${tracked}") || true)

    if [[ -n "${untracked}" ]]; then
        print_info "Untracked taps:"
        while read -r tap; do
            [[ -z "${tap}" ]] && continue
            add_tap "${tap}"
        done < <(printf '%s\n' "${untracked}")
    else
        print_success "No untracked taps"
    fi

    if [[ -n "${stale}" ]]; then
        print_warning "Stale taps in Brewfiles:"
        while read -r tap; do
            [[ -z "${tap}" ]] && continue
            remove_entry "tap" "${tap}" "^tap \"${tap}\""
        done < <(printf '%s\n' "${stale}")
    else
        print_success "No stale tap entries"
    fi
}

check_formulas() {
    print_header "Formulas"
    local installed
    local tracked
    installed=$(get_installed_formulas || true)
    tracked=$(get_entry_names "brew" || true)

    local untracked
    local stale
    untracked=$(comm -23 <(printf '%s\n' "${installed}") <(printf '%s\n' "${tracked}") || true)
    stale=$(comm -13 <(printf '%s\n' "${installed}") <(printf '%s\n' "${tracked}") || true)

    if [[ -n "${untracked}" ]]; then
        print_info "Untracked formulas:"
        while read -r formula; do
            [[ -z "${formula}" ]] && continue
            add_formula "${formula}"
        done < <(printf '%s\n' "${untracked}")
    else
        print_success "No untracked formulas"
    fi

    if [[ -n "${stale}" ]]; then
        print_warning "Stale formulas in Brewfiles:"
        while read -r formula; do
            [[ -z "${formula}" ]] && continue
            remove_entry "brew" "${formula}" "^brew \"${formula}\""
        done < <(printf '%s\n' "${stale}")
    else
        print_success "No stale formula entries"
    fi
}

check_casks() {
    print_header "Casks"
    local installed
    local tracked
    installed=$(get_installed_casks || true)
    tracked=$(get_entry_names "cask" || true)

    local untracked
    local stale
    untracked=$(comm -23 <(printf '%s\n' "${installed}") <(printf '%s\n' "${tracked}") || true)
    stale=$(comm -13 <(printf '%s\n' "${installed}") <(printf '%s\n' "${tracked}") || true)

    if [[ -n "${untracked}" ]]; then
        print_info "Untracked casks:"
        while read -r cask; do
            [[ -z "${cask}" ]] && continue
            add_cask "${cask}"
        done < <(printf '%s\n' "${untracked}")
    else
        print_success "No untracked casks"
    fi

    if [[ -n "${stale}" ]]; then
        print_warning "Stale casks in Brewfiles:"
        while read -r cask; do
            [[ -z "${cask}" ]] && continue
            remove_entry "cask" "${cask}" "^cask \"${cask}\""
        done < <(printf '%s\n' "${stale}")
    else
        print_success "No stale cask entries"
    fi
}

check_mas() {
    print_header "Mac App Store Apps"
    if ! command_exists mas; then
        print_warning "mas is not installed; skipping MAS apps"
        return 0
    fi

    local installed_ids
    local tracked_ids
    installed_ids=$(get_mas_ids || true)
    tracked_ids=$(get_brewfile_entries "mas" | sed -E 's/.*id: ([0-9]+).*/\1/' | sort -u)

    local untracked
    local stale
    untracked=$(comm -23 <(printf '%s\n' "${installed_ids}") <(printf '%s\n' "${tracked_ids}") || true)
    stale=$(comm -13 <(printf '%s\n' "${installed_ids}") <(printf '%s\n' "${tracked_ids}") || true)

    if [[ -n "${untracked}" ]]; then
        print_info "Untracked MAS apps:"
        while read -r mas_id; do
            [[ -z "${mas_id}" ]] && continue
            add_mas "${mas_id}"
        done < <(printf '%s\n' "${untracked}")
    else
        print_success "No untracked MAS apps"
    fi

    if [[ -n "${stale}" ]]; then
        print_warning "Stale MAS entries in Brewfiles:"
        while read -r mas_id; do
            [[ -z "${mas_id}" ]] && continue
            remove_entry "mas" "${mas_id}" "id: ${mas_id}"
        done < <(printf '%s\n' "${stale}")
    else
        print_success "No stale MAS entries"
    fi
}

print_summary() {
    local added_total=$((added_taps + added_formulas + added_casks + added_mas))
    local removed_total=$((removed_taps + removed_formulas + removed_casks + removed_mas))

    print_header "Summary"
    echo "Added: ${added_formulas} formulas, ${added_casks} casks, ${added_taps} taps, ${added_mas} mas apps | Removed: ${removed_total} stale entries"

    if [[ ${added_total} -gt 0 || ${removed_total} -gt 0 ]]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            print_warning "Dry run enabled; no changes were made."
            return 0
        fi

        if read_confirm "Commit these changes? (y/N)"; then
            git add "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}"
            git commit -m "chore(brew): sync Brewfiles with installed packages"
            print_success "Changes committed locally. Run 'git push' to sync remote."
        else
            print_info "Changes were not committed."
        fi
    else
        print_success "No changes needed."
    fi
}

parse_args() {
    for arg in "$@"; do
        case "${arg}" in
            --dry-run)
                DRY_RUN=true
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: ${arg}"
                usage
                exit 1
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    ensure_macos
    detect_dotfiles_dir
    check_brewfiles

    if ! command_exists brew; then
        print_error "Homebrew is required but not installed."
        exit 1
    fi

    check_taps
    check_formulas
    check_casks
    check_mas
    print_summary
}

main "$@"
