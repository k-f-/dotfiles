=== ISSUE #1 ===
title:	Install on machine with existing symlinks.
state:	OPEN
author:	k-f-
labels:	
comments:	0
assignees:	
projects:	
milestone:	
number:	1
--
kef@kef-macmini in ~/.dots (main) 
 ./install --verbose
╔═══════════════════════════════════════╗
║     Dotfiles Installation Script      ║
╚═══════════════════════════════════════╝

==> Detected OS: macos
✓ GNU Stow is installed

==> Installing packages for macos...
  Running: brew bundle --file=/Users/kef/.dots/homebrew/Brewfile
Using d12frosted/emacs-plus
Using felixkratz/formulae
Using homebrew/bundle
Using homebrew/services
Using koekeishiya/formulae
Using nikitabobko/tap
==> Downloading https://formulae.brew.sh/api/formula.jws.json
################################################################################################################################################################################################ 100.0%
==> Downloading https://formulae.brew.sh/api/formula_tap_migrations.jws.json
################################################################################################################################################################################################ 100.0%
Installing atomicparsley
Error: unknown or unsupported macOS version: :sequoia
! Some Homebrew packages failed to install
✓ Homebrew packages processed

==> Installing dotfiles...
  Packages to install: bash git vim zsh aerospace doom emacs gnupg kitty mail secrets sketchybar skhd ssh x-windows yabai youtube-dl
  Stowing bash...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "bash"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package bash...
. not protected
Stowing contents of .dots/bash (cwd=/Users/kef)
  => .dots/bash
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: dot-bashrc => .bashrc
Stowing .dots / bash / .bashrc
  => .dots/bash/dot-bashrc
  is_a_link(.bashrc)
  link_task_action(.bashrc): no task
  is_a_link(.bashrc): is a real link
    parent_link_scheduled_for_removal(.bashrc): prefix .bashrc
    parent_link_scheduled_for_removal(.bashrc): returning false
  link_task_action(.bashrc): no task
  read_a_link(.bashrc): real link
  Evaluate existing link: .bashrc => Dropbox/Code/dotfiles/bash/.bashrc
  is path Dropbox/Code/dotfiles/bash/.bashrc owned by stow?
    no - either Dropbox/Code/dotfiles/bash/.bashrc not under .dots or vice-versa
CONFLICT when stowing bash: existing target is not owned by stow: .bashrc
  Using built-in ignore list
  Adjusting: dot-bashrc.d => .bashrc.d
Stowing .dots / bash / .bashrc.d
  => .dots/bash/dot-bashrc.d
  is_a_link(.bashrc.d)
  link_task_action(.bashrc.d): no task
  is_a_link(.bashrc.d): is a real link
    parent_link_scheduled_for_removal(.bashrc.d): prefix .bashrc.d
    parent_link_scheduled_for_removal(.bashrc.d): returning false
  link_task_action(.bashrc.d): no task
  read_a_link(.bashrc.d): real link
  Evaluate existing link: .bashrc.d => Dropbox/Code/dotfiles/bash/.bashrc.d
  is path Dropbox/Code/dotfiles/bash/.bashrc.d owned by stow?
    no - either Dropbox/Code/dotfiles/bash/.bashrc.d not under .dots or vice-versa
CONFLICT when stowing bash: existing target is not owned by stow: .bashrc.d
  Using built-in ignore list
  Adjusting: dot-bin => .bin
Stowing .dots / bash / .bin
  => .dots/bash/dot-bin
  is_a_link(.bin)
  link_task_action(.bin): no task
  is_a_link(.bin): is a real link
    parent_link_scheduled_for_removal(.bin): prefix .bin
    parent_link_scheduled_for_removal(.bin): returning false
  link_task_action(.bin): no task
  read_a_link(.bin): real link
  Evaluate existing link: .bin => Dropbox/Code/dotfiles/bash/.bin
  is path Dropbox/Code/dotfiles/bash/.bin owned by stow?
    no - either Dropbox/Code/dotfiles/bash/.bin not under .dots or vice-versa
CONFLICT when stowing bash: existing target is not owned by stow: .bin
  Using built-in ignore list
  Adjusting: dot-profile => .profile
Stowing .dots / bash / .profile
  => .dots/bash/dot-profile
  link_task_action(.dots/bash/dot-profile): no task
  read_a_link(.dots/bash/dot-profile): real link
  is_a_link(.profile)
  link_task_action(.profile): no task
  is_a_link(.profile): is a real link
    parent_link_scheduled_for_removal(.profile): prefix .profile
    parent_link_scheduled_for_removal(.profile): returning false
  link_task_action(.profile): no task
  read_a_link(.profile): real link
  Evaluate existing link: .profile => Dropbox/Code/dotfiles/bash/.profile
  is path Dropbox/Code/dotfiles/bash/.profile owned by stow?
    no - either Dropbox/Code/dotfiles/bash/.profile not under .dots or vice-versa
