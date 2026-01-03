#!/usr/bin/env bash

CACHEDIR="${XDG_CACHE_HOME:-${HOME}/.cache}/lock"
LOCK_OVERLAY=~/.config/i3lock/Glados_promo.png

playerctl pause || true

# Ensure 1password is locked
if pgrep -x "1password" >/dev/null; then
    1password --lock &
fi

if [[ "${XDG_SESSION_TYPE:-x11}" == "wayland" ]]; then
    swaylock \
        --daemonize \
        --screenshot --effect-pixelate 10 \
        --effect-compose "500,0;northwest;${LOCK_OVERLAY}" \
        --ignore-empty-password \
        --clock \
        --timestr '%H:%M' --datestr '%a %F' \
        \
        --layout-bg-color '#00000000' \
        --layout-text-color '#c0caf5' \
        \
        --inside-color '#1a1b26f0' \
        --ring-color '#27a1b9' \
        --key-hl-color '#1abc9c' \
        --bs-hl-color '#f7768e' \
        --text-color '#c0caf5' \
        \
        --inside-clear-color '#1a1b26f0' \
        --ring-clear-color '#e0af68' \
        --text-clear-color '#e0af68' \
        \
        --inside-ver-color '#1a1b26f0' \
        --ring-ver-color '#1abc9c' \
        --text-ver-color '#1abc9c' \
        \
        --inside-wrong-color '#1a1b26f0' \
        --ring-wrong-color '#f7768e' \
        --text-wrong-color '#f7768e'
    exit
fi

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
wait $scrot_pid &&
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
