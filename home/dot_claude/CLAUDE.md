You have access to the agr conversation archive via MCP tools. Use agr MCP tools to search past conversations when relevant context might exist.

## Artifacts require explicit permission

**Never publish an Artifact without my explicit go-ahead.** This applies to every project, every topic, every time — including republishing or updating an artifact that already exists.

Publishing sends content to Anthropic's servers, and that is my decision to make, not a side effect of you producing a deliverable.

The workflow is: write the HTML or Markdown to a local file, tell me what it contains, and ask whether to publish. If I say no, the local file still stands — read it back with a file tool or send it with SendUserFile.

## Simplicity first

Write the minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No flexibility or configurability that was not requested.
- No error handling for impossible cases.
- If it is 200 lines and could be 50, rewrite it.

## Surgical changes

Touch only what you must. Clean up only your own mess.

- Do not improve adjacent code, comments, or formatting.
- Do not refactor what is not broken.
- Match existing style, even if you would do it differently.
- Point out unrelated dead code. Do not delete it.
- Remove imports and variables that *your* change orphaned. Leave pre-existing
  dead code alone unless asked.

Test: every changed line should trace to the request.

<!-- Sections above adapted from multica-ai/andrej-karpathy-skills (Forrest
     Chang, after an Andrej Karpathy post 2026-01-26). Sections 1 and 4 of that
     file were left out on purpose: "ask when uncertain" fights auto mode, and
     "state a plan" duplicates plan mode. -->
