#!/usr/bin/env bash
#
# Brew Audit Script
# Health check + bidirectional sync between installed packages and Brewfiles
#
# Usage: ./scripts/brew-audit.sh [--dry-run] [--help]
#
# Phase 1: Health — deprecated taps, stale refs, deprecated packages,
#                   orphaned kegs, unlinked kegs, third-party tap review
# Phase 2: Sync  — bidirectional comparison of installed vs Brewfiles
# Phase 3: Summary

set -euo pipefail

# Source shared output library
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/output.sh"

# Local helper to prepend [DRY RUN] prefix when needed
format_message() {
    if [[ "${DRY_RUN}" == "true" ]]; then
        printf '[DRY RUN] %s' "$1"
    else
        printf '%s' "$1"
    fi
}

# Wrappers around lib functions that apply format_message
print_header() { out_info "$(format_message "$1")"; }
print_success() { out_success "$(format_message "$1")"; }
print_warning() { out_warning "$(format_message "$1")"; }
print_error() { out_error "$(format_message "$1")"; }
print_info() { out_info "$(format_message "$1")"; }

DRY_RUN=false
DOTFILES_DIR=""
BREWFILE_CORE=""
BREWFILE_DESKTOP=""

# Phase 2 (sync) counters
added_taps=0
added_formulas=0
added_casks=0
added_mas=0
removed_taps=0
removed_formulas=0
removed_casks=0
removed_mas=0

# Phase 1 (health) counters
health_untapped=0
health_uninstalled=0
health_linked=0
health_brewfile_cleaned=0

# Cached data (populated once by cache_brew_data)
BREW_DOCTOR_OUTPUT=""
INSTALLED_FORMULAE_JSON=""
INSTALLED_CASK_JSON=""
TAPPED_LIST=""

usage() {
    cat <<'EOF'
Usage: ./scripts/brew-audit.sh [OPTIONS]

Health check and bidirectional sync between installed Homebrew packages
and split Brewfiles (homebrew/Brewfile.core and homebrew/Brewfile.desktop).

OPTIONS:
  --dry-run   Show what would change without modifying files
  --help      Show this help message

Phase 1 — Health Check:
  - Deprecated official taps (built-in since Homebrew 4.x)
  - Third-party tap review (flag taps with no installed packages)
  - Stale Brewfile references (entries pointing to missing taps)
  - Deprecated/disabled formulae and casks
  - Orphaned kegs (installed but formula deleted upstream)
  - Unlinked kegs

Phase 2 — Bidirectional Sync:
  - Taps:     brew tap  vs  tap "name" entries in Brewfiles
  - Formulas: brew leaves  vs  brew "name" entries in Brewfiles
  - Casks:    brew list --cask  vs  cask "name" entries in Brewfiles
  - MAS:      mas list  vs  mas "Name", id: XXXXX entries in Brewfiles

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
    local response=""
    (true < /dev/tty) 2>/dev/null || return 1
    read -r -p "${prompt} " response < /dev/tty
    [[ "${response}" =~ ^[Yy]$ ]]
}

choose_brewfile() {
    local response
    while true; do
        read -r -p "Add to (c)ore or (d)esktop? " response < /dev/tty
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
        log_dry_run "Would remove from $(basename "${file}"): ${pattern}"
        return 0
    fi

    local tmp_file
    tmp_file=$(mktemp)
    grep -v "${pattern}" "${file}" > "${tmp_file}" || true
    mv "${tmp_file}" "${file}"
}

get_brewfile_entries() {
    local type="$1"
    grep -h "^${type} " "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}" 2>/dev/null || true
}

get_entry_names() {
    local type="$1"
    get_brewfile_entries "${type}" | sed -E "s/^${type} \"([^\"]+)\".*/\1/" | sort -u
}

get_brewfile_entries_with_file() {
    local type="$1"
    grep -n "^${type} " "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}" 2>/dev/null || true
}

remove_from_brewfiles() {
    local type="$1"
    local name="$2"
    local pattern="^${type} \"${name}\""

    for file in "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}"; do
        if grep -q "${pattern}" "${file}" 2>/dev/null; then
            remove_line_from_file "${file}" "${pattern}"
            print_info "  Removed ${type} \"${name}\" from $(basename "${file}")"
            health_brewfile_cleaned=$((health_brewfile_cleaned + 1))
        fi
    done
}

# =============================================================================
# Phase 1: Health — Data Gathering
# =============================================================================

