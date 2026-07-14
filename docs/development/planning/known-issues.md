# Known Issues

## gh auth setup-git modifies tracked gitconfig

**Status**: Open (design decision needed)
**Severity**: Low
**Found**: 2026-02-16

`gh auth setup-git` adds a credential helper to `~/.gitconfig`. Since that file is stowed from `git/dot-gitconfig` in the repo, this dirties the working tree.

**Options**:
1. Use `~/.gitconfig.local` (if gitconfig includes it) for machine-specific git config
2. Accept the modification and don't track it
3. Add the credential helper to the repo's gitconfig (makes it universal)

Note: the repo's gitconfig already carries `helper = !gh auth git-credential` (portable form, 2026-07-14), so the remaining question is only whether `gh auth setup-git` re-runs should be avoided.

## Recently resolved

- **Install `--force` tree-fold bug** (found 2026-02-16, fixed 2026-07-14): `remove_stow_conflicts()` now shares the same tree-folded-parent guard as `backup_conflicts()` (`is_tree_folded_path()` in `install`), closing the last path by which an install could move repo files out to backup.
- **aerospace-layout-manager submodule needs upstream PR** (found 2026-02-17, moot since 2026-05-18): the submodule was removed entirely; its functionality (including orientation-aware `join-with`) lives in `universal-layout-manager/`.
