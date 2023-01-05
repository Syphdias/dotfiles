#!/usr/bin/env bash
source ~/.config/dynamic-wallpaper-theme.src
feh --bg-fill ~/.local/share/dynamic-wallpaper/${POSTSWITCHTHEME}/$(($(date +\%k)/1)).*
#feh --bg-fill ~/Pictures/wallpapers/current/ --randomize