# Extract indented items from a brew doctor warning block.
# Finds the first line matching $marker, then collects all subsequent lines
# that start with exactly 2 spaces (the item format brew doctor uses).
extract_doctor_items() {
    local marker="$1"
    local found=false
    local collecting=false

    while IFS= read -r line; do
        if [[ "${found}" == false && "${line}" == *"${marker}"* ]]; then
            found=true
            continue
        fi
        if [[ "${found}" == true ]]; then
            if [[ "${line}" =~ ^\ \ [^\ ] ]]; then
                echo "${line#  }"
                collecting=true
            elif [[ "${collecting}" == true ]]; then
                break
            fi
        fi
    done <<< "${BREW_DOCTOR_OUTPUT}"
}

cache_brew_data() {
    echo -e "\n${_BOLD}Gathering Homebrew data...${_NC}"

    BREW_DOCTOR_OUTPUT=$(brew doctor 2>&1 || true)
    INSTALLED_FORMULAE_JSON=$(brew info --json=v2 --installed 2>/dev/null || true)
    TAPPED_LIST=$(brew tap 2>/dev/null || true)

    # Batch-fetch cask info (only if casks are installed)
    local cask_list
    cask_list=$(brew list --cask 2>/dev/null | tr '\n' ' ' || true)
    if [[ -n "${cask_list}" ]]; then
        # shellcheck disable=SC2086
        INSTALLED_CASK_JSON=$(brew info --json=v2 --cask ${cask_list} 2>/dev/null || true)
    fi
}

# =============================================================================
# Phase 1: Health Checks
# =============================================================================

check_deprecated_official_taps() {
    print_header "Deprecated Official Taps"
    local found=false

    while read -r tap; do
        [[ -z "${tap}" ]] && continue
        case "${tap}" in
            homebrew/*)
                found=true
                print_warning "${tap} (built-in since Homebrew 4.x)"
                if read_confirm "  Untap? (y/N)"; then
                    if [[ "${DRY_RUN}" == "true" ]]; then
                        log_dry_run "Would untap ${tap}"
                    else
                        brew untap "${tap}" 2>/dev/null || true
                    fi
                    health_untapped=$((health_untapped + 1))
                fi
                ;;
        esac
    done <<< "${TAPPED_LIST}"

    if [[ "${found}" == false ]]; then
        print_success "No deprecated official taps"
    fi
}

check_third_party_taps() {
    print_header "Third-Party Taps"
    local third_party_taps=()

    while read -r tap; do
        [[ -z "${tap}" ]] && continue
        case "${tap}" in
            homebrew/*) continue ;;
            *) third_party_taps+=("${tap}") ;;
        esac
    done <<< "${TAPPED_LIST}"

    if [[ ${#third_party_taps[@]} -eq 0 ]]; then
        print_success "No third-party taps"
        return 0
    fi

    local installed_formulae
    local installed_casks
    installed_formulae=$(brew list --formula 2>/dev/null | sort -u)
    installed_casks=$(brew list --cask 2>/dev/null | sort -u)

    local tap_json
    tap_json=$(brew tap-info --json "${third_party_taps[@]}" 2>/dev/null || true)

    for tap in "${third_party_taps[@]}"; do
        local tap_formulas tap_casks installed_from_tap

        # Get available formulae/casks from this tap (strip tap prefix to get bare names)
        tap_formulas=$(echo "${tap_json}" | jq -r --arg t "${tap}" \
            '.[] | select(.name == $t) | .formula_names[]? // empty' 2>/dev/null \
            | sed 's|.*/||' || true)
        tap_casks=$(echo "${tap_json}" | jq -r --arg t "${tap}" \
            '.[] | select(.name == $t) | .cask_tokens[]? // empty' 2>/dev/null \
            | sed 's|.*/||' || true)

        installed_from_tap=""

        while read -r f; do
            [[ -z "${f}" ]] && continue
            if echo "${installed_formulae}" | grep -qx "${f}"; then
                installed_from_tap="${installed_from_tap}${f} (formula), "
            fi
        done <<< "${tap_formulas}"

        while read -r c; do
            [[ -z "${c}" ]] && continue
            # Strip version suffixes for matching (aerospace@0.11.2 → aerospace)
            local bare_cask="${c%%@*}"
            if echo "${installed_casks}" | grep -qx "${bare_cask}"; then
                # Deduplicate: only add if not already listed
                if [[ "${installed_from_tap}" != *"${bare_cask}"* ]]; then
                    installed_from_tap="${installed_from_tap}${bare_cask} (cask), "
                fi
            fi
        done <<< "${tap_casks}"

        installed_from_tap="${installed_from_tap%, }"

        if [[ -n "${installed_from_tap}" ]]; then
            print_success "${tap}: ${installed_from_tap}"
        else
            print_warning "${tap}: no installed packages"
            if read_confirm "  Untap ${tap}? (y/N)"; then
                remove_from_brewfiles "tap" "${tap}"
                if [[ "${DRY_RUN}" == "true" ]]; then
                    log_dry_run "Would untap ${tap}"
                else
                    brew untap "${tap}" 2>/dev/null || true
                fi
                health_untapped=$((health_untapped + 1))
            fi
        fi
    done
}