CONFLICT when stowing bash: existing target is not owned by stow: .profile
Planning stow of package bash... done
cwd restored to /Users/kef/.dots
WARNING! stowing bash would cause conflicts:
  * existing target is not owned by stow: .bashrc
  * existing target is not owned by stow: .bashrc.d
  * existing target is not owned by stow: .bin
  * existing target is not owned by stow: .profile
All operations aborted.
✗ Failed to stow bash
  Stowing git...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "git"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package git...
. not protected
Stowing contents of .dots/git (cwd=/Users/kef)
  => .dots/git
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Adjusting: .gitignore => .gitignore
Stowing .dots / git / .gitignore
  => .dots/git/.gitignore
  is_a_link(.gitignore)
  link_task_action(.gitignore): no task
  is_a_link(.gitignore): is a real link
    parent_link_scheduled_for_removal(.gitignore): prefix .gitignore
    parent_link_scheduled_for_removal(.gitignore): returning false
  link_task_action(.gitignore): no task
  read_a_link(.gitignore): real link
  Evaluate existing link: .gitignore => Dropbox/Code/dotfiles/git/.gitignore
  is path Dropbox/Code/dotfiles/git/.gitignore owned by stow?
    no - either Dropbox/Code/dotfiles/git/.gitignore not under .dots or vice-versa
CONFLICT when stowing git: existing target is not owned by stow: .gitignore
    Using memoized regexps from .dots/git/.stow-local-ignore
  Ignoring path /.stow-local-ignore
    Using memoized regexps from .dots/git/.stow-local-ignore
  Adjusting: .gitmessage => .gitmessage
Stowing .dots / git / .gitmessage
  => .dots/git/.gitmessage
  is_a_link(.gitmessage)
  link_task_action(.gitmessage): no task
  is_a_link(.gitmessage): is a real link
    parent_link_scheduled_for_removal(.gitmessage): prefix .gitmessage
    parent_link_scheduled_for_removal(.gitmessage): returning false
  link_task_action(.gitmessage): no task
  read_a_link(.gitmessage): real link
  Evaluate existing link: .gitmessage => Dropbox/Code/dotfiles/git/.gitmessage
  is path Dropbox/Code/dotfiles/git/.gitmessage owned by stow?
    no - either Dropbox/Code/dotfiles/git/.gitmessage not under .dots or vice-versa
CONFLICT when stowing git: existing target is not owned by stow: .gitmessage
    Using memoized regexps from .dots/git/.stow-local-ignore
  Adjusting: .gitconfig => .gitconfig
Stowing .dots / git / .gitconfig
  => .dots/git/.gitconfig
  is_a_link(.gitconfig)
  link_task_action(.gitconfig): no task
  is_a_link(.gitconfig): is a real link
    parent_link_scheduled_for_removal(.gitconfig): prefix .gitconfig
    parent_link_scheduled_for_removal(.gitconfig): returning false
  link_task_action(.gitconfig): no task
  read_a_link(.gitconfig): real link
  Evaluate existing link: .gitconfig => Dropbox/Code/dotfiles/git/.gitconfig
  is path Dropbox/Code/dotfiles/git/.gitconfig owned by stow?
    no - either Dropbox/Code/dotfiles/git/.gitconfig not under .dots or vice-versa
CONFLICT when stowing git: existing target is not owned by stow: .gitconfig
Planning stow of package git... done
cwd restored to /Users/kef/.dots
WARNING! stowing git would cause conflicts:
  * existing target is not owned by stow: .gitconfig
  * existing target is not owned by stow: .gitignore
  * existing target is not owned by stow: .gitmessage
All operations aborted.
✗ Failed to stow git
  Stowing vim...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "vim"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package vim...
. not protected
Stowing contents of .dots/vim (cwd=/Users/kef)
  => .dots/vim
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .vimrc => .vimrc
Stowing .dots / vim / .vimrc
  => .dots/vim/.vimrc
  is_a_link(.vimrc)
  link_task_action(.vimrc): no task
  is_a_link(.vimrc): is a real link
    parent_link_scheduled_for_removal(.vimrc): prefix .vimrc
    parent_link_scheduled_for_removal(.vimrc): returning false
  link_task_action(.vimrc): no task
  read_a_link(.vimrc): real link
  Evaluate existing link: .vimrc => Dropbox/Code/dotfiles/vim/.vimrc
  is path Dropbox/Code/dotfiles/vim/.vimrc owned by stow?
    no - either Dropbox/Code/dotfiles/vim/.vimrc not under .dots or vice-versa
CONFLICT when stowing vim: existing target is not owned by stow: .vimrc
Planning stow of package vim... done
cwd restored to /Users/kef/.dots
WARNING! stowing vim would cause conflicts:
  * existing target is not owned by stow: .vimrc
