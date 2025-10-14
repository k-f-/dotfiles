# Issue #4 Update: Git Submodule Integration

**Date**: October 14, 2025
**Update Type**: Enhancement - Git submodule support added

---

## What Changed

We've enhanced the aerospace-layout-manager integration to support **git submodules**, giving you full version control over the tool while keeping your dotfiles self-contained.

## New Files

1. **`bash/dot-bin/aerospace-layout-manager-wrapper`** (new)
   - Smart wrapper that tries multiple installation methods
   - Falls back gracefully if one method isn't available
   - Provides helpful error messages

2. **`bash/dot-bin/aerospace-layout`** (modified)
   - Old pixel-based script renamed to `.old-pixel-based-DEPRECATED`
   - New script is a simple alias to the wrapper
   - Shorter command name for convenience

3. **`AEROSPACE_LAYOUT_MANAGER_SETUP.md`** (new)
   - Complete setup guide
   - Submodule vs global installation comparison
   - Troubleshooting section

4. **`scripts/install-mac.sh`** (enhanced)
   - Auto-detects if submodule exists
   - Falls back to curl installation if not
   - Copies layouts.json to config directory

## How It Works

### Installation Priority

The system checks in this order:

1. **Globally installed** `aerospace-layout-manager` (via `bun link` or curl install)
2. **Submodule** at `~/dotfiles/aerospace-layout-manager` (run via `bun`)
3. **Error** with helpful instructions if neither exists

### Wrapper Logic

```bash
# 1. Try global
if command -v aerospace-layout-manager; then
    exec aerospace-layout-manager "$@"
fi

# 2. Try submodule
if [ -d "$DOTFILES_ROOT/aerospace-layout-manager" ]; then
    cd "$DOTFILES_ROOT/aerospace-layout-manager"
    exec bun run src/index.ts "$@"
fi

# 3. Show error with help
echo "Error: not installed. Try one of..."
```

## Adding the Submodule

### Quick Start

```bash
cd ~/dotfiles
git submodule add https://github.com/CarterMcAlister/aerospace-layout-manager.git
git submodule update --init --recursive
cd aerospace-layout-manager
bun install
bun link  # Optional: makes it globally available
```

### Update .gitmodules

This adds to your `.gitmodules`:

```ini
[submodule "aerospace-layout-manager"]
	path = aerospace-layout-manager
	url = https://github.com/CarterMcAlister/aerospace-layout-manager.git
```

### Commit It

```bash
git add .gitmodules aerospace-layout-manager
git commit -m "Add aerospace-layout-manager as submodule"
```

## Using It

### Same Commands Work

Whether you use submodule or global install, the commands are identical:

```bash
# Short form (via dot-bin/aerospace-layout)
aerospace-layout apply comms
aerospace-layout apply-all

# Full form (direct or via wrapper)
aerospace-layout-manager apply comms
aerospace-layout-manager apply-all
```

### The Magic

The wrapper script automatically figures out which installation method you're using and routes to the right one. You don't have to think about it!

## Benefits of Submodule Approach

### Version Control ✅
```bash
# Pin to a specific commit
cd aerospace-layout-manager
git checkout v1.2.3

# Or track main branch
git checkout main
```

### Consistency Across Machines ✅
```bash
# Machine 1: Add submodule
git submodule add https://github.com/CarterMcAlister/aerospace-layout-manager.git
git commit -m "Add layout manager"
git push

# Machine 2: Clone gets the submodule
git clone --recursive https://github.com/yourusername/dotfiles.git
# Or if already cloned:
git submodule update --init --recursive
```

### Can Make Local Changes ✅
```bash
# Fork the repo and use your fork
git submodule add https://github.com/YOURUSERNAME/aerospace-layout-manager.git

# Or make local changes
cd aerospace-layout-manager
# Make changes to src/
git commit -m "Custom modifications"
```

### Easy Updates ✅
```bash
# Update to latest
cd ~/dotfiles
git submodule update --remote aerospace-layout-manager

# Or manually
cd aerospace-layout-manager
git pull origin main
```

## Benefits of Global Install

### Simpler ✅
```bash
# One command
curl -fsSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash
```

