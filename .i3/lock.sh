#!/bin/sh

# Take a screenshot
scrot /tmp/screen_locked.png

# Notify
notify-send LOCKING -u critical

# Pixellate it 10x
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
convert -gamma .67 -gravity North -geometry -100 -composite /tmp/screen_locked.png ~/.i3/Glados_promo.png /tmp/screen_locked.png
#convert -blur 0x8 /tmp/locking_screen.png /tmp/screen_blur.png
#ffmpeg -loglevel quiet -i <(import -silent -window root png:-) \
#    -i ~/.i3/Evil_Rick_Sprite.png \
#    -y -filter_complex "boxblur=5:5,overlay=(main_w-overlay_w-10):(main_h-overlay_h-10)" -vframes 1 /tmp/screen_locked.png

# Disable dunst
notify-send "DUNST_COMMAND_PAUSE"

# Lock screen displaying this image.
i3lock -nefi /tmp/screen_locked.png -c 2f343f

# Turn the screen off after a delay.
#sleep 10m && pgrep i3lock && xset dpms force off

# Enable Notifications again
notify-send "DUNST_COMMAND_RESUME"