All operations aborted.
✗ Failed to stow vim
  Stowing zsh...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "zsh"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package zsh...
. not protected
Stowing contents of .dots/zsh (cwd=/Users/kef)
  => .dots/zsh
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .zshrc => .zshrc
Stowing .dots / zsh / .zshrc
  => .dots/zsh/.zshrc
  is_a_link(.zshrc)
  link_task_action(.zshrc): no task
  is_a_link(.zshrc): is a real link
    parent_link_scheduled_for_removal(.zshrc): prefix .zshrc
    parent_link_scheduled_for_removal(.zshrc): returning false
  link_task_action(.zshrc): no task
  read_a_link(.zshrc): real link
  Evaluate existing link: .zshrc => Dropbox/Code/dotfiles/zsh/.zshrc
  is path Dropbox/Code/dotfiles/zsh/.zshrc owned by stow?
    no - either Dropbox/Code/dotfiles/zsh/.zshrc not under .dots or vice-versa
CONFLICT when stowing zsh: existing target is not owned by stow: .zshrc
  Using built-in ignore list
  Adjusting: .zprofile => .zprofile
Stowing .dots / zsh / .zprofile
  => .dots/zsh/.zprofile
  is_a_link(.zprofile)
  link_task_action(.zprofile): no task
  is_a_link(.zprofile): returning 0
  is_a_node(.zprofile)
  link_task_action(.zprofile): no task
  dir_task_action(.zprofile): no task
    parent_link_scheduled_for_removal(.zprofile): prefix .zprofile
    parent_link_scheduled_for_removal(.zprofile): returning false
  is_a_node(.zprofile): returning false
LINK: .zprofile => .dots/zsh/.zprofile
  Using built-in ignore list
  Adjusting: KEYBINDINGS.md => KEYBINDINGS.md
Stowing .dots / zsh / KEYBINDINGS.md
  => .dots/zsh/KEYBINDINGS.md
  is_a_link(KEYBINDINGS.md)
  link_task_action(KEYBINDINGS.md): no task
  is_a_link(KEYBINDINGS.md): returning 0
  is_a_node(KEYBINDINGS.md)
  link_task_action(KEYBINDINGS.md): no task
  dir_task_action(KEYBINDINGS.md): no task
    parent_link_scheduled_for_removal(KEYBINDINGS.md): prefix KEYBINDINGS.md
    parent_link_scheduled_for_removal(KEYBINDINGS.md): returning false
  is_a_node(KEYBINDINGS.md): returning false
LINK: KEYBINDINGS.md => .dots/zsh/KEYBINDINGS.md
Planning stow of package zsh... done
cwd restored to /Users/kef/.dots
WARNING! stowing zsh would cause conflicts:
  * existing target is not owned by stow: .zshrc
All operations aborted.
✗ Failed to stow zsh
  Stowing aerospace...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "aerospace"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package aerospace...
. not protected
Stowing contents of .dots/aerospace (cwd=/Users/kef)
  => .dots/aerospace
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: dot-aerospace.toml => .aerospace.toml
Stowing .dots / aerospace / .aerospace.toml
  => .dots/aerospace/dot-aerospace.toml
  is_a_link(.aerospace.toml)
  link_task_action(.aerospace.toml): no task
  is_a_link(.aerospace.toml): returning 0
  is_a_node(.aerospace.toml)
  link_task_action(.aerospace.toml): no task
  dir_task_action(.aerospace.toml): no task
    parent_link_scheduled_for_removal(.aerospace.toml): prefix .aerospace.toml
    parent_link_scheduled_for_removal(.aerospace.toml): returning false
  is_a_node(.aerospace.toml): returning false
LINK: .aerospace.toml => .dots/aerospace/dot-aerospace.toml
  Ignoring path README.md due to --ignore=(?^:^README.*\z)
Planning stow of package aerospace... done
cwd restored to /Users/kef/.dots
Processing tasks...
cwd now /Users/kef
cwd restored to /Users/kef/.dots
Processing tasks... done
✓ Stowed aerospace
  Stowing doom...
  Backing up: /Users/kef/.config/doom/packages.el
  Backing up: /Users/kef/.config/doom/config.el
  Backing up: /Users/kef/.config/doom/init.el
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "doom"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package doom...
. not protected
Stowing contents of .dots/doom (cwd=/Users/kef)
  => .dots/doom
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .config => .config
Stowing .dots / doom / .config
  => .dots/doom/.config
  is_a_link(.config)
  link_task_action(.config): no task
  is_a_link(.config): returning 0
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Evaluate existing node: .config
  is_a_dir(.config)
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_dir(.config): real dir
.config not protected
Stowing contents of .dots/doom/.config (cwd=/Users/kef)
  => ../.dots/doom/.config
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Using built-in ignore list
  Adjusting: .config/doom => .config/doom
