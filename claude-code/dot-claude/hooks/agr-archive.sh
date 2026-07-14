#!/usr/bin/env bash
# Claude Code SessionEnd hook → agr archiver (Go, part of the agr binary).
# Receives session_id, transcript_path, cwd on stdin (Claude Code hook contract).
# On failure, leave a breadcrumb: the hook runs async, so a broken archiver
# is otherwise completely silent.
# Rollback to the TS archiver: re-run ~/Documents/Code/agr-plugin/install.sh
set -uo pipefail
if ! "$HOME/go/bin/agr" archive claude-hook; then
    status=$?
    echo "$(date '+%Y-%m-%d %H:%M:%S') agr archive claude-hook failed (exit ${status})" >> "${TMPDIR:-/tmp}/agr-plugin-hook-failures.log"
    exit "$status"
fi
