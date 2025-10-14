# AeroSpace Layout Manager Setup

This directory can contain the `aerospace-layout-manager` as a git submodule.

## Quick Setup

### Option 1: Add as Submodule (Recommended for version control)

```bash
cd ~/dotfiles
git submodule add https://github.com/CarterMcAlister/aerospace-layout-manager.git
git submodule update --init --recursive
```

Then install it:

```bash
cd aerospace-layout-manager
bun install
bun link  # Makes it globally available
```

### Option 2: Global Install (Simpler, but not version controlled)

```bash
curl -fsSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash
```

## Automated Setup

The `install-mac.sh` script automatically:

1. Checks if the submodule exists
2. If yes: Uses `bun install && bun link` from the submodule
3. If no: Falls back to global curl installation
4. Copies `layouts.json` to `~/.config/aerospace/`

## Usage

Once installed, use it directly:

```bash
# Apply a specific layout
aerospace-layout-manager apply comms

# Apply all layouts
aerospace-layout-manager apply-all

# Get help
aerospace-layout-manager --help
```

## Wrapper Script

The `bash/dot-bin/aerospace-layout-manager-wrapper` script provides a fallback:

1. First tries globally installed `aerospace-layout-manager`
2. Falls back to running from submodule via `bun run src/index.ts`
3. Shows helpful error if neither is found

You can symlink this wrapper to just `aerospace-layout` for convenience:

```bash
cd ~/dotfiles/bash/dot-bin
ln -s aerospace-layout-manager-wrapper aerospace-layout
```

## Updating the Submodule

If you're using the submodule approach:

```bash
cd ~/dotfiles/aerospace-layout-manager
git pull origin main
bun install  # Update dependencies if needed
```

Or update all submodules at once:

```bash
cd ~/dotfiles
git submodule update --remote --merge
```

## Advantages of Submodule Approach

- ✅ **Version control**: Pin to a specific commit/version
- ✅ **Offline access**: Code is local in your dotfiles
- ✅ **Easy updates**: `git submodule update --remote`
- ✅ **Consistent across machines**: Same version everywhere
- ✅ **Can make local modifications**: Fork if needed

## Advantages of Global Install

- ✅ **Simpler**: One command installation
- ✅ **Auto-updates**: Always get latest version
- ✅ **Less space**: Not duplicated in dotfiles
- ✅ **Standard**: Uses official installation method

## Recommended Layout Workflow

1. **Edit layouts**: Modify `aerospace/layouts.json` in your dotfiles
2. **Commit changes**: `git add aerospace/layouts.json && git commit`
3. **Apply layouts**: `aerospace-layout-manager apply-all`
4. **Sync across machines**: `git pull` on other machines, then run install script

## Troubleshooting

### "aerospace-layout-manager: command not found"

1. Check if Bun is installed: `which bun`
2. If no Bun: `curl -fsSL https://bun.sh/install | bash`
3. Restart shell or `source ~/.bashrc` (or ~/.zshrc)
4. Run `install-mac.sh` again

### Submodule is empty

```bash
cd ~/dotfiles
git submodule update --init --recursive
```

### Want to switch from global to submodule (or vice versa)

**From global to submodule**:
```bash
# Uninstall global version (if using bun link)
cd ~/.bun/install/global/aerospace-layout-manager
bun unlink

# Add submodule
cd ~/dotfiles
git submodule add https://github.com/CarterMcAlister/aerospace-layout-manager.git
cd aerospace-layout-manager
bun install && bun link
```

**From submodule to global**:
```bash
# Remove submodule
cd ~/dotfiles
git submodule deinit aerospace-layout-manager
git rm aerospace-layout-manager
rm -rf .git/modules/aerospace-layout-manager

# Install globally
curl -fsSL https://raw.githubusercontent.com/CarterMcAlister/aerospace-layout-manager/main/install.sh | bash
```

## Integration with Dotfiles

The `install` script (main dotfiles installer) will:
1. Run `install-mac.sh` which sets up aerospace-layout-manager
2. Symlink `dot-bin/aerospace-layout-manager-wrapper` to `~/bin/` (or wherever your bin is)
3. This makes the command available as both:
   - `aerospace-layout-manager` (direct)
   - `aerospace-layout-manager-wrapper` (with fallback logic)

## Related Files

- `aerospace/layouts.json` - Your layout definitions
- `aerospace/README.md` - Complete AeroSpace + layout management guide
- `bash/dot-bin/aerospace-layout-manager-wrapper` - Wrapper script with fallback
- `scripts/install-mac.sh` - Automated installation
- `.gitmodules` - Git submodule configuration (if using submodule)

## Credits

- **aerospace-layout-manager**: [CarterMcAlister/aerospace-layout-manager](https://github.com/CarterMcAlister/aerospace-layout-manager)
- **AeroSpace**: [nikitabobko/AeroSpace](https://github.com/nikitabobko/AeroSpace)
