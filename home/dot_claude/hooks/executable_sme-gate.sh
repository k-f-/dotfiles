#!/usr/bin/env bash
# Stop hook: block once if a Thread finished without updating its SME document.
#
# Stop is one of the events that can block -- exit 2 prevents Claude from
# finishing and forces another turn. That makes this a gate, not a reminder.
#
# It blocks at most once per session. Without that guard a turn that refuses to
# update the document loops forever. One block, then the session ends anyway
# and the miss shows up in the nightly agr-sweep report.
#
# Only Threads are gated. A session with no AGR_FOLDER never sees this.
set -uo pipefail

[ -n "${AGR_FOLDER:-}" ] || exit 0

root="${AGR_DIR:-$HOME/Documents/Code/agr}"
dir="$root/$AGR_FOLDER"
[ -d "$dir" ] || exit 0

doc=""
for f in "$dir"/*.md; do
    [ -f "$f" ] || continue
    if head -20 "$f" | grep -q '^type: sme$'; then doc="$f"; break; fi
done
[ -n "$doc" ] || exit 0

# session_id arrives on stdin in the hook payload; fall back to the pid's
# session so a missing field cannot make this block on every stop.
payload="$(cat 2>/dev/null || true)"
session="$(printf '%s' "$payload" | python3 -c 'import json,sys
try: print(json.load(sys.stdin).get("session_id",""))
except Exception: print("")' 2>/dev/null)"
[ -n "$session" ] || exit 0

state_dir="${TMPDIR:-/tmp}/agr-sme-gate"
mkdir -p "$state_dir" 2>/dev/null || exit 0
blocked="$state_dir/$session.blocked"
[ -f "$blocked" ] && exit 0

# Did this session touch the document? git is the honest check: the working
# tree tells us whether it changed, regardless of who changed it.
if ! git -C "$root" diff --quiet -- "$doc" 2>/dev/null; then exit 0; fi
if ! git -C "$root" diff --cached --quiet -- "$doc" 2>/dev/null; then exit 0; fi

: > "$blocked"
cat >&2 <<EOF
You worked in $AGR_FOLDER but did not update its subject-matter document.

  $doc

Add what is durable from this session -- decisions, corrected facts, new
targets, dates. Then finish. This check does not fire again this session.
EOF
exit 2
