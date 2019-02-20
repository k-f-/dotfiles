#!/bin/sh

# Install all the necessary Debian packages, especially `stow`.
#./install_debian_packages.sh

stow bash
stow emacs
stow git
stow x-windows
stow vim
stow email 
stow .config

# Link .bash_profile -> .bashrc
rm -f ~/.bash_profile
ln -s ~/.bashrc ~/.bash_profile

# Link Some Dropbox folders
ln -s ~/Dropbox/org ~/org
ln -s ~/Dropbox/elfeed ~/.elfeed
ln -s ~/Dropbox/fonts ~/.fonts
