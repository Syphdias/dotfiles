#!/bin/bash
# https://raw.githubusercontent.com/zzzdeb/dotfiles/arch/scripts/i3cmds/i3fullscreenDirections

# changes window in fullscreen modus
if i3-msg -t get_tree \
    | jq -e 'recurse(.nodes[]; .nodes) | select(.focused).fullscreen_mode == 1'
then
    i3-msg	"fullscreen; focus $1; fullscreen"
else
    i3-msg "focus $1" && ~/.i3/warpmouse.sh
fi
