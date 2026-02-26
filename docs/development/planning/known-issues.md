# Known Issues

## Install Script: `--force` mode tree-fold bug

**Status**: Open
**Severity**: Medium
**Found**: 2026-02-16

`remove_stow_conflicts()` in `./install --force` moves actual repo files to backup when tree-folded directories exist. It doesn't check for tree-folded parents like `backup_conflicts()` does.

**Symptoms**: Backup artifact files appear inside the stow package (e.g., `aliases 2.bash` inside `bash/dot-bashrc.d/`). These are copies of tracked repo files that were incorrectly treated as user conflicts.

**Workaround**: Run `git restore` on any affected files after `--force` install.

## aerospace-layout-manager: local submodule commit needs upstream PR

**Status**: Open (action needed on resume)
**Severity**: High
**Found**: 2026-02-17

Commit `f302f9f` updated the `aerospace-layout-manager` submodule pointer to a local-only commit (`d41818d`) that fixes orientation-aware `join-with` direction for nested layout groups. This commit does NOT exist on the upstream remote (`CarterMcAlister/aerospace-layout-manager`), so `git submodule update` will fail on a fresh clone.

**Fix**: `joinItemWithPreviousWindow` was hardcoded to `join-with left` regardless of the parent group's orientation. Vertical groups (e.g. Messages above Signal in the comms layout) need `join-with up`. The fix passes `parentOrientation` through `traverseTreeReposition` recursion.

**Action required**:
1. Fork `CarterMcAlister/aerospace-layout-manager` to `k-f-/aerospace-layout-manager`
2. Push the fix branch and open a PR upstream
3. If accepted, update submodule to upstream. If not, repoint submodule to the fork.

**Upstream context**: Issue [#3](https://github.com/CarterMcAlister/aerospace-layout-manager/issues/3) asks about nested layouts with no maintainer response. This fix addresses that as well.

## gh auth setup-git modifies tracked gitconfig

**Status**: Open (design decision needed)
**Severity**: Low
**Found**: 2026-02-16

`gh auth setup-git` adds a credential helper to `~/.gitconfig`. Since that file is stowed from `git/dot-gitconfig` in the repo, this dirties the working tree.

**Options**:
1. Use `~/.gitconfig.local` (if gitconfig includes it) for machine-specific git config
2. Accept the modification and don't track it
3. Add the credential helper to the repo's gitconfig (makes it universal)
