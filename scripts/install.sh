#!/bin/sh

# Install all the necessary Debian packages, especially `stow`.
#./install_debian_packages.sh

cd ~/.dotfiles

stow bash
stow emacs
stow git
stow gnupg
stow mail
stow vim
stow x-windows
stow secrets 
stow youtube-dl

# Link .bash_profile -> .bashrc
rm -f ~/.bash_profile
ln -sv ~/.bashrc ~/.bash_profile

# Link Some Dropbox folders
# s: soft
# v: verbose
# n: only if $file2 doesn't not exist
ln -svn ~/Dropbox/00-Notes/org ~/org
ln -svn ~/Dropbox/01-Meta/fonts ~/.fonts
