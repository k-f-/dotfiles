# chezmoi Migration Plan

**Status**: Approved with revisions — in execution 2026-07-14
**Created**: 2026-07-14
**Prerequisite reading**: [known-issues.md](./known-issues.md), `docs/setup/window-manager.md`

> ⚠️ Execution rule: each phase below — especially Phase 5 (window manager) —
> must be run through plan-reviewer before applying, per standing practice for
> WM-adjacent changes.

## Why

Findings from the July 2026 full-repo review that stow cannot fix:

1. **Undetected drift** — symlinks pointing at stale checkouts and never-restowed
   files fail silently; nothing validates `$HOME` against the repo outside `./install`.
2. **Machine-specific values hardcoded** — usernames, LAN hosts, Apple-Silicon
   paths; stow has no templating.
3. **The install script fights the tool** — most of its 900+ lines exist to work
   around stow conflict/tree-folding behavior (which caused real data loss).
4. **Stow is frozen** — 2.4.1 (Sept 2024) is the latest release; the tree-folding
   sharp edges are unfixed upstream.

chezmoi (v2.71.0, actively maintained) addresses all four: `chezmoi
status/diff/verify` for drift, Go templates for machine specifics, plain-file
deployment of the existing GPG-encrypted secrets — the runtime `op inject` +
GPG fallback model is kept exactly as-is (see Decisions) — and
`run_once_`/`run_onchange_` scripts to absorb the bootstrap logic.

## Target layout

```
dotfiles/
├── .chezmoiroot            # contains: home
├── home/                   # chezmoi source state (only this is "managed")
│   ├── .chezmoi.toml.tmpl  # per-machine prompts/data
│   ├── .chezmoiignore      # consolidates old per-package .stow-local-ignore rules
│   ├── dot_zshrc.tmpl
│   ├── dot_bashrc
│   ├── dot_bin/            # executable_* scripts (aerospace-organize,
│   │                       # toggle-theme, universal-wm wrapper — Phase 0)
│   ├── dot_config/
│   │   ├── dotfiles/
│   │   │   └── env.tmpl    # writes DOTFILES_DIR; replaces ./install's job
│   │   ├── kitty/
│   │   │   └── symlink_kitty-search   # -> ../../../third_party/kitty-kitten-search
│   │   └── ...
│   ├── private_dot_gnupg/  # private_ attribute — gpg needs 0700, not chezmoi's default 0755
│   ├── private_dot_ssh/    # private_ attribute — same reason
│   ├── dot_secrets-env.gpg # ciphertext at rest; plain file, NOT encrypted_
│   └── run_onchange_darwin-packages.sh.tmpl   # brew bundle; embeds Brewfile hashes
├── docs/                   # unmanaged, stays at root
├── scripts/                # unmanaged helper scripts (shrinks a lot)
├── homebrew/               # Brewfile.core / Brewfile.desktop (read by run_onchange_)
├── third_party/
│   └── kitty-kitten-search/   # relocated submodule (was inside the kitty package)
├── universal-layout-manager/  # TS source, unmanaged; dot_bin/universal-wm wraps cli.ts
├── aesthetics/             # git submodule (unchanged)
├── agr-cli/                # git submodule (unchanged)
└── README.md, keybindings.md
```

Key decisions:

- **`.chezmoiroot home/`** keeps the mono-repo: docs, TS source, and submodules
  live at root, invisible to chezmoi. No `.chezmoiexternal` — the three
  submodules stay ordinary git submodules (verified friction with externals:
  lost exec bits, misparsed files).
- **Copy mode by default**, `symlink_` prefix only where a live checkout must
  stay editable/updatable in place (the relocated kitty-search submodule —
  see Phase 2).
- **`private_` is mandatory for `dot_gnupg/` and `dot_ssh/`** — without it
  chezmoi materializes the directories at 0755 and gpg/ssh refuse to run
  against unsafe permissions.
- **`executable_` prefix for everything under `dot_bin/`** — chezmoi's copy
  mode does not infer the execute bit; without the prefix the scripts land
  non-executable.
