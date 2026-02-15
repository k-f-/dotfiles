# -*- mode: sh -*-

# agr - agentrepo fuzzy finder
# Search and browse AI conversation archives with fzf + rg + bat
#
# Usage:
#   agr              # browse all conversations
#   agr wireguard    # pre-filter by search term
#   agr -c           # browse code sessions only
#   agr -d           # browse discussions only

AGR_DIR="${AGR_DIR:-$HOME/Documents/Code/agr}"

unalias agr 2>/dev/null

agr() {
    if [[ ! -d "$AGR_DIR" ]]; then
        echo "agentrepo not found at $AGR_DIR" >&2
        return 1
    fi

    local scope=""
    local query=""
    local pipe_mode=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--code)  scope="code/"; shift ;;
            -d|--discussions) scope="conversations/"; shift ;;
            -p|--pipe)  pipe_mode=1; shift ;;
            -h|--help)
                echo "agr - agentrepo fuzzy finder"
                echo ""
                echo "Usage: agr [options] [query]"
                echo ""
                echo "Options:"
                echo "  -c, --code          browse code sessions only"
                echo "  -d, --discussions   browse discussions only"
                echo "  -p, --pipe          pipe mode (skip fzf, output path)"
                echo "  -h, --help          show this help"
                echo ""
                echo "Examples:"
                echo "  agr                 browse all conversations"
                echo "  agr wireguard       search for wireguard conversations"
                echo "  agr -c homelab      search code sessions for homelab"
                echo "  agr -p wireguard    pipe mode search"
                return 0
                ;;
            *)  query="$1"; shift ;;
        esac
    done

    local target="${AGR_DIR}/${scope}"
    local selected

    # Auto-detect pipe mode if stdout is not a TTY
    if [[ ! -t 1 ]]; then
        pipe_mode=1
    fi

    if [[ $pipe_mode -eq 1 ]]; then
        # Pipe mode: skip fzf, output first match directly
        if [[ -n "$query" ]]; then
            selected=$(rg -i --files-with-matches --glob "*.md" "$query" "$target" 2>/dev/null |
                grep -v '_templates\|_scripts\|README' |
                head -1)
        else
            selected=$(rg --files --glob "*.md" "$target" 2>/dev/null |
                grep -v '_templates\|_scripts\|README' |
                sort -r |
                head -1)
        fi
    else
        # Interactive mode: use fzf with path shortening
        if [[ -n "$query" ]]; then
            # Content search mode: rg finds matches, fzf fuzzy filters
            selected=$(rg -i --files-with-matches --glob "*.md" "$query" "$target" 2>/dev/null |
                grep -v '_templates\|_scripts\|README' |
                sed "s|^${AGR_DIR}/||" |
                fzf --preview "bat --color=always --style=header,grid --line-range=:100 ${AGR_DIR}/{}" \
                    --preview-window=right:60%:wrap \
                    --header="agr: $query" \
                    --query="" \
                    --bind="enter:become(echo ${AGR_DIR}/{})")
        else
            # Browse mode: list all markdown files
            selected=$(rg --files --glob "*.md" "$target" 2>/dev/null |
                grep -v '_templates\|_scripts\|README' |
                sort -r |
                sed "s|^${AGR_DIR}/||" |
                fzf --preview "bat --color=always --style=header,grid --line-range=:100 ${AGR_DIR}/{}" \
                    --preview-window=right:60%:wrap \
                    --header="agr: browse" \
                    --bind="enter:become(echo ${AGR_DIR}/{})")
        fi
    fi

    if [[ -n "$selected" ]]; then
        echo "$selected"
        return 0
    else
        return 1
    fi
}
