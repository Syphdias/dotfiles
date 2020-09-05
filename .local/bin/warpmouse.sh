#!/bin/bash
# https://github.com/i3/i3/issues/2971
# Known Issues:
# - switches to floating window if cursor lands on one
# - if floating window is moves out of range, cursor warps to middle
#   (solution: always move cursor with floating window?)

# get WINDOW of mouse position
eval $(xdotool getmouselocation --shell)
MOUSE_WINDOW=$WINDOW

# get WIDTH and HEIGHT of focused WINDOW
eval $(xdotool getwindowfocus getwindowgeometry --shell)

# get WINDOW specific coordinates for center of window
TX=$(expr $WIDTH / 2)
TY=$(expr $HEIGHT / 2)

if [[ $WINDOW != $MOUSE_WINDOW ]]; then
    xdotool mousemove -window $WINDOW $TX $TY
fi
