# Bash Configuration

Shell configuration files and scripts for bash and zsh.

## Quick Reference

### Dotfiles Access

```bash
# Open dotfiles directory in your editor
dotfiles    # or `dots` for short

# Or use AeroSpace keybinding
Alt + Shift + d    # Opens dotfiles in VS Code
```

### Aliases

See `dot-bashrc.d/aliases.bash` for all available aliases:

- `vim` → `nvim` - Use Neovim instead of Vim
- `cat` → `bat` - Syntax-highlighted file viewing
- `gs` → `git status -s` - Short git status
- `gg` → `git grep -n` - Search git repository
- `dc` → `docker-compose` - Docker Compose shorthand
- `la` → `ls -la` - List all files

### Custom Scripts (`dot-bin/`)

Scripts in `dot-bin/` are symlinked to `~/.bin/` and available in PATH:

- `em` - Smart editor launcher (VS Code → neovim → vim → emacs)
- `eem` - Emacs client launcher
- `aerospace-organize` - Organize windows into designated workspaces
- `extract` - Universal archive extractor
- `screenshot` - Screenshot utility
- `checkmail` - Check mail status
- And more...

## Structure

```
bash/
├── dot-profile              # Login shell profile
├── dot-bashrc               # Main bashrc
├── dot-bashrc.d/            # Modular configuration
│   ├── aliases.bash         # Command aliases
│   ├── exports.bash         # Environment variables
│   ├── path.bash            # PATH configuration
│   ├── prompt.bash          # Bash prompt (deprecated, use zsh)
│   ├── utils.bash           # Utility functions
│   └── variables.bash       # Shell variables
└── dot-bin/                 # User scripts (symlinked to ~/.bin/)
    ├── em                   # Editor launcher
    ├── eem                  # Emacs client
    ├── aerospace-organize   # Window organization
    └── ...                  # More scripts
```

## Installation

The bash configuration is part of the core dotfiles installation:

```bash
# From dotfiles root
./install

# Or manually with stow
stow --dotfiles bash
```

This will:
1. Symlink `dot-profile` → `~/.profile`
2. Symlink `dot-bashrc` → `~/.bashrc`
3. Symlink `dot-bashrc.d/` → `~/.bashrc.d/`
4. Symlink `dot-bin/` → `~/.bin/`

## Usage with Zsh

Even if you use zsh as your primary shell, the bash configuration is still used:

- `~/.zshrc` sources `~/.bashrc.d/` for shared configuration
- PATH, aliases, exports, and utilities work in both shells
- Scripts in `~/.bin/` are available regardless of shell

## Customization

### Adding Aliases

Edit `dot-bashrc.d/aliases.bash`:

```bash
alias myalias="command here"
```

### Adding Scripts

1. Create script in `bash/dot-bin/script-name`
2. Make it executable: `chmod +x bash/dot-bin/script-name`
3. Re-stow: `stow --restow --dotfiles bash`
4. Use anywhere: `script-name`

### PATH Configuration

Edit `dot-bashrc.d/path.bash` to add directories to PATH:

```bash
pathmunge /custom/path
```
