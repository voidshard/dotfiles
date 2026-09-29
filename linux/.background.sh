#!/bin/sh

# sway sets the wallpaper itself, so no swaybg process needs to be kept alive
# https://man.archlinux.org/man/sway-output.5#bg
while true
do
    PICTURE=$(find ~/Pictures/.wallpaper -type f | shuf -n 1)
    [ -n "$PICTURE" ] && swaymsg output "*" bg "$PICTURE" fill
    sleep 60
done
