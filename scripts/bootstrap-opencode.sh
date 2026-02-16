#!/usr/bin/env bash
#
# OpenCode Ecosystem Bootstrap
#
# Clones, installs, and builds all components needed for the opencode
# development environment: MCP servers, plugins, and supporting tools.
#
# Can be run standalone or called from the main dotfiles installer.
#
# Usage: ./scripts/bootstrap-opencode.sh [--update]
#   --update    Pull latest changes for already-cloned repos

set -euo pipefail

# Derive CODE_DIR from DOTFILES_DIR (parent of the dotfiles repo) or env file
if [[ -z "${DOTFILES_DIR:-}" && -f "${HOME}/.config/dotfiles/env" ]]; then
    source "${HOME}/.config/dotfiles/env"
fi
DOTFILES_DIR="${DOTFILES_DIR:?DOTFILES_DIR not set — run ./install first}"
CODE_DIR="$(cd "${DOTFILES_DIR}/.." && pwd)"
OPENCODE_CONFIG="${HOME}/.config/opencode"
UPDATE_MODE=false

# Source shared output library
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/output.sh"

command_exists() { command -v "$1" &>/dev/null; }

check_prerequisites() {
    out_info "Checking prerequisites..."
    local missing=()

    command_exists git   || missing+=("git")
    command_exists node  || missing+=("node (brew install node)")
    command_exists bun   || missing+=("bun (curl -fsSL https://bun.sh/install | bash)")
    command_exists uv    || missing+=("uv (brew install uv)")

    if [[ ${#missing[@]} -gt 0 ]]; then
        out_error "Missing required tools:"
        for tool in "${missing[@]}"; do
            out_detail "$tool"
        done
        return 1
    fi
    tick
}

has_ssh_auth() {
    ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 -o BatchMode=yes -T git@github.com 2>&1 | grep -q "successfully authenticated"
}

ensure_repo() {
    local name="$1"
    local ssh_url="$2"
    local dir="${CODE_DIR}/${name}"

    if [[ -d "${dir}/.git" ]]; then
        if [[ "${UPDATE_MODE}" == "true" ]]; then
            out_info "Updating ${name}..."
            (cd "${dir}" && git pull --ff-only 2>/dev/null) \
                || out_warning "${name}: pull skipped (local changes or not on a branch)"
        else
            tick
        fi
    else
        out_info "Cloning ${name}..."
        if git clone "${ssh_url}" "${dir}" 2>/dev/null; then
            tick
        else
            local https_url="${ssh_url/git@github.com:/https:\/\/github.com\/}"
            out_verbose "SSH failed, trying HTTPS: ${https_url}"
            if git clone "${https_url}" "${dir}" 2>/dev/null; then
                tick
            else
                fail "${name}: clone failed (no SSH key or HTTPS auth)"
                return 1
            fi
        fi
    fi
}

setup_agr_mcp() {
    out_info "Setting up agr-mcp (Python/uv)..."
    ensure_repo "agr-mcp" "git@github.com:k-f-/agr-mcp.git"

    if (cd "${CODE_DIR}/agr-mcp" && uv sync 2>&1); then
        tick
    else
        fail "agr-mcp: uv sync failed (check pyproject.toml)"
    fi
}

setup_agr_plugin() {
    out_info "Setting up agr-opencode-plugin (TypeScript/bun)..."
    ensure_repo "agr-opencode-plugin" "git@github.com:k-f-/agr-opencode-plugin.git"

    local dir="${CODE_DIR}/agr-opencode-plugin"
    if (cd "${dir}" && bun install && bun run build 2>&1); then
        tick
    else
        fail "agr-opencode-plugin: build failed (check package.json)"
    fi
}

setup_agentic_standards() {
    out_info "Setting up agentic-dev-standards MCP server..."

    local dir="${CODE_DIR}/agentic-dev-standards"
    if [[ ! -d "${dir}" ]]; then
        out_warning "agentic-dev-standards not found at ${dir}"
        out_detail "Run 'git submodule update --init' from the dotfiles repo first"
        return 0
    fi

    if (cd "${dir}" && npm install --production 2>&1); then
        tick
    else
        fail "agentic-dev-standards: npm install failed"
    fi
}

setup_opencode_plugins() {
    out_info "Installing opencode plugin dependencies..."

    if [[ ! -f "${OPENCODE_CONFIG}/package.json" ]]; then
        out_warning "opencode config not found at ${OPENCODE_CONFIG}"
        out_detail "Run the dotfiles installer first to stow opencode config"
        return 0
    fi

    if (cd "${OPENCODE_CONFIG}" && bun install --frozen-lockfile 2>/dev/null || bun install); then
        tick
    else
        fail "opencode plugin install failed"
    fi
}

setup_agr_archive() {
    out_info "Ensuring AGR archive directory..."

    local agr_dir="${CODE_DIR}/agr"
    if [[ -d "${agr_dir}" ]]; then
        tick
    else
        mkdir -p "${agr_dir}"
        tick
    fi
}

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --update|-u)
                UPDATE_MODE=true
                shift
                ;;
            --help|-h)
                echo "Usage: $(basename "$0") [--update]"
                echo "  --update    Pull latest changes for already-cloned repos"
                exit 0
                ;;
            *)
                out_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    banner "OpenCode Ecosystem Bootstrap"

    if [[ "${UPDATE_MODE}" == "true" ]]; then
        out_warning "UPDATE MODE — pulling latest for existing repos"
    fi

    mkdir -p "${CODE_DIR}"

    section "Prerequisites"
    check_prerequisites || exit 1
    section_end

    section "Repository Setup"
    setup_agr_archive
    setup_agr_mcp
    setup_agr_plugin
    setup_agentic_standards
    setup_opencode_plugins
    section_end "5 components configured"

    out_success "OpenCode ecosystem bootstrap complete!"
    out_detail "agr-mcp: ${CODE_DIR}/agr-mcp"
    out_detail "agr-opencode-plugin: ${CODE_DIR}/agr-opencode-plugin"
    out_detail "agentic-dev-standards: ${CODE_DIR}/agentic-dev-standards"
    out_detail "opencode plugins: ${OPENCODE_CONFIG}"
    out_detail "AGR archive: ${CODE_DIR}/agr"

    final_summary
}

main "$@"
