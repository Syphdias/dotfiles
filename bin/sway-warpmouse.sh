#!/usr/bin/env bash

focused_rect=$(swaymsg -t get_tree | jq '.. | select(.focused? == true) | .rect')

# Extract position and size
x=$(jq -r '.x' <<<"$focused_rect")
y=$(jq -r '.y' <<<"$focused_rect")
width=$(jq -r '.width' <<<"$focused_rect")
height=$(jq -r '.height' <<<"$focused_rect")

# Calculate center coordinates of focused_rect
center_x=$((x + width / 2))
center_y=$((y + height / 2))

swaymsg seat seat0 cursor set "$center_x" "$center_y"
