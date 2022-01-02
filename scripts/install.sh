#!/bin/sh

# Install all the necessary Debian packages, especially `stow`.
#./install_debian_packages.sh

cd ~/.dotfiles

stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles bash
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles emacs
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles doom
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles git
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles gnupg
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles kitty
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles mail
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles vim
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles x-windows
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles secrets 
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles youtube-dl
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles ssh
stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles zsh


# Link .bash_profile -> .bashrc
rm -f ~/.bash_profile
ln -sv ~/.bashrc ~/.bash_profile

# Link Some Dropbox folders
# s: soft
# v: verbose
# n: only if $file2 doesn't not exist
ln -svn ~/Dropbox/00-Notes/org ~/org
ln -svn ~/Dropbox/01-Meta/fonts ~/.fonts