Stowing .dots / doom / .config/doom
  => ../.dots/doom/.config/doom
  is_a_link(.config/doom)
  link_task_action(.config/doom): no task
  is_a_link(.config/doom): is a real link
    parent_link_scheduled_for_removal(.config/doom): prefix .config
    parent_link_scheduled_for_removal(.config/doom): prefix .config/doom
    parent_link_scheduled_for_removal(.config/doom): returning false
  link_task_action(.config/doom): no task
  read_a_link(.config/doom): real link
  Evaluate existing link: .config/doom => ../Dropbox/Code/dotfiles/doom/.config/doom
  is path Dropbox/Code/dotfiles/doom/.config/doom owned by stow?
    no - either Dropbox/Code/dotfiles/doom/.config/doom not under .dots or vice-versa
CONFLICT when stowing doom: existing target is not owned by stow: .config/doom
Planning stow of package doom... done
cwd restored to /Users/kef/.dots
WARNING! stowing doom would cause conflicts:
  * existing target is not owned by stow: .config/doom
All operations aborted.
✗ Failed to stow doom
  Stowing emacs...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "emacs"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package emacs...
. not protected
Stowing contents of .dots/emacs (cwd=/Users/kef)
  => .dots/emacs
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Ignoring path README.md due to --ignore=(?^:^README.*\z)
Planning stow of package emacs... done
cwd restored to /Users/kef/.dots
Processing tasks...
✓ Stowed emacs
  Stowing gnupg...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "gnupg"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package gnupg...
. not protected
Stowing contents of .dots/gnupg (cwd=/Users/kef)
  => .dots/gnupg
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: dot-gnupg => .gnupg
Stowing .dots / gnupg / .gnupg
  => .dots/gnupg/dot-gnupg
  is_a_link(.gnupg)
  link_task_action(.gnupg): no task
  is_a_link(.gnupg): returning 0
  is_a_node(.gnupg)
  link_task_action(.gnupg): no task
  dir_task_action(.gnupg): no task
    parent_link_scheduled_for_removal(.gnupg): prefix .gnupg
    parent_link_scheduled_for_removal(.gnupg): returning false
  is_a_node(.gnupg): really exists
  Evaluate existing node: .gnupg
  is_a_dir(.gnupg)
  dir_task_action(.gnupg): no task
    parent_link_scheduled_for_removal(.gnupg): prefix .gnupg
    parent_link_scheduled_for_removal(.gnupg): returning false
  is_a_dir(.gnupg): real dir
.gnupg not protected
Stowing contents of .dots/gnupg/.gnupg (cwd=/Users/kef)
  => ../.dots/gnupg/dot-gnupg
stow: ERROR: stow_contents() called with non-directory path: .dots/gnupg/.gnupg
✗ Failed to stow gnupg
  Stowing kitty...
  Backing up: /Users/kef/.config/kitty/kitty.conf
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "kitty"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package kitty...
. not protected
Stowing contents of .dots/kitty (cwd=/Users/kef)
  => .dots/kitty
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .config => .config
Stowing .dots / kitty / .config
  => .dots/kitty/.config
  is_a_link(.config)
  link_task_action(.config): no task
  is_a_link(.config): returning 0
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Evaluate existing node: .config
  is_a_dir(.config)
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_dir(.config): real dir
.config not protected
Stowing contents of .dots/kitty/.config (cwd=/Users/kef)
  => ../.dots/kitty/.config
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Using built-in ignore list
  Adjusting: .config/kitty => .config/kitty
Stowing .dots / kitty / .config/kitty
  => ../.dots/kitty/.config/kitty
  is_a_link(.config/kitty)
  link_task_action(.config/kitty): no task
  is_a_link(.config/kitty): is a real link
    parent_link_scheduled_for_removal(.config/kitty): prefix .config
    parent_link_scheduled_for_removal(.config/kitty): prefix .config/kitty
    parent_link_scheduled_for_removal(.config/kitty): returning false
  link_task_action(.config/kitty): no task
  read_a_link(.config/kitty): real link
  Evaluate existing link: .config/kitty => ../Library/CloudStorage/Dropbox/Code/dotfiles/kitty/.config/kitty
  is path Library/CloudStorage/Dropbox/Code/dotfiles/kitty/.config/kitty owned by stow?
    no - either Library/CloudStorage/Dropbox/Code/dotfiles/kitty/.config/kitty not under .dots or vice-versa
CONFLICT when stowing kitty: existing target is not owned by stow: .config/kitty
Planning stow of package kitty... done
cwd restored to /Users/kef/.dots
WARNING! stowing kitty would cause conflicts:
  * existing target is not owned by stow: .config/kitty
All operations aborted.
✗ Failed to stow kitty
  Stowing mail...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "mail"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package mail...
