#!/bin/sh

CACHEDIR="${XDG_CACHE_HOME:-${HOME}/.cache}/lock"
LOCK_OVERLAY=~/.config/i3lock/Glados_promo.png

# noone should be able to get screenshots
umask 0077
mkdir -p "$CACHEDIR"

# exit if screen is already locked
pgrep i3lock && exit

# Take a screenshot
scrot -o "${CACHEDIR}/screen_locked.png" &
scrot_pid=$!

# Notify (in background in case daemon is broken)
#notify-send LOCKING -u critical &

# Prelock with old picture
i3lock -efi "${CACHEDIR}/screen_locked_last.png" -c 2f343f &

# Pixellate it 10x
wait $scrot_pid && \
    mogrify -scale 10% -scale 1000% "${CACHEDIR}/screen_locked.png"
    convert -gamma .67 -gravity NorthWest -geometry +500 -composite "${CACHEDIR}/screen_locked.png" "$LOCK_OVERLAY" "${CACHEDIR}/screen_locked.png"
#convert -blur 0x8 /tmp/locking_screen.png /tmp/screen_blur.png
#ffmpeg -loglevel quiet -i <(import -silent -window root png:-) \
#    -i ~/.i3/Evil_Rick_Sprite.png \
#    -y -filter_complex "boxblur=5:5,overlay=(main_w-overlay_w-10):(main_h-overlay_h-10)" -vframes 1 "${CACHEDIR}/screen_locked.png"

# Disable dunst
killall -SIGUSR1 dunst &

# Lock screen displaying this image.
killall i3lock
i3lock -nefi "${CACHEDIR}/screen_locked.png" -c 2f343f

# Turn the screen off after a delay.
#sleep 10m && pgrep i3lock && xset dpms force off

# Enable Notifications again
killall -SIGUSR2 dunst

# backup 
cp "${CACHEDIR}/screen_locked.png" "${CACHEDIR}/screen_locked_last.png"
