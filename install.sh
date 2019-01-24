#!/bin/sh

# Install all the necessary Debian packages, especially `stow`.
./install_debian_packages.sh

stow bash
stow emacs
stow git
stow x-windows
stow fonts
stow i3
stow dunst

# Link .bash_profile -> .bashrc
rm -f ~/.bash_profile
ln -s ~/.bashrc ~/.bash_profile

# Link Some Dropbox folders
ln -s ~/org ~/Dropbox/org
