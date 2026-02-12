# Documentation Index

Complete index of all documentation in this repository.

**Last Updated**: 2025-11-03

## 📖 Main Documentation

- **[README.md](./README.md)** - Main repository README
  - Overview and quick start
  - Installation instructions
  - Package structure
  - Repository structure

## 🪟 Window Management (Universal WM)

### **👉 START HERE**

- **[docs/setup/universal-wm.md](./docs/setup/universal-wm.md)** - ✨ **PRIMARY GUIDE**
  - Universal window manager setup
  - Works on macOS (Aerospace), Linux (i3/Sway), Windows (planned)
  - Configuration, usage, and troubleshooting

### Reference Documentation

- **[universal-layout-manager/QUICKSTART.md](./universal-layout-manager/QUICKSTART.md)** - Quick start guide
- **[universal-layout-manager/README.md](./universal-layout-manager/README.md)** - Full documentation
- **[universal-layout-manager/INSTALLATION.md](./universal-layout-manager/INSTALLATION.md)** - Installation guide
- **[universal-layout-manager/IMPLEMENTATION_STATUS.md](./universal-layout-manager/IMPLEMENTATION_STATUS.md)** - Technical details
- **[universal-layout-manager/TESTING_RESULTS.md](./universal-layout-manager/TESTING_RESULTS.md)** - Test results
- **[universal-wm/README.md](./universal-wm/README.md)** - Stow package README

### Legacy Documentation (Deprecated)

- **[docs/setup/aerospace-layout-manager.md](./docs/setup/aerospace-layout-manager.md)** - ⚠️ DEPRECATED
- **[docs/setup/aerospace-quick-reference.md](./docs/setup/aerospace-quick-reference.md)** - ⚠️ DEPRECATED
- **[aerospace-layout-manager/README.md](./aerospace-layout-manager/README.md)** - ⚠️ DEPRECATED (submodule)

## ⌨️ Keybindings

- **[docs/setup/keybindings.md](./docs/setup/keybindings.md)** - Comprehensive keybinding reference
  - Window manager shortcuts
  - Shell shortcuts
  - Editor shortcuts

## 🛠️ Setup Guides

- **[docs/setup/README.md](./docs/setup/README.md)** - Setup documentation index
- **[docs/setup/universal-wm.md](./docs/setup/universal-wm.md)** - Window manager setup (primary)

## 🎨 Theming

- **[aesthetics/README.md](./aesthetics/README.md)** - Theming documentation
  - Theme installation
  - Toggle theme script
  - Supported applications

## 📦 Package-Specific READMEs

- **[bash/README.md](./bash/README.md)** - Bash configuration
- **[bash/dot-bin/README.md](./bash/dot-bin/README.md)** - User scripts
- **[aerospace/README.md](./aerospace/README.md)** - Aerospace config
- **[emacs/README.md](./emacs/README.md)** - Emacs configuration
- **[kitty/dot-config/kitty/README.md](./kitty/dot-config/kitty/)** - Kitty terminal config

## 👨‍💻 Development Documentation

### Planning & Status

- **[docs/development/README.md](./docs/development/README.md)** - Development docs index
- **[docs/development/planning/](./docs/development/planning/)** - Planning documents
- **[docs/development/updates/](./docs/development/updates/)** - Update logs
- **[docs/development/summaries/](./docs/development/summaries/)** - Summary documents

### Issue Resolution

- **[docs/issue-resolutions/README.md](./docs/issue-resolutions/README.md)** - Resolved issues index

### Documentation Guidelines

- **[docs/DOCUMENTATION_GUIDELINES.md](./docs/DOCUMENTATION_GUIDELINES.md)** - How to write docs

## 🔧 Scripts

- **[scripts/README.md](./scripts/README.md)** - Installation scripts documentation
- **[aesthetics/scripts/README.md](./aesthetics/scripts/README.md)** - Theme scripts

## 🤖 AI/Agentic Development

- **[agentic-dev-standards/README.md](./agentic-dev-standards/README.md)** - AI development standards (submodule)

## 📋 Quick Reference

### For Users (Setup & Usage)

1. **Getting Started**: [README.md](./README.md)
2. **Window Management**: [docs/setup/universal-wm.md](./docs/setup/universal-wm.md)
3. **Keybindings**: [docs/setup/keybindings.md](./docs/setup/keybindings.md)
4. **Theming**: [aesthetics/README.md](./aesthetics/README.md)

