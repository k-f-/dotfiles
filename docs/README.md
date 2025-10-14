# Documentation

This directory contains all documentation for the dotfiles repository, organized by purpose and audience.

## Quick Navigation

- **[Setup Guides](#setup-guides)** - User-facing setup and reference documentation
- **[Development Docs](#development-documentation)** - Planning, summaries, and updates (mostly AI-generated)
- **[Issue Resolutions](#issue-resolutions)** - Resolved GitHub issues and implementation details

---

## Setup Guides

**Location**: `docs/setup/`

User-facing documentation for setting up and using the dotfiles.

| Document | Description |
|----------|-------------|
| [aerospace-layout-manager.md](./setup/aerospace-layout-manager.md) | Complete AeroSpace layout manager setup guide |
| [aerospace-quick-reference.md](./setup/aerospace-quick-reference.md) | Quick reference for AeroSpace commands |
| [keybindings.md](./setup/keybindings.md) | Keybindings reference for all tools |

**Purpose**: Help users configure and use the dotfiles features.

---

## Development Documentation

**Location**: `docs/development/`

Planning, analysis, and development-related documentation (mostly AI-generated during development).

### Planning

**Location**: `docs/development/planning/`

Future plans and outstanding work.

| Document | Description |
|----------|-------------|
| [refactor-plan.md](./development/planning/refactor-plan.md) | Plans for future refactoring |
| [remaining-issues.md](./development/planning/remaining-issues.md) | Outstanding issues and TODOs |

### Summaries

**Location**: `docs/development/summaries/`

Analysis and summary documents created during development.

| Document | Description |
|----------|-------------|
| [before-after.md](./development/summaries/before-after.md) | Before/after comparison of changes |
| [summary.md](./development/summaries/summary.md) | General project summary |
| [issues-detail.md](./development/summaries/issues-detail.md) | Detailed issue analysis |

### Updates

**Location**: `docs/development/updates/`

Change logs and update summaries.

| Document | Description |
|----------|-------------|
| [updates.md](./development/updates/updates.md) | Recent updates and changes |
| [cleanup-complete.md](./development/updates/cleanup-complete.md) | Repository cleanup summary |

**Purpose**: Track development progress, plans, and AI-generated analysis.

---

## Issue Resolutions

**Location**: `docs/issue-resolutions/`

Complete documentation for all resolved GitHub issues.

| Document | Description |
|----------|-------------|
| [README.md](./issue-resolutions/README.md) | Index of all issue resolutions |
| [github-issues-summary.md](./issue-resolutions/github-issues-summary.md) | Summary for posting to GitHub |
| [all-issues-summary.md](./issue-resolutions/all-issues-summary.md) | Complete summary of all issues |
| ISSUE_1_RESOLUTION.md | Install with existing symlinks |
| ISSUE_1_GITHUB_COMMENT.md | Ready-to-paste GitHub comment |
| ISSUE_2_RESOLUTION.md | macOS install.sh improvements |
| ISSUE_2_GITHUB_COMMENT.md | Ready-to-paste GitHub comment |
| ISSUE_3_RESOLUTION.md | macOS applications cleanup |
| ISSUE_3_GITHUB_COMMENT.md | Ready-to-paste GitHub comment |
| ISSUE_4_RESOLUTION.md | AeroSpace layout save/restore |
| ISSUE_4_GITHUB_COMMENT.md | Ready-to-paste GitHub comment |
| ISSUE_4_RESEARCH_UPDATE.md | Research breakthrough documentation |
| ISSUE_4_SUBMODULE_UPDATE.md | Git submodule integration |
| ISSUE_4_IMPLEMENTATION_NOTES.md | Initial technical analysis |

**Purpose**: Archive resolved GitHub issues with complete implementation details.

---

## Documentation Organization Guidelines

### For AI Assistants

When creating new documentation files, follow these guidelines:

#### 1. User-Facing Documentation → `docs/setup/`

**Examples**:
- Setup guides
- Quick reference cards
- How-to guides
- Keybindings
- Configuration references

**Naming**: Use lowercase with hyphens (e.g., `aerospace-setup.md`)

#### 2. Development/Planning Docs → `docs/development/`

**Subcategories**:

- **`planning/`** - Future plans, TODOs, refactoring plans
  - Examples: `refactor-plan.md`, `remaining-issues.md`, `roadmap.md`

- **`summaries/`** - Analysis and summary documents
  - Examples: `before-after.md`, `summary.md`, `analysis.md`

- **`updates/`** - Change logs and update notes
  - Examples: `updates.md`, `changelog.md`, `migration-guide.md`

**Naming**: Use lowercase with hyphens (e.g., `refactor-plan.md`)

#### 3. Issue Documentation → `docs/issue-resolutions/`

**Examples**:
- GitHub issue resolutions
- Implementation details for closed issues
- Ready-to-paste GitHub comments

**Naming**:
- Resolutions: `ISSUE_N_RESOLUTION.md`
- Comments: `ISSUE_N_GITHUB_COMMENT.md`
- Supporting: `ISSUE_N_<description>.md`

### File Naming Conventions

- **User-facing**: lowercase-with-hyphens.md
- **Development**: lowercase-with-hyphens.md
- **Issues**: ISSUE_N_DESCRIPTION.md (uppercase for legacy compatibility)

### Root Directory Rules

**Only these markdown files belong in the root**:
- `README.md` - Main repository README (required)

**Everything else goes in `docs/`!**

### Anti-Patterns (Don't Do This)

❌ Creating `SOME_DOCUMENT.md` in root
✅ Create in `docs/development/summaries/some-document.md`

❌ Creating `SETUP_GUIDE.md` in root
✅ Create in `docs/setup/setup-guide.md`

❌ Creating `CHANGELOG.md` in root
✅ Create in `docs/development/updates/changelog.md` (or keep if standard practice)

### Exceptions

Some files are standard practice to keep in root:
- `README.md` - Main project README (required)
- `LICENSE` - License file (if applicable)
- `CHANGELOG.md` - If following conventional changelog format
- `CONTRIBUTING.md` - If accepting contributions

---

## Current Structure

```
docs/
├── README.md                           # This file
│
├── setup/                              # User-facing documentation
│   ├── aerospace-layout-manager.md
│   ├── aerospace-quick-reference.md
│   └── keybindings.md
│
├── development/                        # Development documentation
│   ├── planning/
│   │   ├── refactor-plan.md
│   │   └── remaining-issues.md
│   ├── summaries/
│   │   ├── before-after.md
│   │   ├── summary.md
│   │   └── issues-detail.md
│   └── updates/
│       ├── updates.md
│       └── cleanup-complete.md
│
└── issue-resolutions/                 # GitHub issue documentation
    ├── README.md
    ├── github-issues-summary.md
    ├── all-issues-summary.md
    ├── ISSUE_1_RESOLUTION.md
    ├── ISSUE_1_GITHUB_COMMENT.md
    ├── ISSUE_2_RESOLUTION.md
    ├── ISSUE_2_GITHUB_COMMENT.md
    ├── ISSUE_3_RESOLUTION.md
    ├── ISSUE_3_GITHUB_COMMENT.md
    ├── ISSUE_4_RESOLUTION.md
    ├── ISSUE_4_GITHUB_COMMENT.md
    ├── ISSUE_4_RESEARCH_UPDATE.md
    ├── ISSUE_4_SUBMODULE_UPDATE.md
    ├── ISSUE_4_IMPLEMENTATION_NOTES.md
    └── ALL_ISSUES_COMPLETE.md
```

---

## Maintenance

When updating documentation:

1. **Keep this README updated** - Add new documents to the appropriate section
2. **Follow naming conventions** - Use lowercase-with-hyphens for new files
3. **Use semantic folders** - Place documents in the most appropriate category
4. **Link between documents** - Use relative links for easy navigation
5. **Archive old docs** - Move outdated development docs to `development/archives/` if needed

---

## Quick Links

- [Main README](../README.md)
- [Install Script](../install)
- [AeroSpace Configuration](../aerospace/README.md)
- [Scripts Documentation](../scripts/README.md)
