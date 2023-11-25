#!/usr/bin/env bash

# initialize wallpaper daemon
swww init &
# set wallpaper
swww img ~/Downloads/josh-sorenson-Z33d85enIBI-unsplash.jpg &

# networking
nm-applet --indicator &

waybar &
dunst
