#!/bin/sh
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# use unclutter to hide mouse cursor
exec unclutter -idle 1 -noevents &

# make CapsLock behave like Ctrl:
exec setxkbmap -option ctrl:nocaps &

# make short-pressed Ctrl behave like Escape:
exec xcape -e 'Control_L=Escape' &

# Merge in everything else.
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi
