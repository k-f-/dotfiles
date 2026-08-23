#!/usr/bin/env bash
# SessionStart hook: if this Thread has an SME document, say so.
#
# An SME document is the source of truth for its folder -- fitness-build-sheet
# says outright "update this doc, not the scattered chats". A session that does
# not know it exists writes findings into a transcript nobody reads again.
#
# Only fires for Threads. AGR_FOLDER unset means an ad-hoc session, which is
# left alone.
set -uo pipefail

[ -n "${AGR_FOLDER:-}" ] || exit 0

root="${AGR_DIR:-$HOME/Documents/Code/agr}"
dir="$root/$AGR_FOLDER"
[ -d "$dir" ] || exit 0

# One SME document per folder, by convention. First match wins.
doc=""
for f in "$dir"/*.md; do
    [ -f "$f" ] || continue
    if head -20 "$f" | grep -q '^type: sme$'; then doc="$f"; break; fi
done
[ -n "$doc" ] || exit 0

cat <<EOF
This session is working in the agr folder $AGR_FOLDER.

Its subject-matter document is $doc. Read it before answering, and update it
with anything durable you learn -- targets, decisions, corrections, dates.
It is the source of truth for this topic; the transcript is not.
EOF