### Auto-Updates ✅
```bash
# Updates happen when you reinstall
curl -fsSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash
```

### Less Space ✅
- Not duplicated in every dotfiles clone
- Single global installation

## Which Should You Use?

### Use Submodule If You Want:
- 🎯 **Version pinning** - Lock to a specific version that works
- 🎯 **Offline access** - Code is local, works without internet
- 🎯 **Consistency** - Same version on all your machines
- 🎯 **Custom changes** - Fork and modify the tool
- 🎯 **Full control** - Know exactly what version you're running

### Use Global Install If You Want:
- 🚀 **Simplicity** - Just one curl command
- 🚀 **Latest version** - Always get newest features
- 🚀 **Less clutter** - Keep dotfiles minimal
- 🚀 **Standard approach** - Use official installation method

## Recommendation

**Start with submodule** if you're serious about dotfiles version control and consistency. You can always switch to global later if it's overkill.

The install script supports both, so you can try one, then switch without breaking anything!

## Updating Your Setup

### If You Already Have Global Install

Keep it! It will work. Or add the submodule too - the wrapper prefers global first anyway.

### If You Want to Add Submodule Now

```bash
cd ~/dotfiles
git submodule add https://github.com/CarterMcAlister/aerospace-layout-manager.git
cd aerospace-layout-manager
bun install
# Optionally: bun link (to also make it global)
```

### To Remove Global and Use Only Submodule

```bash
# Find where it's installed
which aerospace-layout-manager

# If installed via bun link, unlink it
cd ~/.bun/install/global
# (or wherever it shows)
bun unlink aerospace-layout-manager

# Now only the submodule version will be used
```

## Files Layout

```
dotfiles/
├── aerospace/
│   └── layouts.json                    # Your layout definitions
├── bash/dot-bin/
│   ├── aerospace-layout                # Short alias (calls wrapper)
│   ├── aerospace-layout-manager-wrapper # Smart wrapper script
│   └── aerospace-layout.old-pixel-based-DEPRECATED  # Old approach (kept as reference)
├── scripts/
│   └── install-mac.sh                  # Auto-detects submodule or uses global
├── aerospace-layout-manager/           # Git submodule (if you add it)
│   ├── src/
│   │   └── index.ts                    # Main TypeScript source
│   ├── package.json
│   └── bun.lockb
├── .gitmodules                         # Submodule config (created when you add it)
└── AEROSPACE_LAYOUT_MANAGER_SETUP.md   # This guide
```

## Testing Your Setup

```bash
# Test the wrapper
aerospace-layout-manager --help

# Test the short alias
aerospace-layout --help

# Verify which installation it's using
which aerospace-layout-manager

# If using submodule, check it's present
ls ~/dotfiles/aerospace-layout-manager

# Test applying a layout
aerospace-layout apply comms
```

## Troubleshooting

### "command not found"

1. Check Bun is installed: `which bun`
2. If no Bun: `curl -fsSL https://bun.sh/install | bash`
3. Restart shell
4. Run `~/dotfiles/scripts/install-mac.sh`

### Submodule is empty

```bash
cd ~/dotfiles
git submodule update --init --recursive
```

### Want to see which method wrapper is using

Add debug output to the wrapper (optional):

```bash
# Edit bash/dot-bin/aerospace-layout-manager-wrapper
# Add at the top:
set -x  # Enable debug mode
```

## Next Steps

1. **Choose your installation method** (submodule recommended)
2. **Add submodule if desired**: `git submodule add ...`
3. **Run install script**: `./scripts/install-mac.sh`
4. **Test it**: `aerospace-layout apply-all`
5. **Customize layouts**: Edit `aerospace/layouts.json`
6. **Commit changes**: `git add . && git commit`

## Related Documentation

- `ISSUE_4_RESOLUTION.md` - Original solution discovery
- `ISSUE_4_RESEARCH_UPDATE.md` - Research breakthrough
- `aerospace/README.md` - Complete AeroSpace + layouts guide
- `ALL_ISSUES_COMPLETE.md` - All issues summary

---

**Summary**: You now have flexible installation options with smart fallback logic. The system works whether you use global install, submodule, or both. Choose what fits your workflow! 🚀
