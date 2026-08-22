#!/usr/bin/env bash
# Claude Code SessionEnd hook → agr archiver (Go, part of the agr binary).
# Receives session_id, transcript_path, cwd on stdin (Claude Code hook contract).
# On failure, leave a breadcrumb: the hook runs async, so a broken archiver
# is otherwise completely silent.
# Rollback to the TS archiver: re-run ~/Documents/Code/agr-plugin/install.sh
#
# After archiving, sweep working docs (build sheets, briefs, memos) the session
# wrote into chats/ — the archiver commits only the transcript it generates,
# so anything else under chats/ is otherwise never committed.
set -uo pipefail

log="${TMPDIR:-/tmp}/agr-plugin-hook-failures.log"

archive_status=0
if ! "$HOME/go/bin/agr" archive claude-hook; then
    archive_status=$?
    echo "$(date '+%Y-%m-%d %H:%M:%S') agr archive claude-hook failed (exit ${archive_status})" >> "$log"
fi

repo="$HOME/Documents/Code/agr"
if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$repo" add -A chats/
    if ! git -C "$repo" diff --cached --quiet; then
        if git -C "$repo" commit -q -m "docs: session working files (auto, $(date '+%Y-%m-%d'))"; then
            # Two machines (MacBook + Mac mini) now commit to this same repo, so
            # pushes race. Rebase onto the remote after committing -- pull --rebase
            # refuses to run with a dirty index, so this must come after commit,
            # not before. Without it a losing race fails silently and the archive
            # never leaves the machine.
            git -C "$repo" pull --rebase -q 2>/dev/null || true
            git -C "$repo" push -q 2>/dev/null \
                || echo "$(date '+%Y-%m-%d %H:%M:%S') working-docs push failed" >> "$log"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') working-docs commit failed" >> "$log"
        fi
    fi
fi

exit "$archive_status"
