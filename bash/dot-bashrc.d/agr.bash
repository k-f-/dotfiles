# -*- mode: sh -*-

# agr - agentrepo fuzzy finder
# Search and browse AI conversation archives with fzf + rg + bat
#
# Usage:
#   agr              # browse all conversations
#   agr wireguard    # pre-filter by search term
#   agr -c           # browse code sessions only
#   agr -d           # browse discussions only

export AGR_DIR="${AGR_DIR:-$HOME/Documents/Code/agr}"

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
            -d|--discussions) scope="chats/"; shift ;;
            -p|--pipe)  pipe_mode=1; shift ;;
            -h|--help)
                echo "agr - agentrepo fuzzy finder"
                echo ""
                echo "Usage: agr [options] [query]"
                echo ""
                echo "Options:"
                echo "  -c, --code          browse code sessions only"
                echo "  -d, --discussions   browse chat sessions only"
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

    # Auto-detect pipe mode if stdout is not a TTY
    if [[ ! -t 1 ]]; then
        pipe_mode=1
    fi

    agr_browse "$scope" "$query" "$pipe_mode"
}

agr_browse() {
    local scope="$1"      # "" for root, "chats/fl5-civic-type-r" for drilled-down
    local query="$2"      # Optional search query
    local pipe_mode="$3"  # 0 or 1

    local target="${AGR_DIR}/${scope}"
    local selected

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

        if [[ -n "$selected" ]]; then
            echo "$selected"
            return 0
        else
            return 1
        fi
    fi

    local folder_list=""
    local file_list=""
    
    if [[ -z "$scope" ]]; then
        # Root view: list all top-level folders with counts
        folder_list=$(
            for top in "$AGR_DIR"/*/; do
                [[ -d "$top" ]] || continue
                top_name=$(basename "$top")
                [[ "$top_name" == .* || "$top_name" == _* ]] && continue
                for folder in "$top"*/; do
                    [[ -d "$folder" ]] || continue
                    count=$(find "$folder" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
                    rel_path=$(echo "$folder" | sed "s|^$AGR_DIR/||;s|/$||")
                    echo "󰉋 $rel_path ($count)"
                done
            done | sort
        )
    else
        # Drilled-down view: show .. to go back
        folder_list=".."
    fi

    if [[ -n "$query" ]]; then
        # Content search mode: rg finds matches, fzf fuzzy filters
        file_list=$(rg -i --files-with-matches --glob "*.md" "$query" "$target" 2>/dev/null |
            grep -v '_templates\|_scripts\|README' |
            sed "s|^${AGR_DIR}/||" |
            sed 's|^\([^/]*\)/\([^/]*\)/\(.*\)|\2 │ \3|')
    else
        # Browse mode: list all markdown files
        file_list=$(rg --files --glob "*.md" "$target" 2>/dev/null |
            grep -v '_templates\|_scripts\|README' |
            sort -r |
            sed "s|^${AGR_DIR}/||" |
            sed 's|^\([^/]*\)/\([^/]*\)/\(.*\)|\2 │ \3|')
    fi

    local combined_list
    if [[ -n "$folder_list" ]]; then
        combined_list=$(printf "%s\n%s" "$folder_list" "$file_list")
    else
        combined_list="$file_list"
    fi

    local fzf_preview='
        if [[ {} == "󰉋 "* ]]; then
            folder=$(echo {} | sed "s/^󰉋 //;s/ (.*//" );
            folder_name=$(basename "$folder");
            top_name=$(echo "$folder" | cut -d/ -f1);
            files=$(find "$AGR_DIR/$folder" -name "*.md" -type f 2>/dev/null | sort);
            file_count=$(echo "$files" | grep -c . 2>/dev/null);
            dates=$(echo "$files" | xargs -I{} awk "/^date:/{gsub(/\047/,\"\"); print \$2; exit}" {} 2>/dev/null | sort);
            oldest=$(echo "$dates" | head -1);
            newest=$(echo "$dates" | tail -1);
            all_tags=$(echo "$files" | xargs -I{} awk "/^tags:/{found=1;next} found && /^- /{gsub(/^- /,\"\"); print} found && !/^- /{exit}" {} 2>/dev/null | sort -u | tr "\n" ", " | sed "s/, $//");
            printf "\033[38;2;255;202;128m󰉋 %s\033[0m" "$folder_name";
            printf " \033[38;2;121;112;169m│\033[0m \033[38;2;149;128;255m󰅩 %s\033[0m" "$top_name";
            printf " \033[38;2;121;112;169m│\033[0m \033[38;2;128;255;234m󰈙 %s files\033[0m" "$file_count";
            if [ -n "$oldest" ]; then
                printf " \033[38;2;121;112;169m│\033[0m \033[38;2;128;255;234m󰃭 %s → %s\033[0m" "$oldest" "$newest";
            fi;
            printf "\n";
            if [ -n "$all_tags" ]; then
                printf "\033[38;2;138;255;128m󰓹 %s\033[0m\n" "$all_tags";
            fi;
            printf "\033[38;2;121;112;169m─%.0s\033[0m" $(seq 1 50); printf "\n";
            total=$(echo "$files" | grep -c .);
            i=0;
            echo "$files" | while IFS= read -r f; do
                [ -z "$f" ] && continue;
                i=$((i + 1));
                fname=$(basename "$f" .md);
                fdate=$(awk "/^date:/{gsub(/\047/,\"\"); print \$2; exit}" "$f" 2>/dev/null);
                ftype=$(awk "/^type:/{print \$2; exit}" "$f" 2>/dev/null);
                if [ "$i" -eq "$total" ]; then branch="└── "; else branch="├── "; fi;
                printf "\033[38;2;121;112;169m%s\033[0m" "$branch";
                printf "\033[38;2;128;255;234m%s\033[0m " "${fdate:-————}";
                case "${ftype:-chat}" in
                    code)
                        printf "\033[38;2;149;128;255m󰅩\033[0m "
                        ;;
                    chat)
                        printf "\033[38;2;255;128;191m󰍩\033[0m "
                        ;;
                    research)
                        printf "\033[38;2;128;255;234m󰍉\033[0m "
                        ;;
                    planning)
                        printf "\033[38;2;255;202;128m󰸕\033[0m "
                        ;;
                    *)
                        printf "\033[38;2;255;128;191m󰍩\033[0m "
                        ;;
                esac
                printf "\033[38;2;248;248;242m%s\033[0m\n" "$fname";
            done;
        elif [[ {} == ".." ]]; then
            echo "← Back to root";
        else
            entry={};
            if [[ "$entry" == *"│"* ]]; then
                folder=$(echo "$entry" | cut -d"│" -f1 | sed "s/ *$//");
                filename=$(echo "$entry" | cut -d"│" -f2 | sed "s/^ *//");
                for top in chats code; do
                    file="$AGR_DIR/$top/$folder/$filename";
                    [[ -f "$file" ]] && break;
                done;
            else
                file="$AGR_DIR/$entry";
            fi;
            date=$(awk "/^date:/{gsub(/\047/,\"\"); print \$2; exit}" "$file" 2>/dev/null);
            type=$(awk "/^type:/{print \$2; exit}" "$file" 2>/dev/null);
            folder=$(dirname "$entry" | sed "s|^[^/]*/||");
            tags=$(awk "/^tags:/{found=1;next} found && /^- /{gsub(/^- /,\"\"); printf \"%s, \",\$0} found && !/^- /{exit}" "$file" 2>/dev/null | sed "s/, $//");
            printf "\033[38;2;128;255;234m󰃭 %s\033[0m \033[38;2;121;112;169m│\033[0m " "${date:-—}";
            case "${type:-chat}" in
                code)
                    printf "\033[38;2;149;128;255m󰅩 %s\033[0m" "${type}"
                    ;;
                chat)
                    printf "\033[38;2;255;128;191m󰍩 %s\033[0m" "${type:-chat}"
                    ;;
                research)
                    printf "\033[38;2;128;255;234m󰍉 %s\033[0m" "${type}"
                    ;;
                planning)
                    printf "\033[38;2;255;202;128m󰸕 %s\033[0m" "${type}"
                    ;;
                *)
                    printf "\033[38;2;255;128;191m󰍩 %s\033[0m" "${type:-chat}"
                    ;;
            esac
            printf " \033[38;2;121;112;169m│\033[0m \033[38;2;255;202;128m󰉋 %s\033[0m" "${folder:-—}";
            printf " \033[38;2;121;112;169m│\033[0m \033[38;2;138;255;128m󰓹 %s\033[0m\n\n" "${tags:-—}";
            bat --color=always --style=grid "$file";
        fi
    '
    local fzf_color="bg:#22212C,fg:#F8F8F2,hl:#9580FF,bg+:#454158,fg+:#F8F8F2,hl+:#9580FF,info:#80FFEA,prompt:#8AFF80,pointer:#FF80BF,marker:#FFCA80,spinner:#9580FF,header:#7970A9,border:#7970A9,gutter:#22212C"
    local fzf_binds='shift-up:preview-up,shift-down:preview-down,shift-left:preview-page-up,shift-right:preview-page-down'

    local result key selection
    while true; do
        if [[ -n "$query" ]]; then
            result=$(echo "$combined_list" | fzf --expect=ctrl-e,ctrl-y,ctrl-o \
                --delimiter='│' \
                --nth=2.. \
                --with-nth=1,2 \
                --color="$fzf_color" \
                --preview "$fzf_preview" \
                --preview-window=right:60% \
                --bind="$fzf_binds" \
                --header="agr: $query | ⏎ read  ^e edit  ^y copy  ^o opencode" \
                --query="")
        else
            result=$(echo "$combined_list" | fzf --expect=ctrl-e,ctrl-y,ctrl-o \
                --delimiter='│' \
                --nth=2.. \
                --with-nth=1,2 \
                --color="$fzf_color" \
                --preview "$fzf_preview" \
                --preview-window=right:60% \
                --bind="$fzf_binds" \
                --header="agr: browse | ⏎ read  ^e edit  ^y copy  ^o opencode")
        fi

        key=$(head -1 <<< "$result")
        selection=$(tail -1 <<< "$result")

        [[ -z "$selection" ]] && return 0
        [[ "$selection" == ".." ]] && return 0

        if [[ "$selection" == "󰉋 "* ]]; then
            folder=$(echo "$selection" | sed 's/^󰉋 //;s/ (.*//')
            folder_name=$(basename "$folder")
            case "$key" in
                "")
                    agr_browse "$folder" "" "$pipe_mode"
                    ;;
                ctrl-y)
                    echo "$AGR_DIR/$folder" | pbcopy
                    echo "Copied to clipboard: $AGR_DIR/$folder"
                    ;;
                ctrl-e)
                    ${EDITOR:-nvim} "$AGR_DIR/$folder"
                    ;;
                ctrl-o)
                    if ! command -v opencode &>/dev/null; then
                        echo "opencode not found in PATH" >&2
                        continue
                    fi
                    file_list=$(find "$AGR_DIR/$folder" -name "*.md" -type f 2>/dev/null | sed "s|^$AGR_DIR/||" | sort)
                    file_count=$(echo "$file_list" | wc -l | tr -d ' ')
                    unique_tags=$(find "$AGR_DIR/$folder" -name "*.md" -exec awk '/^tags:/{found=1;next} found && /^- /{gsub(/^- /,""); print} found && !/^- /{exit}' {} \; 2>/dev/null | sort -u | tr '\n' ',' | sed 's/,$//')
                    opencode --prompt "Read ALL ${file_count} files in the '${folder_name}' project using agr_read, then present a concise summary of the project state: key topics covered, open questions, and where things left off. Tags: ${unique_tags}.

