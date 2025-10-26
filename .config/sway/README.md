# Philosophy

## Modifiers

- `Super` is for Window Manager Stuff
- `Super-Ctrl` is for Application Launching

## Keybinds

- TODO: What about notification (dismissal?)
- TODO: What about audio source switching

## Scripts

- located in `~/bin`

### Background

- script `~/bin/set-background.sh`
- image locations
  - if `POSTSWITCHTHEME` set in `~/.config/dynamic-wallpaper-theme.src`: `~/.local/share/dynamic-wallpaper/${POSTSWITCHTHEME}/`
    - TODO: Maybe set in `~/.config/environment.d/background.conf`
    - TODO: switching?
  - else `~/Pictures/wallpapers/current`
- TODO: define where to store this variable depending on pc/etc

## Autostart

TODO

## Environment

TODO

- needs to work for WSL
- environment.d
- .(x)profile
- .(bash|zsh)rc
- uswm/env(-sway)

## Themes

TODO

- (auto) switching?

### What to Switch

- change symlink: TODO
- background
  - `~/Pictures/wallpapers/current` or `POSTSWITCHTHEME`
  - `~/bin/set-background.sh`
- sway: TODO
- waybar:
  - TODO:
  - `systemctl --user try-reload-or-restart waybar.service`
- btop:
  - TODO:
  - `pkill -SIGUSR2 btop`
- swaync:
  - TODO:
  - `swaync-client --reload-css`
- ghostty
  - TOOD:
  - `killall -SIGUSR2 ghostty`
- alacritty
  - TOOD:
  - `touch ~/.config/alacritty/alacritty.toml`
- kitty
  - TOOD:
  - `killall -SIGUSR1 kitty`
- gtk
  - TODO: dconf? which theme? which icons?
  - `gsettings set org.gnome.desktop.interface color-scheme "prefer-light"`
  - `gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"`
  - `gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"`
  - `gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"`
  - `gsettings set org.gnome.desktop.interface icon-theme "$(<$GNOME_ICONS_THEME)"`
  - `gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"`
- eza: TODO
- vivaldi:
  - TODO
- obsidian
