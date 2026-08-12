---
name: legal
description: "Legal research pipeline: Sonnet researchers fan out, an Opus adversarial panel vets every claim, findings land in a per-matter living memo. Use when Kyle asks a legal question — consumer/purchase disputes, warranties, insurance claims, housing/property, or employment/manager-side questions."
argument-hint: "<question, or existing matter name>"
---

## Scope & framing

Covered domains: consumer & purchases, housing & property, employment & management. Business/IP is out of scope — say so if asked and stop.

This produces legal research, not legal advice: findings state what the law says, never outcome predictions or strategy.

Employment/manager-side questions get a triage step first: is this really a company-policy/HR question wearing a legal hat? If so, the deliverable is "ask HR / check policy — here is the legal floor," not dressed-up statute.

## Pipeline

1. **Intake.** Check `~/Documents/Code/agr/chats/legal/` for an existing memo (one file per matter, `<matter-slug>.md`). New matter → create from the template below. Pin jurisdiction in the memo header — default Chattanooga, Tennessee (Hamilton County) + federal; ask Kyle only if the matter obviously lives elsewhere. Pull prior context from the agr archive when the matter references past events.

2. **Research fan-out.** Decompose the question into 2–4 angles, no more. Launch one `legal-researcher` subagent (model sonnet) per angle, all in parallel. Each prompt carries: matter summary, jurisdiction, the one assigned angle, relevant memo excerpts. Fallback: if the `legal-researcher` agent type is not registered in this session, launch a `general-purpose` Sonnet agent instructed to read `/Users/kef/.claude/agents/legal-researcher.md` and follow it exactly.

3. **Merge.** Renumber all researcher claims into one master list C1..Cn, preserving citation, source type, and confidence. Drop exact duplicates; keep near-duplicates separate.

4. **Adversarial panel.** Launch three `legal-judge` subagents (model opus) in parallel — one per lens: source-verification, jurisdiction, currency. Each receives the full master claim list and the matter jurisdiction. Same fallback pattern via `/Users/kef/.claude/agents/legal-judge.md`.

5. **Verdict resolution.** Worst verdict wins; severity order REFUTED > WRONG-JURISDICTION > STALE > UNSUPPORTED > CONFIRMED. Routing:
   - CONFIRMED by all three lenses → Verified findings.
   - UNSUPPORTED or STALE → Flagged — unverified (state what is missing).
   - WRONG-JURISDICTION or REFUTED → Rejected claims, with the killing verdict and reason.
   - Never silently drop a claim.

6. **Synthesis.** The main loop — not a subagent — updates the memo, then replies to Kyle with the bottom line, notable kills, and open questions. The memo is the deliverable of record.

## Memo template

```markdown
---
title: <Matter name>
date: <YYYY-MM-DD created>
type: legal-memo
source: legal skill
tags:
- legal
- <matter-slug>
---

# <Matter name>

**Matter:** <one-line description>
**Jurisdiction:** <city/county/state> + federal
**Status:** active | monitoring | closed
**Last updated:** <YYYY-MM-DD>

**This memo supersedes conversation memory. Only panel-verified claims appear under Verified findings.**

---

## Bottom line
<3 sentences max, plain language>

## Verified findings
| Claim | Citation | Confidence | Date verified |
|---|---|---|---|

## Flagged — unverified
<claim + what is missing to confirm it>

## Rejected claims
| Claim | Verdict | Why |
|---|---|---|
<do-not-rely list>

## Open questions

## When to call a lawyer
<concrete triggers for this matter: deadlines, demand letter received, opposing counsel appears, amount at stake exceeds what Kyle will eat>

## Log
- <YYYY-MM-DD>: <one-liner per run>
```

## Cost rules

Default 2–4 researchers + 3 judges per run. Re-run the panel only on new or changed claims — never re-vet already-CONFIRMED findings. No `--deep` mode exists; if a matter warrants per-claim panels, say so rather than improvising.

## Hard rules

- No claim reaches Kyle or the memo without passing through the panel.
- Unverifiable ≠ false: flag, never delete.
- Jurisdiction lives in the memo header and is restated to every researcher and judge on every run.
- Never fabricate memo history; the Log only records runs that happened.
- Research only: this skill does not draft demand letters, contracts, or filings.
