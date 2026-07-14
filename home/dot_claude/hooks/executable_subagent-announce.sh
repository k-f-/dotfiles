#!/usr/bin/env bash
# Emits a systemMessage marker when subagents start or stop, so the user
# can see who is currently working. Mode is passed as $1: "start" or "stop".
#
# JSON shape on stdin is not fully documented; we try several likely field
# paths and fall back to "unknown". Raw stdin is appended to a debug log
# so the field path can be confirmed empirically on first run.
set -euo pipefail

MODE="${1:-unknown}"
DEBUG_LOG="${HOME}/.claude/hooks/subagent-announce.debug.log"
PAYLOAD=$(cat)

# Append raw payload for one-time field-path confirmation.
{
  printf '\n=== %s mode=%s ===\n' "$(date -u +%FT%TZ)" "$MODE"
  printf '%s\n' "$PAYLOAD"
} >> "$DEBUG_LOG" 2>/dev/null || true

extract_name() {
  # Try the most likely paths in order. Stop at the first non-empty value.
  printf '%s' "$PAYLOAD" | jq -r '
    .tool_input.subagent_type //
    .tool_input.agent_type //
    .subagent_type //
    .agent_type //
    .agent_name //
    "unknown"
  ' 2>/dev/null || printf 'unknown'
}

NAME=$(extract_name)

case "$MODE" in
  start) MSG="▶ ${NAME}" ;;
  stop)  MSG="◀ ${NAME}" ;;
  *)     MSG="• ${MODE} ${NAME}" ;;
esac

# Emit systemMessage as JSON. jq -n -c keeps it on one line and safely escapes.
jq -n -c --arg msg "$MSG" '{systemMessage: $msg}'
