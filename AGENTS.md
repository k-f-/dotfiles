# AGENTS.md

chezmoi-managed dotfiles for two machines: a MacBook (`kef-mbp`) and a Mac mini
(`macmini`). Shell, editor, terminal, Claude Code config, and small tools in
`~/.bin`.

<!-- Short on purpose. README.md holds 414 lines of detail. This carries what
     an agent gets wrong unprompted; nothing derivable by looking. -->

## This repo is public

Check before every push. Generated Claude Code config is the usual leak: the
`autoMode` block in `dot_claude/settings.json` is derived from the environment
and has held machine paths and org detail. `gitleaks protect --staged` catches
credentials but not that.

Secrets live in gpg files (`dot_secrets-env.gpg`, `dot_authinfo.gpg`) and are
committed encrypted. Never add a plaintext one.

## Layout

**The source root is `home/`, not the repo root.** `.chezmoiroot` says so.
Everything outside `home/` is documentation, submodules and installers, which
is why this file and its `CLAUDE.md` symlink sit at the root: chezmoi never
sees them, so they are never installed into `~`.

chezmoi name prefixes, which are the mapping and not decoration:

| Prefix | Becomes |
| -------- | --------- |
| `dot_foo` | `~/.foo` |
| `executable_foo` | `~/foo`, mode +x |
| `private_dot_ssh/` | `~/.ssh/`, mode 0700 |
| `foo.tmpl` | templated, `.tmpl` dropped |
| `run_once_*`, `run_onchange_*` | scripts chezmoi runs, not installed files |

**`dot_bin` maps to `~/.bin`, not `~/bin`.** Both are on PATH, only `~/.bin`
is managed. Applying to the wrong one silently does nothing.

## Per-machine gates

Two conditions, both real:

```gotemplate
{{ if eq .chezmoi.hostname "macmini" }}   # mini only
{{ if default false .desktop }}            # from [data] in chezmoi.toml
```

`desktop` is `true` on the MacBook and `false` on the mini. The mini-only
blocks carry things the MacBook must not get: the `nas` ssh host, and the
`url.insteadOf` rewrite that routes git over HTTPS because the mini has no
`id_ed25519`.

## Anti-patterns

- **Do not edit the installed file.** Edit the source under `home/` and apply.
  A change made in `~/.zshrc` is lost on the next apply. Use `chezmoi re-add`
  to pull an already-made change back into the source.
- **Do not `chezmoi apply` blind.** Run `chezmoi diff` first. A file modified
  in both source and destination shows as `MM` and apply stops to ask, which
  fails outright in a non-interactive session with "could not open a new TTY".
  Render it with `chezmoi cat` and install that instead.
- **Do not assume the other machine sees your edit yet.** `~/Documents/Code` is
  iCloud-synced, so a source change takes about a minute to arrive. A
  `chezmoi apply` on the mini straight after an edit here reads the old file.
- **Do not rewrite `settings.json` with a plain `json.dump`.** It escapes
  non-ASCII, which produces a large spurious diff. Pass `ensure_ascii=False`.
- **Do not add a rule to `dot_claude/CLAUDE.md` that must always hold.** That
  is a guidance file and drifts. Hooks in `settings.json` are the enforcement
  layer; eight hook commands across seven events are wired.

## Commands

```bash
chezmoi diff                      # always first
chezmoi apply ~/.zshrc            # one path at a time
chezmoi cat ~/.claude/settings.json   # render without installing
chezmoi re-add ~/.zshrc           # pull a live edit back into the source
chezmoi source-path               # confirm which source dir is active
```

The mini has pointed at a stale source directory before. `source-path` should
print `/Users/kef/Documents/Code/dotfiles/home` on both machines.