### For Developers (Contributing)

1. **Development Docs**: [docs/development/README.md](./docs/development/README.md)
2. **Documentation Guidelines**: [docs/DOCUMENTATION_GUIDELINES.md](./docs/DOCUMENTATION_GUIDELINES.md)
3. **Issue Resolutions**: [docs/issue-resolutions/README.md](./docs/issue-resolutions/README.md)

### For Window Management Specifically

1. **Start Here**: [docs/setup/universal-wm.md](./docs/setup/universal-wm.md)
2. **Quick Start**: [universal-layout-manager/QUICKSTART.md](./universal-layout-manager/QUICKSTART.md)
3. **Installation**: [universal-layout-manager/INSTALLATION.md](./universal-layout-manager/INSTALLATION.md)
4. **Full Docs**: [universal-layout-manager/README.md](./universal-layout-manager/README.md)
5. **Migration**: Run `universal-wm migrate`

## 📊 Documentation Status

| Category | Status | Notes |
|----------|--------|-------|
| **Main README** | ✅ Updated | Includes universal-wm |
| **Window Management** | ✅ Complete | New universal system documented |
| **Keybindings** | ✅ Current | Up to date |
| **Setup Guides** | ✅ Updated | Deprecated old, added new |
| **Development Docs** | ✅ Current | Existing docs still valid |
| **Package READMEs** | ✅ Current | Individual package docs |
| **Legacy Docs** | ⚠️ Deprecated | Marked with warnings |

## 🔄 Recent Changes

### 2025-11-03: Universal Window Manager

- ✅ Added universal-wm system documentation
- ✅ Updated main README with cross-platform info
- ✅ Created comprehensive user guide
- ✅ Added deprecation notices to old docs
- ✅ Updated setup documentation index
- ✅ Migrated to stow-based config structure

### Migration Path

**Old** → **New**:
- `aerospace-layout-manager` → `universal-wm`
- `~/.config/aerospace/layouts.json` → `~/.config/universal-wm/layouts.json`
- Aerospace-only → Cross-platform (macOS/Linux/Windows)

## 🗂️ Directory Structure

```
dotfiles/
├── README.md                            # Main documentation
├── DOCUMENTATION_INDEX.md               # This file
├── docs/
│   ├── README.md                        # Docs overview
│   ├── DOCUMENTATION_GUIDELINES.md      # Writing guidelines
│   ├── setup/                           # User guides
│   │   ├── README.md                    # Setup docs index
│   │   ├── universal-wm.md              # ✨ PRIMARY WM GUIDE
│   │   ├── keybindings.md               # Keybinding reference
│   │   ├── aerospace-layout-manager.md  # ⚠️ DEPRECATED
│   │   └── aerospace-quick-reference.md # ⚠️ DEPRECATED
│   ├── development/                     # Dev documentation
│   └── issue-resolutions/               # Issue tracking
├── universal-layout-manager/            # Universal WM code
│   ├── README.md                        # Full documentation
│   ├── QUICKSTART.md                    # Quick start guide
│   ├── INSTALLATION.md                  # Installation guide
│   ├── IMPLEMENTATION_STATUS.md         # Technical status
│   └── TESTING_RESULTS.md               # Test results
├── universal-wm/                        # Universal WM config (stow)
│   └── README.md                        # Stow package README
├── aerospace-layout-manager/            # ⚠️ Legacy submodule
│   └── README.md                        # ⚠️ DEPRECATED
├── aesthetics/                          # Theming
│   ├── README.md                        # Theme documentation
│   └── scripts/README.md                # Theme scripts
└── [package]/README.md                  # Per-package docs
```

## 📝 Maintenance

When updating documentation:

1. **Update relevant files** - Make changes where appropriate
2. **Update this index** - Add new docs here
3. **Cross-link** - Link between related docs
4. **Test links** - Ensure all links work
5. **Update "Last Updated"** - At top of this file

## 🔗 External Links

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Aerospace GitHub](https://github.com/nikitabobko/AeroSpace)
- [i3 User's Guide](https://i3wm.org/docs/userguide.html)
- [Sway Documentation](https://swaywm.org/)

---

**Note**: This index is manually maintained. If you find broken links or missing documentation, please update this file.