. not protected
Stowing contents of .dots/mail (cwd=/Users/kef)
  => .dots/mail
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .mbsyncrc => .mbsyncrc
Stowing .dots / mail / .mbsyncrc
  => .dots/mail/.mbsyncrc
  is_a_link(.mbsyncrc)
  link_task_action(.mbsyncrc): no task
  is_a_link(.mbsyncrc): is a real link
    parent_link_scheduled_for_removal(.mbsyncrc): prefix .mbsyncrc
    parent_link_scheduled_for_removal(.mbsyncrc): returning false
  link_task_action(.mbsyncrc): no task
  read_a_link(.mbsyncrc): real link
  Evaluate existing link: .mbsyncrc => Dropbox/Code/dotfiles/mail/.mbsyncrc
  is path Dropbox/Code/dotfiles/mail/.mbsyncrc owned by stow?
    no - either Dropbox/Code/dotfiles/mail/.mbsyncrc not under .dots or vice-versa
CONFLICT when stowing mail: existing target is not owned by stow: .mbsyncrc
Planning stow of package mail... done
cwd restored to /Users/kef/.dots
WARNING! stowing mail would cause conflicts:
  * existing target is not owned by stow: .mbsyncrc
All operations aborted.
✗ Failed to stow mail
  Stowing secrets...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "secrets"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package secrets...
. not protected
Stowing contents of .dots/secrets (cwd=/Users/kef)
  => .dots/secrets
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .authinfo.gpg => .authinfo.gpg
Stowing .dots / secrets / .authinfo.gpg
  => .dots/secrets/.authinfo.gpg
  is_a_link(.authinfo.gpg)
  link_task_action(.authinfo.gpg): no task
  is_a_link(.authinfo.gpg): is a real link
    parent_link_scheduled_for_removal(.authinfo.gpg): prefix .authinfo.gpg
    parent_link_scheduled_for_removal(.authinfo.gpg): returning false
  link_task_action(.authinfo.gpg): no task
  read_a_link(.authinfo.gpg): real link
  Evaluate existing link: .authinfo.gpg => Dropbox/Code/dotfiles/secrets/.authinfo.gpg
  is path Dropbox/Code/dotfiles/secrets/.authinfo.gpg owned by stow?
    no - either Dropbox/Code/dotfiles/secrets/.authinfo.gpg not under .dots or vice-versa
CONFLICT when stowing secrets: existing target is not owned by stow: .authinfo.gpg
  Using built-in ignore list
  Adjusting: .mbsync-fastmail.gpg => .mbsync-fastmail.gpg
Stowing .dots / secrets / .mbsync-fastmail.gpg
  => .dots/secrets/.mbsync-fastmail.gpg
  is_a_link(.mbsync-fastmail.gpg)
  link_task_action(.mbsync-fastmail.gpg): no task
  is_a_link(.mbsync-fastmail.gpg): is a real link
    parent_link_scheduled_for_removal(.mbsync-fastmail.gpg): prefix .mbsync-fastmail.gpg
    parent_link_scheduled_for_removal(.mbsync-fastmail.gpg): returning false
  link_task_action(.mbsync-fastmail.gpg): no task
  read_a_link(.mbsync-fastmail.gpg): real link
  Evaluate existing link: .mbsync-fastmail.gpg => Dropbox/Code/dotfiles/secrets/.mbsync-fastmail.gpg
  is path Dropbox/Code/dotfiles/secrets/.mbsync-fastmail.gpg owned by stow?
    no - either Dropbox/Code/dotfiles/secrets/.mbsync-fastmail.gpg not under .dots or vice-versa
CONFLICT when stowing secrets: existing target is not owned by stow: .mbsync-fastmail.gpg
Planning stow of package secrets... done
cwd restored to /Users/kef/.dots
WARNING! stowing secrets would cause conflicts:
  * existing target is not owned by stow: .authinfo.gpg
  * existing target is not owned by stow: .mbsync-fastmail.gpg
All operations aborted.
✗ Failed to stow secrets
  Stowing sketchybar...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "sketchybar"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package sketchybar...
. not protected
Stowing contents of .dots/sketchybar (cwd=/Users/kef)
  => .dots/sketchybar
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .config => .config
Stowing .dots / sketchybar / .config
  => .dots/sketchybar/.config
  is_a_link(.config)
  link_task_action(.config): no task
  is_a_link(.config): returning 0
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Evaluate existing node: .config
  is_a_dir(.config)
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_dir(.config): real dir
.config not protected
Stowing contents of .dots/sketchybar/.config (cwd=/Users/kef)
  => ../.dots/sketchybar/.config
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Using built-in ignore list
  Adjusting: .config/sketchybar => .config/sketchybar