check_stale_brewfile_refs() {
    print_header "Stale Brewfile References"
    local found=false

    # Find brew entries with tap prefix (format: org/repo/formula)
    local entries
    entries=$(grep -h '^brew "' "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}" 2>/dev/null \
        | sed -E 's/^brew "([^"]+)".*/\1/' \
        | grep '/' || true)

    while read -r entry; do
        [[ -z "${entry}" ]] && continue
        # Extract tap from org/repo/formula format (first two path segments)
        local tap
        tap=$(echo "${entry}" | sed -E 's|^([^/]+/[^/]+)/.*|\1|')

        if ! echo "${TAPPED_LIST}" | grep -qix "${tap}"; then
            found=true
            print_warning "brew \"${entry}\" — tap ${tap} not found"
            if read_confirm "  Remove from Brewfile? (y/N)"; then
                remove_from_brewfiles "brew" "${entry}"
            fi
        fi
    done <<< "${entries}"

    if [[ "${found}" == false ]]; then
        print_success "No stale references"
    fi
}

check_deprecated_formulae() {
    print_header "Deprecated/Disabled Formulae"

    if [[ -z "${INSTALLED_FORMULAE_JSON}" ]]; then
        print_warning "Could not fetch formula data; skipping"
        return 0
    fi

    local issues
    issues=$(echo "${INSTALLED_FORMULAE_JSON}" | jq -r '
        .formulae[]
        | select(.deprecated or .disabled)
        | [
            .name,
            (if .disabled then "disabled" elif .deprecated then "deprecated" else "" end),
            (.deprecation_reason // .disable_reason // ""),
            (.disable_date // .deprecation_date // "")
          ]
        | @tsv
    ' 2>/dev/null || true)

    if [[ -z "${issues}" ]]; then
        print_success "No deprecated or disabled formulae"
        return 0
    fi

    while IFS=$'\t' read -r name status reason date; do
        [[ -z "${name}" ]] && continue

        local detail="${status}"
        [[ -n "${reason}" ]] && detail="${detail}: ${reason}"
        [[ -n "${date}" ]] && detail="${detail}, ${status%d}s ${date}"

        print_warning "${name} (${detail})"

        if read_confirm "  Uninstall? (y/N)"; then
            if [[ "${DRY_RUN}" == "true" ]]; then
                log_dry_run "Would uninstall ${name}"
            else
                brew uninstall "${name}" 2>&1 || print_warning "  Could not uninstall ${name} (may be a dependency)"
            fi
            remove_from_brewfiles "brew" "${name}"
            health_uninstalled=$((health_uninstalled + 1))
        fi
    done <<< "${issues}"
}

check_deprecated_casks() {
    print_header "Deprecated/Disabled Casks"

    if [[ -z "${INSTALLED_CASK_JSON}" ]]; then
        print_success "No cask data to check"
        return 0
    fi

    local issues
    issues=$(echo "${INSTALLED_CASK_JSON}" | jq -r '
        .casks[]
        | select(.deprecated or .disabled)
        | [
            .token,
            (if .disabled then "disabled" elif .deprecated then "deprecated" else "" end),
            (.deprecation_reason // .disable_reason // "")
          ]
        | @tsv
    ' 2>/dev/null || true)

    if [[ -z "${issues}" ]]; then
        print_success "No deprecated or disabled casks"
        return 0
    fi

    while IFS=$'\t' read -r name status reason; do
        [[ -z "${name}" ]] && continue

        local detail="${status}"
        [[ -n "${reason}" ]] && detail="${detail}: ${reason}"

        print_warning "${name} (${detail})"

        if read_confirm "  Uninstall? (y/N)"; then
            if [[ "${DRY_RUN}" == "true" ]]; then
                log_dry_run "Would uninstall --cask ${name}"
            else
                brew uninstall --cask "${name}" 2>&1 || print_warning "  Could not uninstall ${name}"
            fi
            remove_from_brewfiles "cask" "${name}"
            health_uninstalled=$((health_uninstalled + 1))
        fi
    done <<< "${issues}"
}

check_orphaned_kegs() {
    print_header "Orphaned Kegs"

    local orphans
    orphans=$(extract_doctor_items "kegs have no formulae")

    if [[ -z "${orphans}" ]]; then
        print_success "No orphaned kegs"
        return 0
    fi

    while read -r keg; do
        [[ -z "${keg}" ]] && continue
        print_warning "${keg} (installed keg has no formula)"

        if read_confirm "  Uninstall? (y/N)"; then
            if [[ "${DRY_RUN}" == "true" ]]; then
                log_dry_run "Would uninstall ${keg}"
            else
                brew uninstall "${keg}" 2>&1 || print_warning "  Could not uninstall ${keg}"
            fi
            remove_from_brewfiles "brew" "${keg}"
            health_uninstalled=$((health_uninstalled + 1))
        fi
    done <<< "${orphans}"
}

check_unlinked_kegs() {
    print_header "Unlinked Kegs"

    local unlinked
    unlinked=$(extract_doctor_items "unlinked kegs in your Cellar")

    if [[ -z "${unlinked}" ]]; then
        print_success "No unlinked kegs"
        return 0
    fi

    while read -r keg; do
        [[ -z "${keg}" ]] && continue
        print_warning "${keg} (not linked)"

        if read_confirm "  Link? (y/N)"; then
            if [[ "${DRY_RUN}" == "true" ]]; then
                log_dry_run "Would link ${keg}"
            else
                brew link "${keg}" 2>&1 || print_warning "  Could not link ${keg} (try: brew link --overwrite ${keg})"
            fi
            health_linked=$((health_linked + 1))
        fi
    done <<< "${unlinked}"
}

# =============================================================================
# Phase 2: Sync — Installed vs Brewfile
# =============================================================================

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
    done < <(get_brewfile_entries_with_file "${type}" | grep "${pattern#^}" || true)
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
    local installed_leaves
    local installed_all
    local tracked
    installed_leaves=$(brew leaves | sort -u || true)
    installed_all=$(brew list --formula | sort -u || true)
    tracked=$(get_entry_names "brew" || true)

    local untracked
    local stale
    untracked=$(comm -23 <(printf '%s\n' "${installed_leaves}") <(printf '%s\n' "${tracked}") || true)
    stale=$(comm -13 <(printf '%s\n' "${installed_all}") <(printf '%s\n' "${tracked}") || true)

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

# =============================================================================
# Phase 3: Summary
# =============================================================================

print_summary() {
    local sync_added=$((added_taps + added_formulas + added_casks + added_mas))
    local sync_removed=$((removed_taps + removed_formulas + removed_casks + removed_mas))
    local health_total=$((health_untapped + health_uninstalled + health_linked + health_brewfile_cleaned))
    local grand_total=$((sync_added + sync_removed + health_total))

    print_header "Summary"

    if [[ ${health_total} -gt 0 ]]; then
        echo "Health: ${health_untapped} untapped, ${health_uninstalled} uninstalled, ${health_linked} linked, ${health_brewfile_cleaned} Brewfile entries cleaned"
    fi
    echo "Sync:   ${added_formulas} formulas, ${added_casks} casks, ${added_taps} taps, ${added_mas} mas apps added | ${sync_removed} stale entries removed"

    if [[ ${grand_total} -gt 0 ]]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            print_warning "Dry run enabled; no changes were made."
            return 0
        fi

        if read_confirm "Commit Brewfile changes? (y/N)"; then
            git -C "${DOTFILES_DIR}" add "${BREWFILE_CORE}" "${BREWFILE_DESKTOP}"
            git -C "${DOTFILES_DIR}" commit -m "chore(brew): audit — sync Brewfiles and clean up packages"
            print_success "Changes committed locally. Run 'git push' to sync remote."
        else
            print_info "Changes were not committed."
        fi
    else
        print_success "No changes needed."
    fi
}

# =============================================================================
# Entry Point
# =============================================================================

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

    if ! command_exists jq; then
        print_error "jq is required but not installed (brew install jq)."
        exit 1
    fi

    # Gather all data upfront (brew doctor, JSON APIs)
    cache_brew_data

    # Phase 1: Health
    echo -e "\n${_BOLD}=== Phase 1: Health Check ===${_NC}"
    check_deprecated_official_taps
    check_third_party_taps
    check_stale_brewfile_refs
    check_deprecated_formulae
    check_deprecated_casks
    check_orphaned_kegs
    check_unlinked_kegs

    # Phase 2: Sync
    echo -e "\n${_BOLD}=== Phase 2: Brewfile Sync ===${_NC}"
    check_taps
    check_formulas
    check_casks
    check_mas

    # Phase 3: Summary
    print_summary
}

main "$@"
