# Issue #1 Resolution: Install with Existing Symlinks

## Problem

When running `./install` on a machine that already has dotfiles symlinks pointing to a different location (e.g., `~/Dropbox/Code/dotfiles` or `~/Library/CloudStorage/Dropbox/Code/dotfiles`), the installation fails with errors like:

```
CONFLICT when stowing bash: existing target is not owned by stow: .bashrc
WARNING! stowing bash would cause conflicts:
  * existing target is not owned by stow: .bashrc
  * existing target is not owned by stow: .bashrc.d
  * existing target is not owned by stow: .bin
```

This happens because GNU Stow detects that the symlinks exist but don't point to the current dotfiles directory.

## Root Cause

The issue occurs when:
1. You have dotfiles installed from location A (e.g., `~/Dropbox/Code/dotfiles`)
2. You clone/move dotfiles to location B (e.g., `~/.dots` or `~/Documents/Code/dotfiles`)
3. You try to run `./install` from location B
4. Stow sees symlinks pointing to location A and refuses to overwrite them

## Solution

The install script now has a `--relink` option that:

1. **Detects dotfiles symlinks from other locations** - Recognizes common patterns:
   - `*/dotfiles/*`
   - `*/.dotfiles/*`
   - `*/.dots/*`
   - `*/Dropbox/Code/dotfiles/*`
   - `*/iCloud/*/dotfiles/*`

2. **Automatically removes and allows relinking** - When `--relink` is used:
   - Removes old symlinks pointing to previous dotfiles locations
   - Allows stow to create new symlinks to the current location
   - Preserves symlinks that already point to the correct location

3. **Safe preview mode** - Use `--dry-run` with `--relink` to see what would change

## Usage

### Preview what will be relinked
```bash
./install --relink --dry-run --verbose
```

### Actually relink the dotfiles
```bash
./install --relink
```

### Relink only core packages
```bash
./install --relink --minimal
```

## Example Output

**Before (with conflicts):**
```
✗ Failed to stow bash
CONFLICT when stowing bash: existing target is not owned by stow: .bashrc
```

**With --relink --dry-run:**
```
! Dotfiles symlink from different location: .bashrc
  Points to: Dropbox/Code/dotfiles/bash/.bashrc
  Use --relink to automatically update these symlinks
```

**With --relink:**
```
  Relinking from old dotfiles: /Users/kef/.bashrc
    Old: Dropbox/Code/dotfiles/bash/.bashrc
    New: /Users/kef/Documents/Code/dotfiles/bash/dot-bashrc
✓ Stowed bash
```

## Safety Features

1. **Dry-run mode**: Always test with `--dry-run` first
2. **Verbose output**: Use `--verbose` to see exactly what's happening
3. **Backup preservation**: Regular files are still backed up
4. **Selective relinking**: Only relinks dotfiles symlinks, leaves other symlinks alone
5. **Broken symlink cleanup**: Automatically removes broken symlinks

## Related Commands

```bash
# Check which files are currently symlinked
find ~ -maxdepth 1 -type l -ls

# Check where a specific file points
readlink ~/.bashrc

# See all stow conflicts
stow --no --verbose=4 bash 2>&1 | grep CONFLICT
```

## Technical Details

The solution works by:

1. Adding `is_dotfiles_symlink()` function that pattern-matches common dotfiles paths
2. Enhancing `backup_conflicts()` to detect and handle three types of symlinks:
   - Symlinks to current dotfiles → Leave alone
   - Symlinks to old dotfiles → Remove if `--relink` is set
   - Other symlinks → Only touch with `--force`
3. Using stow's `--restow` flag to handle the relinking process

## Migration Guide

If you're moving your dotfiles from one location to another:

1. **Clone/move to new location**
   ```bash
   git clone https://github.com/k-f-/dotfiles.git ~/.dots
   cd ~/.dots
   ```

2. **Preview the changes**
   ```bash
   ./install --relink --dry-run --verbose | less
   ```

3. **Review what will be relinked**
   - Check that only your dotfiles symlinks are being touched
   - Verify the new paths look correct

4. **Execute the relink**
   ```bash
   ./install --relink
   ```

5. **Verify everything works**
   ```bash
   # Check a few key files
   readlink ~/.bashrc
   readlink ~/.zshrc
   readlink ~/.gitconfig
   
   # Test in a new shell
   zsh -l
   ```

6. **Optional: Remove old dotfiles directory**
   ```bash
   # Only after verifying everything works!
   rm -rf ~/Dropbox/Code/dotfiles
   ```

## Status

✅ **RESOLVED** - The `--relink` option successfully handles symlinks from old dotfiles locations.
