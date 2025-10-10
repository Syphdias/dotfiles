#!/usr/bin/env bash
source ~/.config/dynamic-wallpaper-theme.src

if [[ -n "$POSTSWITCHTHEME" ]]; then
    new_bg=~/.local/share/dynamic-wallpaper/${POSTSWITCHTHEME}/$(($(date +\%k) / 1)).*
else
    new_bg=~/Pictures/wallpapers/current
fi

if pgrep -f "$new_bg" >/dev/null; then
    echo "No bg change"
    exit
fi

if [[ "$DESKTOP_SESSION" == sway ]]; then
    swaymsg output '*' bg "$new_bg" fill
else
    feh --bg-fill "$new_bg" --randomize
fi
