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

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() { echo -e "\n${BLUE}==>${NC} ${1}"; }
print_success() { echo -e "${GREEN}✓${NC} ${1}"; }
print_warning() { echo -e "${YELLOW}!${NC} ${1}"; }
print_error() { echo -e "${RED}✗${NC} ${1}" >&2; }

command_exists() { command -v "$1" &>/dev/null; }

check_prerequisites() {
    print_header "Checking prerequisites..."
    local missing=()

    command_exists git   || missing+=("git")
    command_exists node  || missing+=("node (brew install node)")
    command_exists bun   || missing+=("bun (curl -fsSL https://bun.sh/install | bash)")
    command_exists uv    || missing+=("uv (brew install uv)")

    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Missing required tools:"
        for tool in "${missing[@]}"; do
            echo "  - ${tool}"
        done
        return 1
    fi
    print_success "All prerequisites found"
}

ensure_repo() {
    local name="$1"
    local url="$2"
    local dir="${CODE_DIR}/${name}"

    if [[ -d "${dir}/.git" ]]; then
        if [[ "${UPDATE_MODE}" == "true" ]]; then
            print_header "Updating ${name}..."
            (cd "${dir}" && git pull --ff-only 2>/dev/null) \
                || print_warning "${name}: pull skipped (local changes or not on a branch)"
        else
            print_success "${name} already cloned"
        fi
    else
        print_header "Cloning ${name}..."
        git clone "${url}" "${dir}"
        print_success "Cloned ${name}"
    fi
}

setup_agr_mcp() {
    print_header "Setting up agr-mcp (Python/uv)..."
    ensure_repo "agr-mcp" "git@github.com:k-f-/agr-mcp.git"

    if (cd "${CODE_DIR}/agr-mcp" && uv sync 2>&1); then
        print_success "agr-mcp dependencies installed"
    else
        print_warning "agr-mcp: uv sync failed (check pyproject.toml)"
    fi
}

setup_agr_plugin() {
    print_header "Setting up agr-opencode-plugin (TypeScript/bun)..."
    ensure_repo "agr-opencode-plugin" "git@github.com:k-f-/agr-opencode-plugin.git"

    local dir="${CODE_DIR}/agr-opencode-plugin"
    if (cd "${dir}" && bun install && bun run build 2>&1); then
        print_success "agr-opencode-plugin built"
    else
        print_warning "agr-opencode-plugin: build failed (check package.json)"
    fi
}

setup_agentic_standards() {
    print_header "Setting up agentic-dev-standards MCP server..."

    local dir="${CODE_DIR}/agentic-dev-standards"
    if [[ ! -d "${dir}" ]]; then
        print_warning "agentic-dev-standards not found at ${dir}"
        print_warning "Run 'git submodule update --init' from the dotfiles repo first"
        return 0
    fi

    if (cd "${dir}" && npm install --production 2>&1); then
        print_success "agentic-dev-standards dependencies installed"
    else
        print_warning "agentic-dev-standards: npm install failed"
    fi
}

setup_opencode_plugins() {
    print_header "Installing opencode plugin dependencies..."

    if [[ ! -f "${OPENCODE_CONFIG}/package.json" ]]; then
        print_warning "opencode config not found at ${OPENCODE_CONFIG}"
        print_warning "Run the dotfiles installer first to stow opencode config"
        return 0
    fi

    if (cd "${OPENCODE_CONFIG}" && bun install --frozen-lockfile 2>/dev/null || bun install); then
        print_success "opencode plugin dependencies installed"
    else
        print_warning "opencode plugin install failed"
    fi
}

setup_agr_archive() {
    print_header "Ensuring AGR archive directory..."

    local agr_dir="${CODE_DIR}/agr"
    if [[ -d "${agr_dir}" ]]; then
        print_success "AGR archive directory exists"
    else
        mkdir -p "${agr_dir}"
        print_success "Created AGR archive directory at ${agr_dir}"
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
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    cat << "EOF"
╔═══════════════════════════════════════╗
║   OpenCode Ecosystem Bootstrap        ║
╚═══════════════════════════════════════╝
EOF

    if [[ "${UPDATE_MODE}" == "true" ]]; then
        print_warning "UPDATE MODE — pulling latest for existing repos"
    fi

    mkdir -p "${CODE_DIR}"

    check_prerequisites || exit 1

    setup_agr_archive
    setup_agr_mcp
    setup_agr_plugin
    setup_agentic_standards
    setup_opencode_plugins

    echo ""
    print_success "OpenCode ecosystem bootstrap complete!"
    echo ""
    echo "  agr-mcp            ${CODE_DIR}/agr-mcp"
    echo "  agr-opencode-plugin ${CODE_DIR}/agr-opencode-plugin"
    echo "  agentic-dev-standards ${CODE_DIR}/agentic-dev-standards"
    echo "  opencode plugins    ${OPENCODE_CONFIG}"
    echo "  AGR archive         ${CODE_DIR}/agr"
}

main "$@"
