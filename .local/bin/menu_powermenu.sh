#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Mail   : adi1090x@gmail.com
## Github : @adi1090x
## Reddit : @adi1090x
## Url    : https://github.com/adi1090x/rofi

PATH=~/.local/bin:$PATH
rofi_command="rofi -theme ${1:-card_square}"
uptime=$(uptime -p | sed -e 's/up //g')
#mem=$( free -h | grep -i mem | awk -F ' ' '{print $3}')
cpu=$(~/.config/rofi/bin/usedcpu)
memory=$(~/.config/rofi/bin/usedram)

# Options
shutdown="襤"
reboot="ﰇ"
kexec=""
lock=""
suspend=""
logout=""
winboot=""
hibernate="鈴"

# Variable passed to rofi
options="$shutdown\n$reboot\n$kexec\n$lock\n$suspend\n$hibernate\n$winboot\n$logout"

chosen="$(echo -e "$options" \
            | $rofi_command -p "⏱  $uptime    $cpu    $memory " \
                -dmenu -selected-row 3 \
                -kb-select-1 S \
                -kb-select-2 r \
                -kb-select-3 k \
                -kb-select-4 l \
                -kb-select-5 s \
                -kb-select-6 h \
                -kb-select-7 w \
                -kb-select-8 e )"

case $chosen in
    $shutdown)
        cancel_action="Shutdown"
        exit_param="shutdown"
        ;;
    $reboot)
        cancel_action="Reboot"
        exit_param="reboot"
        ;;
    $kexec)
        cancel_action="Kexec"
        exit_param="kexec"
        ;;
    $lock)
        exit_param="lock"
        ;;
    $suspend)
        playerctl pause
        cancel_action="Suspend"
        exit_param="suspend"
        ;;
    $hibernate)
        playerctl pause
        cancel_action="Hibernate"
        exit_param="hibernate"
        ;;
    $winboot)
        cancel_action="Boot to Windows"
        exit_param="winboot"
        ;;
    $logout)
        cancel_action="Logout"
        exit_param="logout"
        ;;
esac

if [[ -n "$cancel_action" ]]; then
    # start 3s countdown (+race conditon prevention .1s) i3lock#95
    (sleep 3.1s && ~/.local/bin/exit.sh $exit_param) &
elif [[ -n "$exit_param" ]]; then
    ~/.local/bin/exit.sh $exit_param
else
    exit 1
fi

if [[ -n "$cancel_action" ]]; then
    exec_pid=$!
    # timeout rofi bacause it captures mouse/kb and create race condition
    # otherwise and prevents i3lock from grab mouse/kb while rofi is still running
    echo "Cancel $cancel_action" \
        | timeout 3s $rofi_command -p "⏱  $uptime    $cpu    $memory " -dmenu
    if [[ $? == 0 || $? == 1 ]]; then
        # only kill background process if rofi didn't time out
        kill $exec_pid
    fi
fi
