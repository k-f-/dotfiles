#!/usr/bin/env bash
# UserPromptSubmit hook: restate the output-style rules on every turn.
#
# The style file and settings sit far back in a long context, and the model
# conditions on its own recent output -- three essay-shaped replies and the
# fourth copies them. stdout from this event is injected as context the model
# sees, so the rules land next to the prompt instead of far back in context.
#
# Guarded on the active style so it goes quiet if the style changes.
set -uo pipefail

style="$(python3 -c 'import json,os
p=os.path.expanduser("~/.claude/settings.json")
try: print(json.load(open(p)).get("outputStyle",""))
except Exception: print("")' 2>/dev/null)"

[ "$style" = "ELI5" ] || exit 0

cat <<'EOF'
Style rules for this reply (ASD-STE100 Simplified Technical English):
- One idea per sentence. Short sentences. Plain words. Active voice.
- No em-dash asides, no setup lines, no self-talk about your own process.
- Say what you did, whether it worked, and what to do next.
- Decisions: under 5 options, enough context to pick fast, name your pick.
- Keep paths and commands exact.
EOF
