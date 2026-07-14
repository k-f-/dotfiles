# Development Documentation

Planning, analysis, and development-related documentation.

**Note**: Files in this directory are working documents and may become outdated as the project evolves.

## Structure

### 📋 Planning (`planning/`)

Future plans, refactoring ideas, and outstanding work.

- **[known-issues.md](./planning/known-issues.md)** - Currently open issues (and recently resolved ones)
- **[script-audit-plan.md](./planning/script-audit-plan.md)** - Audit of scripts and their dependencies

`summaries/` and `updates/` directories are created as needed for session summaries
and changelog-style notes; resolved point-in-time material is deleted rather than
archived in-repo (git history is the archive). See
[../DOCUMENTATION_GUIDELINES.md](../DOCUMENTATION_GUIDELINES.md).

## For AI Assistants

When creating development documentation:

1. **Planning docs** → `planning/` - Future work, TODOs, roadmaps
2. **Summary docs** → `summaries/` - Analysis, comparisons, deep dives
3. **Update docs** → `updates/` - Change logs, migration guides, what's new

Use lowercase-with-hyphens for filenames (e.g., `feature-analysis.md`).

## Maintenance

- Remove completed plans from `planning/`
- Consolidate summaries when they proliferate
- Move important information to user-facing docs in `docs/setup/`