Stowing .dots / sketchybar / .config/sketchybar
  => ../.dots/sketchybar/.config/sketchybar
  is_a_link(.config/sketchybar)
  link_task_action(.config/sketchybar): no task
  is_a_link(.config/sketchybar): returning 0
  is_a_node(.config/sketchybar)
  link_task_action(.config/sketchybar): no task
  dir_task_action(.config/sketchybar): no task
    parent_link_scheduled_for_removal(.config/sketchybar): prefix .config
    parent_link_scheduled_for_removal(.config/sketchybar): prefix .config/sketchybar
    parent_link_scheduled_for_removal(.config/sketchybar): returning false
  is_a_node(.config/sketchybar): returning false
LINK: .config/sketchybar => ../.dots/sketchybar/.config/sketchybar
Planning stow of package sketchybar... done
cwd restored to /Users/kef/.dots
Processing tasks...
cwd now /Users/kef
cwd restored to /Users/kef/.dots
Processing tasks... done
✓ Stowed sketchybar
  Stowing skhd...
  Backing up: /Users/kef/.config/skhd/skhdrc
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "skhd"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package skhd...
. not protected
Stowing contents of .dots/skhd (cwd=/Users/kef)
  => .dots/skhd
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .config => .config
Stowing .dots / skhd / .config
  => .dots/skhd/.config
  is_a_link(.config)
  link_task_action(.config): no task
  is_a_link(.config): returning 0
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Evaluate existing node: .config
  is_a_dir(.config)
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_dir(.config): real dir
.config not protected
Stowing contents of .dots/skhd/.config (cwd=/Users/kef)
  => ../.dots/skhd/.config
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Using built-in ignore list
  Adjusting: .config/skhd => .config/skhd
Stowing .dots / skhd / .config/skhd
  => ../.dots/skhd/.config/skhd
  is_a_link(.config/skhd)
  link_task_action(.config/skhd): no task
  is_a_link(.config/skhd): is a real link
    parent_link_scheduled_for_removal(.config/skhd): prefix .config
    parent_link_scheduled_for_removal(.config/skhd): prefix .config/skhd
    parent_link_scheduled_for_removal(.config/skhd): returning false
  link_task_action(.config/skhd): no task
  read_a_link(.config/skhd): real link
  Evaluate existing link: .config/skhd => ../Library/CloudStorage/Dropbox/Code/dotfiles/skhd/.config/skhd
  is path Library/CloudStorage/Dropbox/Code/dotfiles/skhd/.config/skhd owned by stow?
    no - either Library/CloudStorage/Dropbox/Code/dotfiles/skhd/.config/skhd not under .dots or vice-versa
CONFLICT when stowing skhd: existing target is not owned by stow: .config/skhd
Planning stow of package skhd... done
cwd restored to /Users/kef/.dots
WARNING! stowing skhd would cause conflicts:
  * existing target is not owned by stow: .config/skhd
All operations aborted.
✗ Failed to stow skhd
  Stowing ssh...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "ssh"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package ssh...
. not protected
Stowing contents of .dots/ssh (cwd=/Users/kef)
  => .dots/ssh
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .ssh => .ssh
Stowing .dots / ssh / .ssh
  => .dots/ssh/.ssh
  is_a_link(.ssh)
  link_task_action(.ssh): no task
  is_a_link(.ssh): returning 0
  is_a_node(.ssh)
  link_task_action(.ssh): no task
  dir_task_action(.ssh): no task
    parent_link_scheduled_for_removal(.ssh): prefix .ssh
    parent_link_scheduled_for_removal(.ssh): returning false
  is_a_node(.ssh): really exists
  Evaluate existing node: .ssh
  is_a_dir(.ssh)
  dir_task_action(.ssh): no task
    parent_link_scheduled_for_removal(.ssh): prefix .ssh
    parent_link_scheduled_for_removal(.ssh): returning false
  is_a_dir(.ssh): real dir
.ssh not protected
Stowing contents of .dots/ssh/.ssh (cwd=/Users/kef)
  => ../.dots/ssh/.ssh
  is_a_node(.ssh)
  link_task_action(.ssh): no task
  dir_task_action(.ssh): no task
    parent_link_scheduled_for_removal(.ssh): prefix .ssh
    parent_link_scheduled_for_removal(.ssh): returning false
  is_a_node(.ssh): really exists
  Using built-in ignore list
  Adjusting: .ssh/config => .ssh/config
Stowing .dots / ssh / .ssh/config
  => ../.dots/ssh/.ssh/config
  is_a_link(.ssh/config)
  link_task_action(.ssh/config): no task
  is_a_link(.ssh/config): is a real link
    parent_link_scheduled_for_removal(.ssh/config): prefix .ssh
    parent_link_scheduled_for_removal(.ssh/config): prefix .ssh/config
    parent_link_scheduled_for_removal(.ssh/config): returning false
  link_task_action(.ssh/config): no task
  read_a_link(.ssh/config): real link
  Evaluate existing link: .ssh/config => ../Dropbox/Code/dotfiles/ssh/.ssh/config
  is path Dropbox/Code/dotfiles/ssh/.ssh/config owned by stow?
    no - either Dropbox/Code/dotfiles/ssh/.ssh/config not under .dots or vice-versa
CONFLICT when stowing ssh: existing target is not owned by stow: .ssh/config
Planning stow of package ssh... done
cwd restored to /Users/kef/.dots
WARNING! stowing ssh would cause conflicts:
  * existing target is not owned by stow: .ssh/config
All operations aborted.
✗ Failed to stow ssh
  Stowing x-windows...
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "x-windows"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package x-windows...
. not protected
Stowing contents of .dots/x-windows (cwd=/Users/kef)
  => .dots/x-windows
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .Xresources => .Xresources
Stowing .dots / x-windows / .Xresources
  => .dots/x-windows/.Xresources
  is_a_link(.Xresources)
  link_task_action(.Xresources): no task
  is_a_link(.Xresources): is a real link
    parent_link_scheduled_for_removal(.Xresources): prefix .Xresources
    parent_link_scheduled_for_removal(.Xresources): returning false
  link_task_action(.Xresources): no task
  read_a_link(.Xresources): real link
  Evaluate existing link: .Xresources => Dropbox/Code/dotfiles/x-windows/.Xresources
  is path Dropbox/Code/dotfiles/x-windows/.Xresources owned by stow?
    no - either Dropbox/Code/dotfiles/x-windows/.Xresources not under .dots or vice-versa
CONFLICT when stowing x-windows: existing target is not owned by stow: .Xresources
  Using built-in ignore list
  Adjusting: .xinitrc => .xinitrc
Stowing .dots / x-windows / .xinitrc
  => .dots/x-windows/.xinitrc
  is_a_link(.xinitrc)
  link_task_action(.xinitrc): no task
  is_a_link(.xinitrc): is a real link
    parent_link_scheduled_for_removal(.xinitrc): prefix .xinitrc
    parent_link_scheduled_for_removal(.xinitrc): returning false
  link_task_action(.xinitrc): no task
  read_a_link(.xinitrc): real link
  Evaluate existing link: .xinitrc => Dropbox/Code/dotfiles/x-windows/.xinitrc
  is path Dropbox/Code/dotfiles/x-windows/.xinitrc owned by stow?
    no - either Dropbox/Code/dotfiles/x-windows/.xinitrc not under .dots or vice-versa
CONFLICT when stowing x-windows: existing target is not owned by stow: .xinitrc
  Using built-in ignore list
  Adjusting: .inputrc => .inputrc
Stowing .dots / x-windows / .inputrc
  => .dots/x-windows/.inputrc
  is_a_link(.inputrc)
  link_task_action(.inputrc): no task
  is_a_link(.inputrc): is a real link
    parent_link_scheduled_for_removal(.inputrc): prefix .inputrc
    parent_link_scheduled_for_removal(.inputrc): returning false
  link_task_action(.inputrc): no task
  read_a_link(.inputrc): real link
  Evaluate existing link: .inputrc => Dropbox/Code/dotfiles/x-windows/.inputrc
  is path Dropbox/Code/dotfiles/x-windows/.inputrc owned by stow?
    no - either Dropbox/Code/dotfiles/x-windows/.inputrc not under .dots or vice-versa
CONFLICT when stowing x-windows: existing target is not owned by stow: .inputrc
Planning stow of package x-windows... done
cwd restored to /Users/kef/.dots
WARNING! stowing x-windows would cause conflicts:
  * existing target is not owned by stow: .Xresources
  * existing target is not owned by stow: .inputrc
  * existing target is not owned by stow: .xinitrc
All operations aborted.
✗ Failed to stow x-windows
  Stowing yabai...
  Backing up: /Users/kef/.config/yabai/yabairc
  Running: stow --target="/Users/kef" --ignore='^README.*' --dotfiles --verbose=4 "yabai"
stow dir is /Users/kef/.dots
stow dir path relative to target /Users/kef is .dots
cwd now /Users/kef
cwd restored to /Users/kef/.dots
cwd now /Users/kef
Planning stow of package yabai...
. not protected
Stowing contents of .dots/yabai (cwd=/Users/kef)
  => .dots/yabai
  is_a_node(.)
  link_task_action(.): no task
  dir_task_action(.): no task
    parent_link_scheduled_for_removal(.): prefix 
    parent_link_scheduled_for_removal(.): returning false
  is_a_node(.): really exists
  Using built-in ignore list
  Adjusting: .config => .config