- **Secrets: keep the existing runtime-injection model, unchanged.** The
  `.gpg` files are ciphertext at rest; chezmoi deploys them as ordinary files
  — no `encrypted_` prefix, no `onepasswordRead`. Two reasons: (1)
  `onepasswordRead`-ing secret values through chezmoi templating would put
  plaintext into chezmoi's rendered target state; (2) `dot-mbsync-
  fastmail.gpg` is AES256-symmetric while the rest of the `.gpg` files are
  recipient-encrypted — chezmoi's single repo-wide `encryption` config can't
  span both schemes. `op inject` at shell startup, with the existing GPG
  fallback, keeps doing the actual decryption at runtime exactly as today.
- **Templates** for the known hardcodes: ssh LAN hosts, opencode.json's four
  absolute paths (`{{ .chezmoi.homeDir }}`), hostname-dependent values via
  `.chezmoi.hostname`. git's `templateDir` is already `~`-relative and
  portable as-is — no template needed there.

## Phase 0 — De-risk the S/O chain (do BEFORE any migration)

Three `dot-bin` scripts resolve their working directory by walking their own
symlink. Under chezmoi copy mode — and for one of them, under chezmoi at all
— that breaks:

- `bash/dot-bin/aerospace-organize` — symlink-walk at lines 24-31.
- `bash/dot-bin/toggle-theme` — same pattern, lines 15-24.
- `bash/dot-bin/universal-wm` — not a script at all: it's a git-committed
  **symlink** to the absolute path
  `/Users/kef/Documents/Code/dotfiles/universal-layout-manager/cli.ts`. It
  must become a wrapper script that resolves `DOTFILES_DIR` and execs the TS
  entrypoint, not a plain file copy — chezmoi copy mode would otherwise
  materialize either a dead symlink or a frozen snapshot of `cli.ts`.

**Audit note**: `grep -l readlink bash/dot-bin/*` is **not** a sufficient
audit. It misses `universal-wm` entirely (a committed symlink has no
`readlink` call to grep for) and false-positives on scripts that call
`readlink` for unrelated extraction logic. Enumerate `dot-bin` by hand
(`ls -la bash/dot-bin/`) and check each entry's actual type before assuming
the grep caught everything.

1. Change `aerospace-organize` and `toggle-theme` to resolve `DOTFILES_DIR`
   from `~/.config/dotfiles/env` first, falling back to the symlink walk.
   `show-keybindings`/`open-dotfiles` already use the env file.
2. Rewrite `universal-wm` as a wrapper script that resolves `DOTFILES_DIR`
   the same way and execs the TS entrypoint under it.
3. Verify service-mode `s`/`o` still works. Plan-review this change; it
   touches the load-bearing chain.
4. All of `dot_bin/` deploys as `executable_*` copies (not `symlink_`) —
   edit via `chezmoi edit`/`chezmoi cd`, never by editing $HOME directly.

Once no script depends on being a symlink into the repo, the migration order
below is free of WM risk until Phase 5.

## Phase 1 — Scaffold (no behavior change)

1. Tag the current HEAD `stow-final` and push it. This is the mac mini's
   pinned rollback reference — see Decisions for why the mini must not pull
   past it until its own migration.
2. `brew install chezmoi`.
3. Create `home/`, `.chezmoiroot`, minimal `.chezmoi.toml.tmpl` (prompts:
   machine name, work/personal), `.chezmoiignore`.
4. Point chezmoi at the repo: `chezmoi init --source ~/Documents/Code/dotfiles`
   (config `sourceDir` honors `.chezmoiroot`).
5. `chezmoi doctor` must pass. Nothing is applied yet; stow still owns $HOME.

## Phase 2 — Leaf packages (low risk, one at a time)

Order: `yt-dlp` → `gh` → `aws` → `gnupg` → `git` → `tmux` → `vim` → `kitty` →
`mackup` → `vscode`. (`mail` is intentionally not in this list — it moves
with bash/zsh/secrets in Phase 3, atomically.)

Migration mechanics (repo-side, not $HOME-side):

1. `stow -D <package>` (unstow — targets become regular missing paths).
2. `git mv` the package's tracked files straight into `home/`, applying the
   `dot-` → `dot_` renames (and, where relevant, `dot-bin/*` →
   `dot_bin/executable_*`, `dot-gnupg/` → `private_dot_gnupg/`, `dot-ssh/` →
   `private_dot_ssh/`) as part of the move. `git mv` only touches files git
   already tracks — it will not adopt untracked $HOME cruft that
   accumulated next to a symlink target (e.g.
   `claude-code/dot-claude/.claude/settings.local.json`, which stays
   untracked and stays out of `home/`), and it preserves file history.
3. Convert known hardcodes to templates as each file passes through (ssh
   config hosts, opencode.json paths).
4. `chezmoi apply --dry-run` then `chezmoi apply`; `chezmoi verify` clean.
5. Remove the package from install/uninstall arrays (or mark migrated).

Per-package notes:

- **`gnupg`**: renames to `private_dot_gnupg/` — without `private_`, chezmoi
  creates the directory at 0755 and gpg refuses to operate on it.
- **`kitty`**: before the `git mv`, relocate the `kitty-search` submodule out
  of the package — `git mv` it to `third_party/kitty-kitten-search/` and
  update `.gitmodules`' path entry, making it unmanaged like the other
  submodules. Then add a `symlink_` entry under `home/dot_config/kitty/`
  pointing at that checkout, so the kitten stays live-updatable instead of
  frozen into a chezmoi copy.
- **`vim`**: the legacy `.vimrc` migrates as-is (`git mv` into `home/`) and
  stays supported going forward — see Decisions on editors.
- **`mackup`**: kept as-is. chezmoi only takes over the mackup config file
  itself; mackup's own tool and app-plist sync mechanism are untouched.
- Old per-package `.stow-local-ignore` rules (`git/`, `gnupg/`,
  `universal-wm/`) don't carry over 1:1 — consolidate their patterns into a
  single `home/.chezmoiignore` as each package migrates.

Rollback per package: `git checkout` the package dir + `stow --restow` — valid
while the package directory still exists in its old shape. Once several
packages have had their files `git mv`'d out, a full rollback means resetting
to the `stow-final` tag rather than restoring individual directories.

## Phase 3 — bash + zsh + secrets + mail (atomic batch)

These four migrate together in a single change, not one-at-a-time — zsh
sources `~/.bashrc.d/*` from the bash package, and mail's `PassCmd` reads
`~/.authinfo.gpg` from `secrets`. Splitting them across separate `chezmoi
apply` runs would leave a broken intermediate state (e.g. zsh live with no
`.bashrc.d`, or mail live with no decryptable authinfo).

- Same `unstow → git mv → chezmoi apply → verify` mechanics as Phase 2, run
  as one combined change covering `bash/`, `zsh/`, `secrets/`, and `mail/`.
- `dot_zshrc.tmpl` gains `{{ .chezmoi.homeDir }}` where needed; add a
  `~/.zshrc.local` include (currently missing — bash has one, zsh doesn't).
- `secrets/`: mechanics unchanged from today (see Decisions) — the `.gpg`
  files `git mv` into `home/` as plain files, no `encrypted_` prefix, and
  `secrets.bash`'s `op inject` step plus the GPG fallback keep doing the
  decryption at shell startup, exactly as before.
- `claude-code/`, `opencode/`: template the absolute paths
  (`{{ .chezmoi.homeDir }}/Documents/Code/...`), closing the fresh-clone gaps
  found in the review.

## Phase 4 — Bootstrap scripts replace ./install

- `run_onchange_darwin-packages.sh.tmpl`: `brew bundle --file` on the two
  Brewfiles. chezmoi only re-runs a `run_onchange_` script when the
  **rendered script's own hash** changes — shelling out to
  `homebrew/Brewfile.core` / `Brewfile.desktop` from outside the script is
  invisible to that hash, so editing a Brewfile alone would never re-trigger
  the run. Fix: embed each Brewfile's content hash directly in the rendered
  script, e.g. a comment line per file —
  `# Brewfile.core sha256:{{ include "../homebrew/Brewfile.core" | sha256sum }}`
  — so a Brewfile edit changes the rendered script and re-arms the trigger.
  If chezmoi's `include` can't reach outside the source dir (chezmoi's root
  is `home/`, and `homebrew/` sits outside it), fall back to relocating the
  Brewfiles under `home/` so `include` can see them.
- `run_once_install-oh-my-zsh.sh`: current oh-my-zsh bootstrap logic.
- `run_once_init-submodules.sh`: `git -C {{ .chezmoi.sourceDir }}/..` submodule
  init with the existing SSH→gh fallback (now also covering the relocated
  `third_party/kitty-kitten-search`).
- opencode ecosystem bootstrap becomes opt-in (`run_onchange_` guarded by a
  `.chezmoidata` flag) — review finding: it currently runs unconditionally.
- `home/dot_config/dotfiles/env.tmpl` replaces the static
  `~/.config/dotfiles/env`: it writes `DOTFILES_DIR` from the chezmoi source
  dir's parent, so the env file survives `./install`'s retirement and exists
  on fresh machines without a manual step.
- New-machine flow becomes:
  `chezmoi init --apply git@github.com:k-f-/dotfiles.git`.
- `install`/`uninstall` shrink to thin wrappers (or delete once both machines
  are migrated; keep `scripts/validate-stow.sh` only until then).

## Phase 5 — Window manager (LAST, plan-reviewed)

Packages: `aerospace`, `universal-wm` (`layouts.json`).

1. Re-verify Phase 0 landed for all three scripts: `aerospace-organize` and
   `toggle-theme` resolve `DOTFILES_DIR` via the env file (not a symlink
   walk), and `universal-wm` is now a wrapper script — not a committed
   symlink — that resolves `DOTFILES_DIR` the same way.
2. Migrate `dot-aerospace.toml` → `home/dot_aerospace.toml` (no templating
   needed — review confirmed zero machine-specific values).
3. Migrate `universal-wm/dot-config/universal-wm/layouts.json` →
   `home/dot_config/universal-wm/layouts.json`.
4. `chezmoi apply`, then: reload aerospace config, run service-mode `s` and
   `o`, confirm layouts apply and `/tmp/aerospace-organize.log` is clean.
5. Keep the stow package dirs in git for one release as rollback.

## Post-migration

- Add `chezmoi verify` as a periodic check (shell prompt hook or launchd) —
  the drift detector stow never had.
- Create a starter `home/dot_config/nvim/` config, chezmoi-managed from day
  one — `~/.config/nvim` doesn't exist on this machine yet, so there's
  nothing to "adopt"; this is new config, not a migration. The legacy
  `vim/.vimrc` stays and is kept alongside it (see Decisions).
- Editing workflow: `chezmoi edit <file>` or edit in `home/` + `chezmoi apply`;
  never `chezmoi re-add` on templated files (destroys templating — use
  `chezmoi merge`).
- **mac mini**: stays on stow, pinned at the `stow-final` tag, as the
  rollback reference for this migration. It must not `git pull` past that
  tag until its own migration is scheduled — once packages move repo-side
  into `home/`, the mini's stow symlinks (still pointing at the old
  package-dir paths) would dangle against the restructured tree.

## Decisions

Plan-reviewed 2026-07-14. These resolve the open questions from the original
draft and fold in the corrections found during review.

1. **Rollout**: the MacBook migrates fully now, through Phases 0-5 above. The
   mac mini stays on stow as the rollback reference and is not migrated in
   this pass. Critical constraint: once packages move into `home/`, the mini
   must not `git pull` until its own migration — its stow symlinks would
   dangle against the restructured repo. The pre-migration commit is tagged
   `stow-final` (created in Phase 1, step 1), the mini's safe pin until then.
2. **mackup**: kept as-is. Only its config file migrates into `home/`; the
   tool itself and its app-plist sync mechanism are untouched.
3. **Editors**: `~/.config/nvim` does not exist on this machine — Post-
   migration creates a starter nvim config from scratch, chezmoi-managed from
   the start. The legacy `.vimrc` is kept alongside it, not retired.
4. **Secrets**: keep the runtime-injection model (`op inject` at shell
   startup + GPG fallback), unchanged. chezmoi deploys the existing `.gpg`
   files as ordinary files, not via `encrypted_` or `onepasswordRead` — they
   are already ciphertext at rest. This avoids putting plaintext secret
   values into chezmoi's rendered target state, and sidesteps the fact that
   `dot-mbsync-fastmail.gpg` is AES256-symmetric while the rest are
   recipient-encrypted (one repo-wide chezmoi `encryption` config can't span
   both).
