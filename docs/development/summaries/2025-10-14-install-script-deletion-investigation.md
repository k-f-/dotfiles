# Install Script File Deletion Investigation

**Date:** October 14, 2025
**Issue:** `./install --relink` appeared to delete config files from the dotfiles repository

## What Happened

When running `./install --relink`, the following files were deleted from the repository:
- `doom/.config/doom/{config.el, init.el, packages.el}`
- `kitty/.config/kitty/kitty.conf`
- `sketchybar/.config/sketchybar/sketchybarrc`
- `skhd/.config/skhd/skhdrc`
- `ssh/.ssh/config`
- `yabai/.config/yabai/yabairc`
- `youtube-dl/.config/youtube-dl/config`
- Various bash scripts (checkmail, diff-so-fancy, eem, etc.)

## Recovery

Files were successfully restored using:
```bash
git restore <files>
```

## Root Cause Analysis

### The `backup_conflicts()` Function

The function (lines 210-289 in `install` script) handles conflicts when stowing:

1. **Checks if target file exists** in `$HOME`
2. **If symlink**, checks if it points to current dotfiles directory
3. **If `--relink` flag**, removes symlinks pointing to old dotfiles locations
4. **Problem**: Line 266 `rm "${target_file}"` removes the symlink

### Why Files Were Deleted

**Likely Scenario**:
The files in the dotfiles repository were **themselves symlinks** pointing to other locations, or there was a circular reference issue where:
- `$HOME/.config/doom/config.el` → symlink to `~/Documents/Code/dotfiles/doom/.config/doom/config.el`
- But the source file was also somehow affected

**Alternative Scenario**:
The `--relink` logic had a bug where it didn't properly distinguish between:
- Symlinks **in** `$HOME` pointing **to** dotfiles (should be removed and recreated)
- Files **in** the dotfiles directory itself (should never be touched)

## The Bug

Looking at lines 232-248:

```bash
if [[ -L "${target_file}" ]]; then
    local link_target=$(readlink "${target_file}")

    # Check if it points to our current dotfiles directory
    # Resolve relative symlinks to check if they point to current dotfiles
    local resolved_target
    if [[ "${link_target}" = /* ]]; then
        # Absolute path
        resolved_target="${link_target}"
    else
        # Relative path - resolve from $HOME
        resolved_target="$(cd "${HOME}" && cd "$(dirname "${link_target}")" 2>/dev/null && pwd)/$(basename "${link_target}")" || resolved_target=""
    fi

    if [[ "${link_target}" == *"${DOTFILES_DIR}"* ]] || [[ "${resolved_target}" == "${DOTFILES_DIR}"* ]]; then
        print_verbose "Symlink already managed: ${target_file}"
        continue
    fi
```

The logic checks if the symlink points to `DOTFILES_DIR`, and if so, skips it with `continue`. This **should** have protected already-stowed files.

**Hypothesis**: The files were caught by the `is_dotfiles_symlink()` check (lines 260-272):

```bash
# Check if it points to another dotfiles directory
if is_dotfiles_symlink "${link_target}"; then
    if [[ "${RELINK}" == "true" ]]; then
        print_verbose "Relinking from old dotfiles: ${target_file}"
        print_verbose "  Old: ${link_target}"
        print_verbose "  New: ${DOTFILES_DIR}/${package}/${rel_path}"
        if [[ "${DRY_RUN}" == "false" ]]; then
            rm "${target_file}"  # ← This removes the symlink in $HOME
        fi
    fi
```

This section is for **relinking from a different dotfiles location**, but it might have incorrectly matched files already pointing to the current dotfiles directory.

## The Fix

The bug fix we implemented (lines 233-243) improves symlink resolution, but there may still be an issue with the `is_dotfiles_symlink()` function being too broad.

### Recommended Additional Fix

The `--relink` logic should have an additional check:

```bash
# Check if it points to another dotfiles directory (NOT the current one)
if is_dotfiles_symlink "${link_target}" && \
   [[ "${link_target}" != *"${DOTFILES_DIR}"* ]] && \
   [[ "${resolved_target}" != "${DOTFILES_DIR}"* ]]; then
    # Only relink if it's a DIFFERENT dotfiles directory
    if [[ "${RELINK}" == "true" ]]; then
        # ... relinking code ...
    fi
fi
```

This ensures we only relink from **other** dotfiles directories, not the current one.

## Testing Notes

- Files were successfully restored from git
- The symlink resolution fix (lines 233-243) helps with relative path detection
- Further testing needed with `--relink` flag to ensure it doesn't delete already-managed files

## Conclusion

The issue was likely caused by the `--relink` logic not properly excluding symlinks that already point to the **current** dotfiles directory. The `is_dotfiles_symlink()` function matched them as "dotfiles symlinks" but didn't check if they were already pointing to the correct location.

**Status**: Partially fixed. Additional safeguards recommended before using `--relink` again.
