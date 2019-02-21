#!/bin/sh

# Install all the necessary Debian packages, especially `stow`.
#./install_debian_packages.sh

stow bash
stow compton
stow dunst
stow emacs
stow git
stow gnupg
stow i3
stow mail
stow mpd
stow mpv
stow pcmanfm
stow ranger
stow rofi
stow systemd
stow vim
stow x-windows
stow zathura

# Link .bash_profile -> .bashrc
rm -f ~/.bash_profile
ln -sv ~/.bashrc ~/.bash_profile

# Link Some Dropbox folders
# s: soft
# v: verbose
# n: only if $file2 doesn't not exist
ln -svn ~/Dropbox/org ~/org
ln -svn ~/Dropbox/elfeed ~/.elfeed
ln -svn ~/Dropbox/fonts ~/.fonts
