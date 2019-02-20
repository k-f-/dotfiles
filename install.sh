#!/bin/sh

# Install all the necessary Debian packages, especially `stow`.
#./install_debian_packages.sh

stow bash
stow systemd
stow ranger
stow emacs
stow git
stow x-windows
stow vim
stow email
stow zathura

# Link .bash_profile -> .bashrc
rm -f ~/.bash_profile
ln -s ~/.bashrc ~/.bash_profile

# Link Some Dropbox folders
# s: soft
# v: verbose
# n: only if $file2 doesn't not exist
ln -svn ~/Dropbox/org ~/org
ln -svn ~/Dropbox/elfeed ~/.elfeed
ln -svn ~/Dropbox/fonts ~/.fonts