Files:
${file_list}"
                    ;;
            esac
            continue
        fi

        # Reconstruct full path from folder │ filename format
        if [[ "$selection" == *"│"* ]]; then
            folder=$(echo "$selection" | cut -d'│' -f1 | sed 's/ *$//')
            filename=$(echo "$selection" | cut -d'│' -f2 | sed 's/^ *//')
            # Try both chats/ and code/ to find the file
            full_path=""
            for top in chats code; do
                candidate="$AGR_DIR/$top/$folder/$filename"
                if [[ -f "$candidate" ]]; then
                    full_path="$candidate"
                    break
                fi
            done
            # Fallback: if not found, use original selection
            [[ -z "$full_path" ]] && full_path="$AGR_DIR/$selection"
        else
            full_path="$AGR_DIR/$selection"
        fi

        case "$key" in
            "")
                bat --paging=always "$full_path"
                ;;
            ctrl-e)
                ${EDITOR:-nvim} "$full_path"
                ;;
            ctrl-y)
                echo "$full_path" | pbcopy
                echo "Copied to clipboard: $full_path"
                ;;
            ctrl-o)
                if ! command -v opencode &>/dev/null; then
                    echo "opencode not found in PATH" >&2
                    continue
                fi
                # Extract relative path for display
                rel_path=$(echo "$full_path" | sed "s|^$AGR_DIR/||")
                opencode --prompt "Read '${rel_path}' using agr_read and present a summary: what was discussed, key decisions made, and any open threads or next steps."
                ;;
        esac
    done
}
