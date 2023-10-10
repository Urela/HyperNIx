#!/usr/bin/env bash

# initialize wallpaper daemon
swww init &
# set wallpaper
swww img ~/Downloads/jezael-melgoza-2FiXtdnVhjQ-unsplash &

# networking
nm-applet --indicator &

waybar &
dunst
