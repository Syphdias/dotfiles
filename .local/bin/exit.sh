#!/bin/sh
lock() {
    ~/.local/bin/lock.sh & sleep 1
}

case "$1" in
    lock)      lock                        ;;
    logout)    i3-msg exit                 ;;
    suspend)   lock && systemctl suspend   ;;
    hibernate) lock && systemctl hibernate ;;
    reboot)    systemctl reboot            ;;
    shutdown)  systemctl poweroff          ;;
    kexec)     sudo systemctl start kexec-load@linux \
                   && sudo systemctl kexec ;;
    winboot)   sudo efibootmgr --bootnext 0000 \
                   && systemctl reboot     ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown|kexec|winboot}"
        exit 2
esac

exit 0
