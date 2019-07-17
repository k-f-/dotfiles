#!/bin/sh
# Setup Frame Buffer and DPI
xrandr --dpi 276 \
       --fb 7680x2160 \
       --output eDP1 --primary --mode 3840x2160 --rate 60 \
       --output HDMI1 --mode 1920x1080 --rotate normal --scale-from 3840x2160 --panning 3840x2160+3840+0 --right-of eDP1
./.bin/set-wallpaper
