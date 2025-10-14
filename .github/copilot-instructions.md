# AI Assistant Rules for Dotfiles Repository

This file contains guidelines for AI assistants working on this dotfiles repository.

## Documentation Organization Rules

### CRITICAL: Where to Place Documentation Files

#### ✅ User-Facing Documentation → `docs/setup/`

**When to use**: Creating documentation that helps users configure, use, or understand features.

**Examples**:
- Setup guides (e.g., "How to install AeroSpace layout manager")
- Quick reference cards (e.g., "Common commands cheat sheet")
- Configuration guides (e.g., "How to customize keybindings")
- Troubleshooting guides
- Feature explanations

**File naming**: lowercase-with-hyphens.md

**Example file creation**:
```markdown
<!-- ✅ CORRECT -->
File: docs/setup/zsh-configuration.md
File: docs/setup/git-setup-guide.md
File: docs/setup/vim-quick-reference.md

<!-- ❌ INCORRECT -->
File: ZSH_CONFIG.md (wrong location, wrong naming)
File: setup-guide.md (wrong location)
File: GIT_SETUP.md (wrong location, wrong naming)
```

---

#### ✅ Planning & Future Work → `docs/development/planning/`

**When to use**: Creating documents about future plans, refactoring ideas, or outstanding work.

**Examples**:
- Refactoring plans (e.g., "Plan to restructure bash scripts")
- Roadmaps (e.g., "Features to add in next version")
- TODOs and remaining issues
- Architecture proposals
- Migration plans

**File naming**: lowercase-with-hyphens.md

**Example file creation**:
```markdown
<!-- ✅ CORRECT -->
File: docs/development/planning/refactor-plan.md
File: docs/development/planning/remaining-issues.md
File: docs/development/planning/v2-roadmap.md

<!-- ❌ INCORRECT -->
File: REFACTOR_PLAN.md (wrong location, wrong naming)
File: TODO.md (wrong location)
File: Future_Plans.md (wrong location, wrong naming)
```

---

#### ✅ Analysis & Summaries → `docs/development/summaries/`

**When to use**: Creating analysis documents, comparisons, or summaries during development.

**Examples**:
- Before/after comparisons
- Code analysis
- Issue deep-dives
- Implementation summaries
- Technical explanations of how something works

**File naming**: lowercase-with-hyphens.md

**Example file creation**:
```markdown
<!-- ✅ CORRECT -->
File: docs/development/summaries/before-after.md
File: docs/development/summaries/script-analysis.md
File: docs/development/summaries/dependency-review.md

<!-- ❌ INCORRECT -->
File: BEFORE_AFTER.md (wrong location, wrong naming)
File: Analysis.md (wrong location)
File: SUMMARY.md (wrong location, wrong naming)
```

---

#### ✅ Updates & Changelogs → `docs/development/updates/`

**When to use**: Creating update notes, changelogs, or "what changed" documents.

**Examples**:
- Update summaries (e.g., "October 2025 updates")
- Migration guides
- Changelogs
- "What's new" documents
- Cleanup summaries

**File naming**: lowercase-with-hyphens.md

**Example file creation**:
```markdown
<!-- ✅ CORRECT -->
File: docs/development/updates/october-2025-updates.md
File: docs/development/updates/migration-to-v2.md
File: docs/development/updates/cleanup-complete.md

<!-- ❌ INCORRECT -->
File: UPDATES.md (wrong location, wrong naming)
File: CHANGELOG.md (wrong location - unless standard practice)
File: WHATS_NEW.md (wrong location, wrong naming)
```

---

#### ✅ GitHub Issue Documentation → `docs/issue-resolutions/`

**When to use**: Documenting resolved GitHub issues.

**Examples**:
- Issue resolution details
- Implementation notes for closed issues
- Ready-to-paste GitHub comments
- Research findings related to issues

**File naming**:
- Resolutions: `ISSUE_N_RESOLUTION.md`
- Comments: `ISSUE_N_GITHUB_COMMENT.md`
- Supporting docs: `ISSUE_N_<description>.md`