Stowing .dots / yabai / .config
  => .dots/yabai/.config
  is_a_link(.config)
  link_task_action(.config): no task
  is_a_link(.config): returning 0
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Evaluate existing node: .config
  is_a_dir(.config)
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_dir(.config): real dir
.config not protected
Stowing contents of .dots/yabai/.config (cwd=/Users/kef)
  => ../.dots/yabai/.config
  is_a_node(.config)
  link_task_action(.config): no task
  dir_task_action(.config): no task
    parent_link_scheduled_for_removal(.config): prefix .config
    parent_link_scheduled_for_removal(.config): returning false
  is_a_node(.config): really exists
  Using built-in ignore list
  Adjusting: .config/yabai => .config/yabai
Stowing .dots / yabai / .config/yabai
  => ../.dots/yabai/.config/yabai
  is_a_link(.config/yabai)
  link_task_action(.config/yabai): no task
  is_a_link(.config/yabai): is a real link
    parent_link_scheduled_for_removal(.config/yabai): prefix .config
    parent_link_scheduled_for_removal(.config/yabai): prefix .config/yabai
    parent_link_scheduled_for_removal(.config/yabai): returning false
  link_task_action(.config/yabai): no task
  read_a_link(.config/yabai): real link
  Evaluate existing link: .config/yabai => ../Library/CloudStorage/Dropbox/Code/dotfiles/yabai/.config/yabai
  is path Library/CloudStorage/Dropbox/Code/dotfiles/yabai/.config/yabai owned by stow?
    no - either Library/CloudStorage/Dropbox/Code/dotfiles/yabai/.config/yabai not under .dots or vice-versa
CONFLICT when stowing yabai: existing target is not owned by stow: .config/yabai
Planning stow of package yabai... done
cwd restored to /Users/kef/.dots
WARNING! stowing yabai would cause conflicts:
  * existing target is not owned by stow: .config/yabai
All operations aborted.
✗ Failed to stow yabai
  Stowing youtube-dl...
  Backing up: /Users/kef/.config/youtube-dl/config

=== ISSUE #2 ===
title:	OSX Install.sh
state:	OPEN
author:	k-f-
labels:	
comments:	0
assignees:	
projects:	
milestone:	
number:	2
--
Need to review all settings in install-osx.sh.

- We want symlinks as setup on kef-mbp for our iCloud Drive Documents and Downloads.
- We need to review all "default" changes in installer to see if they currently apply for later versions of OSX. Check Apple documentation.
- Is there a command line tool for cleanly uninstalling applications on mac-os? Similar to app-zapper where it removes the .app but also associated ktexts and preference panes?
- We'd like OSX to **not** automatically place periods after a doublespace. We want to write that into our new osx-install.sh version.

=== ISSUE #3 ===
title:	OSX Applications (Homebrew, AppStore, etc)
state:	OPEN
author:	k-f-
labels:	
comments:	0
assignees:	
projects:	
milestone:	
number:	3
--
- We want symlinks as setup on kef-mbp for our iCloud Drive/Documents. We'd like to have that as an option when we're on osx systems after "install" runs. There may be some other folders in $HOME which are symlinked to the odd iCloud location.
- Feature: Can we come up with a safe cleanup function? We end up in legacy systems with lots of older homebrew applications installed which have been superseded by newer replacements.

=== ISSUE #4 ===
title:	Aerospace - Configure Layouts
state:	OPEN
author:	k-f-
labels:	
comments:	0
assignees:	
projects:	
milestone:	
number:	4
--
- We're looking to create some functionality for our Aerospace config (or with a helper script) which will allow us to "capture" the window position and sizing in a given workspace.
- Sizing should be not specified in units like pixels, but instead percentage of screen, orientation and stack position. 
- As an example our Workspace2: Comms should contain Messages, Signal and Spotify. We prefer that messages be stacked vertically above Signal with the width of both being about 1/3 of the available screen. Spotify should be the leftover space on the right side, covering the other 2/3s. The splits are: Split1 - Spotify sits on the right side of the screen. Messages and Signal sit on the left side, but their height is a 50% split of the total width. In Ascii art it looks something like this:

```bash
 ________ ___________
|messages|           |
|________| Spotify.  |
| signal |           |
|________|___________|
```

- If possible, we'd like to be able to "save" a layout in a workspace.
- We'd also like to be able to 'overwrite' and 'delete' those saved settings.
- We want settings to be portable along with our dotfiles.
- We can save, overwrite and delete saved layouts with command line calls to script. later we might want to investigate using keybindings.
- As an additional feature, at aerospace launch we want to gather any windows which are currently open and position them correctly. We can use our existing "organize" script. We also want to explore if we can open the preconfigured windows that are not open (launch the applications) and organize them to their specific workspaces. This could allow us to have a functionality when we reboot the machine to "snap-back-to" our preferred layout.
- I think we have restricted our "organize" script to only use "main" display, which is acceptable, but in an ideal world if we have more than (1) display and a workspace has been shifted to that display, when we re-run organize, we should either move it back to the other display post organization (save pre-organized display location), or organize it on the display that owns the workspace.

