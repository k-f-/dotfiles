# Documentation Guidelines

This document defines naming conventions and organization rules for documentation in this repository.

## Directory Structure

```
docs/
├── setup/                      # User-facing documentation (never archive)
├── development/
│   ├── planning/              # Active plans and roadmaps
│   ├── summaries/             # Work session summaries
│   ├── updates/               # Changelog-style updates
│   └── issue-resolutions/     # GitHub issue documentation
└── DOCUMENTATION_GUIDELINES.md
```

## Naming Conventions

### Date Formats

Use ISO 8601 format: `YYYY-MM-DD`

### File Naming by Directory

#### `planning/`
**Format:** `topic-name.md` (no dates)
**Examples:**
- `refactor-plan.md`
- `2026-roadmap.md`
- `remaining-issues.md`

**Rationale:** Living documents that get updated over time.

#### `summaries/`
**Format:** `YYYY-MM-DD-topic-description.md`
**Examples:**
- `2025-10-14-install-script-deletion-investigation.md`
- `2025-10-14-macos-setup-session.md`
- `2025-10-20-aerospace-config-review.md`

**Rationale:** Discrete summaries of work sessions or investigations.

#### `updates/`
**Format:** `YYYY-MM-DD-brief-description.md` OR `YYYY-MM-monthly.md`
**Examples:**
- `2025-10-14-step2-enhancements.md`
- `2025-10-october-recap.md`
- `cleanup-complete.md` (one-off updates)

**Rationale:** Changelog-style tracking of changes.

#### `issue-resolutions/`
**Format:** `ISSUE_N_TYPE.md` (existing convention - keep it!)
**Examples:**
- `ISSUE_5_RESOLUTION.md`
- `ISSUE_5_GITHUB_COMMENT.md`
- `ALL_ISSUES_COMPLETE.md`

**Rationale:** Tied to GitHub issues; easy to reference.

## Archiving Policy

### When to Archive

Documents should be moved to `archive/` subdirectory when:

1. ✅ **Task/investigation is complete** - No more updates expected
2. ✅ **Superseded by newer documentation** - Old approach replaced
3. ✅ **Older than 90 days AND no longer relevant** - Historical only
4. ✅ **Moved to permanent reference docs** - Content integrated elsewhere

### Archive Process

```bash
# 1. Move to archive/ subdirectory with ARCHIVED prefix
mv summaries/2025-01-15-old-topic.md \
   summaries/archive/ARCHIVED-2025-01-15-old-topic.md

# 2. Update the archive README with a brief note
echo "- ARCHIVED-2025-01-15-old-topic.md - Superseded by new-approach.md" \
   >> summaries/archive/README.md

# 3. (Optional) Add note to newer doc referencing the old one
```

### Never Archive

- **Active plans** in `planning/` (mark as "Completed" in-file instead)
- **Recent summaries** (< 30 days old)
- **Issue resolutions** (keep all for reference)
- **Current month's updates**
- **User-facing docs** in `setup/`

### Archive Directory Structure

Each documentation directory gets its own `archive/` subdirectory:

```
docs/development/
├── planning/
│   ├── active-plan.md
│   └── archive/
│       ├── README.md
│       └── ARCHIVED-2024-12-old-plan.md
├── summaries/
│   ├── 2025-10-14-current-work.md
│   └── archive/
│       ├── README.md
│       └── ARCHIVED-2025-01-old-summary.md
└── updates/
    ├── 2025-10-october-recap.md
    └── archive/
        ├── README.md
        └── ARCHIVED-2025-09-september-recap.md
```

## Living Documents vs. Point-in-Time Documents

### Living Documents (Single File, Updated Over Time)

**Use for:**
- Planning documents with ongoing updates
- Reference materials
- Roadmaps and long-term plans

**Example:**
```markdown
# Refactor Plan

**Status:** In Progress
**Last Updated:** 2025-10-14

## Phase 1: Install Script (Completed 2025-10-14)
...

## Phase 2: Shell Configuration (In Progress)
...

## Phase 3: macOS Defaults (Planned)
...
```

### Point-in-Time Documents (Date-Prefixed, Immutable)

**Use for:**
- Session summaries
- Investigation reports
- Changelog entries
- Updates/announcements

**Example:**
```markdown
# 2025-10-14: Install Script Deletion Investigation

**Date:** October 14, 2025
**Status:** Complete

This document captures the investigation into why...
```

## Best Practices

### 1. Front Matter (Optional but Recommended)

Add YAML front matter for metadata:

```yaml
---
title: Install Script Analysis
date: 2025-10-14
status: complete  # draft | in-progress | complete | archived
tags: [install, debugging, scripts]
related:
  - refactor-plan.md
  - ISSUE_5_RESOLUTION.md
---
```

### 2. Cross-Referencing

Always link related documents:

```markdown
## Related Documentation

- [Refactor Plan](../planning/refactor-plan.md)
- [Issue #5 Resolution](../issue-resolutions/ISSUE_5_RESOLUTION.md)
- [Setup Guide](../../setup/installation.md)
```

### 3. README Files

Every directory should have a README.md that:
- Lists current active documents
- Explains the purpose of the directory
- Links to archived content

### 4. Periodic Cleanup

Run cleanup quarterly:

```bash
# Create a cleanup script
./scripts/archive-old-docs.sh --dry-run
# Review what would be archived
./scripts/archive-old-docs.sh
```

## Examples

### Good Naming

✅ `2025-10-14-install-script-deletion-investigation.md` (summaries)
✅ `refactor-plan.md` (planning)
✅ `2025-10-october-recap.md` (updates)
✅ `ISSUE_5_RESOLUTION.md` (issue-resolutions)

### Bad Naming

❌ `install_script_investigation.md` (no date in summaries)
❌ `2025-10-14-refactor-plan.md` (date in planning doc)
❌ `issue5_notes.md` (wrong naming convention)
❌ `SUMMARY.md` (too generic, no date)

## Migration Guide

To update existing files to this convention:

```bash
cd docs/development/summaries

# Rename files to add dates
mv install-script-deletion-investigation.md \
   2025-10-14-install-script-deletion-investigation.md

# Create archive directories
mkdir -p archive planning/archive updates/archive

# Move old completed work
mv old-file.md archive/ARCHIVED-2025-01-15-old-file.md

# Update README files
echo "# Archive" > archive/README.md
echo "Old documentation that is no longer active." >> archive/README.md
```

## Questions?

When in doubt:
1. Is it user-facing? → `docs/setup/`
2. Is it a plan that updates? → `docs/development/planning/` (no date)
3. Is it a discrete summary? → `docs/development/summaries/` (with date)
4. Is it a changelog? → `docs/development/updates/` (with date)
5. Is it about a GitHub issue? → `docs/issue-resolutions/ISSUE_N_*.md`