**Example file creation**:
```markdown
<!-- ✅ CORRECT -->
File: docs/issue-resolutions/ISSUE_5_RESOLUTION.md
File: docs/issue-resolutions/ISSUE_5_GITHUB_COMMENT.md
File: docs/issue-resolutions/ISSUE_5_RESEARCH.md

<!-- ❌ INCORRECT -->
File: ISSUE_5_FIX.md (wrong location)
File: issue-5-notes.md (wrong location, wrong naming)
```

---

### ❌ NEVER Create These in Root

**Absolutely forbidden in root directory**:
- Setup guides
- Planning documents
- Summary documents
- Update logs
- Issue documentation
- How-to guides
- Reference cards
- Analysis documents

**Only exception**: `README.md` (main project README)

---

## Practical Guidelines

### When User Says "Create a document about X"

Ask yourself:

1. **Is it user-facing?** (setup/how-to) → `docs/setup/`
2. **Is it about future work?** (planning/TODO) → `docs/development/planning/`
3. **Is it analysis/summary?** (understanding/comparison) → `docs/development/summaries/`
4. **Is it an update log?** (changelog/what's new) → `docs/development/updates/`
5. **Is it about a GitHub issue?** → `docs/issue-resolutions/`

### File Naming Decision Tree

```
Is it an issue resolution?
├─ YES → Use ISSUE_N_*.md format
└─ NO → Use lowercase-with-hyphens.md format

Where does it go?
├─ User will read it → docs/setup/
├─ Future planning → docs/development/planning/
├─ Analysis/summary → docs/development/summaries/
├─ Update log → docs/development/updates/
└─ GitHub issue → docs/issue-resolutions/
```

### Examples of Correct File Placement

```markdown
<!-- User asks: "Document how to set up Vim" -->
✅ CREATE: docs/setup/vim-setup.md
❌ DON'T: VIM_SETUP.md (in root)

<!-- User asks: "Create a summary of what we did today" -->
✅ CREATE: docs/development/summaries/session-summary-YYYY-MM-DD.md
❌ DON'T: SUMMARY.md (in root)

<!-- User asks: "Document the plan for refactoring" -->
✅ CREATE: docs/development/planning/refactor-plan.md
❌ DON'T: REFACTOR_PLAN.md (in root)

<!-- User asks: "Create an update log" -->
✅ CREATE: docs/development/updates/october-2025-updates.md
❌ DON'T: UPDATES.md (in root)

<!-- User asks: "Document how we fixed issue #5" -->
✅ CREATE: docs/issue-resolutions/ISSUE_5_RESOLUTION.md
❌ DON'T: ISSUE_5_FIX.md (in root)
```

---

## Code Organization Rules

### Script Location

- **User scripts** (meant to be run) → `bash/dot-bin/`, `scripts/`
- **Helper/library scripts** → `bash/dot-bashrc.d/`, `zsh/.zshrc.d/`
- **Installation scripts** → `scripts/`
- **Configuration files** → Respective tool directories (e.g., `vim/`, `git/`)

### When Creating New Features

1. **Code goes in appropriate tool directory** (e.g., new bash script → `bash/dot-bin/`)
2. **User-facing docs go in `docs/setup/`** (e.g., how to use the new script)
3. **Implementation notes go in `docs/development/summaries/`** (e.g., how it works internally)

---

## Quick Checklist Before Creating Files

Before creating any markdown file, ask:

- [ ] Am I creating this in root? (If YES, stop and reconsider)
- [ ] Is this user-facing documentation? (→ `docs/setup/`)
- [ ] Is this planning/future work? (→ `docs/development/planning/`)
- [ ] Is this analysis/summary? (→ `docs/development/summaries/`)
- [ ] Is this an update log? (→ `docs/development/updates/`)
- [ ] Is this about a GitHub issue? (→ `docs/issue-resolutions/`)
- [ ] Am I using lowercase-with-hyphens? (Except ISSUE_*.md)

---

## Common Mistakes to Avoid

### ❌ Mistake 1: Creating root-level documentation

```markdown
<!-- WRONG -->
Creating: SETUP_GUIDE.md
Creating: ANALYSIS.md
Creating: UPDATES.md

<!-- CORRECT -->
Creating: docs/setup/setup-guide.md
Creating: docs/development/summaries/analysis.md
Creating: docs/development/updates/updates.md
```

### ❌ Mistake 2: Wrong naming convention

```markdown
<!-- WRONG -->
docs/setup/VIM_CONFIG.md
docs/development/Planning_Doc.md

<!-- CORRECT -->
docs/setup/vim-config.md
docs/development/planning/planning-doc.md
```

### ❌ Mistake 3: Wrong category

```markdown
<!-- WRONG: User guide in development -->
docs/development/summaries/how-to-use-vim.md

<!-- CORRECT: User guide in setup -->
docs/setup/vim-usage-guide.md
```

---

## When User Requests Documentation

### User Says: "Create a guide for X"

**Response**:
```markdown
I'll create a user guide at docs/setup/x-guide.md

This will include:
- Setup instructions
- Common usage examples
- Troubleshooting
```

### User Says: "Summarize what we did"

**Response**:
```markdown
I'll create a summary at docs/development/summaries/session-summary-YYYY-MM-DD.md

This will document:
- Changes made
- Decisions taken
- Outstanding items
```

### User Says: "Document future plans"

**Response**:
```markdown
I'll create a planning document at docs/development/planning/[descriptive-name].md

This will include:
- Proposed changes
- Implementation approach
- Timeline/priorities
```

---

## Directory Structure Reference

```
dotfiles/
├── README.md                          ← ONLY markdown in root!
│
├── docs/
│   ├── README.md
│   │
│   ├── setup/                         ← User-facing docs
│   │   ├── README.md
│   │   ├── tool-setup.md
│   │   └── quick-reference.md
│   │
│   ├── development/                   ← AI-generated docs
│   │   ├── README.md
│   │   ├── planning/
│   │   │   └── refactor-plan.md
│   │   ├── summaries/
│   │   │   └── analysis.md
│   │   └── updates/
│   │       └── updates.md
│   │
│   └── issue-resolutions/             ← GitHub issues
│       ├── README.md
│       └── ISSUE_N_*.md
│
└── [tool directories]/
    └── README.md                      ← Tool-specific README okay
```

---

## Summary

**Golden Rule**: If you're creating a markdown file and it's not `README.md`, it goes in `docs/` somewhere!

**Use this decision process**:
1. User-facing? → `docs/setup/`
2. Planning? → `docs/development/planning/`
3. Summary? → `docs/development/summaries/`
4. Update? → `docs/development/updates/`
5. Issue? → `docs/issue-resolutions/`

**Naming**: lowercase-with-hyphens.md (except ISSUE_*.md)

**When in doubt**: Ask the user or default to `docs/development/summaries/`

---

## Additional Best Practices

### Minimize Documentation Clutter

**PREFER**: Adding to existing documentation over creating new files

**Examples**:
```markdown
<!-- ✅ GOOD: Update existing file -->
File: docs/setup/aerospace-setup.md
Action: Add new section "Troubleshooting Common Issues"

<!-- ❌ AVOID: Creating new file unnecessarily -->
File: docs/setup/aerospace-troubleshooting.md
Action: Create new file for troubleshooting
```

**When to update existing docs**:
- Adding new sections to existing guides
- Expanding on existing topics
- Adding examples or clarifications
- Documenting related features

**When to create new docs**:
- Completely different topic/tool
- Different audience (user vs developer)
- Document would exceed 500 lines
- Conceptually independent content

### Periodic Review Requirements

**MANDATORY**: Periodically review and address incomplete work

**Review Schedule**:
- **Weekly**: Check `docs/development/planning/` for actionable items
- **Before each session**: Review open GitHub issues
- **Monthly**: Audit all TODO comments in code

**Review Checklist**:
1. Check `docs/development/planning/remaining-issues.md` for unfinished tasks
2. Review `docs/development/planning/refactor-plan.md` for pending refactors
3. Scan `docs/issue-resolutions/` for issues not yet closed on GitHub
4. Search codebase for `TODO:`, `FIXME:`, `HACK:` comments
5. Review `docs/development/updates/` for promised follow-ups

**When reviewing planning documents**:
- Mark completed items with ✅
- Move completed sections to `docs/development/summaries/`
- Update priorities based on current needs
- Remove or archive obsolete plans

**When reviewing GitHub issues**:
- Close issues with prepared comments in `docs/issue-resolutions/`
- Update issue resolution docs with new findings
- Create new planning docs for complex issues
