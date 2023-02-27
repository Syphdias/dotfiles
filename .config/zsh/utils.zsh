# Short functions that I would rewrite, if I did have them

function ssh-until-up() {
    while ! ssh $@; do
        sleep 1;
    done
}

function recho() {
    echo -e "\e[33m$@\e[0m"
}

function ok() {
    echo -e "\e[32m${@:-ok}\e[0m"
    return
}

function nok() {
    echo -e "\e[31m${@:-notok}\e[0m"
    return 1
}

function isok() {
    rc=$?
    [ $rc -eq 0 ] && ok $1 || nok $2
    return $rc
}

function aww() {
    awk "{print ${1}}" ${@:2}
}

function sshdiff() {
    if [[ "$1" == "-l" ]]; then
        shift
        vimdiff <(eval "$1") <(ssh "$2" ${@:3})
    else
        vimdiff <(ssh "$1" ${@:3}) <(ssh "$2" ${@:3})
    fi
}

function ssh3diff() {
    vimdiff <(ssh "$1" ${@:4}) <(ssh "$2" ${@:4}) <(ssh "$3" ${@:4})
}

function histrm () {
    sed -i "/$1/d" "$HISTFILE"
}

function how-long-to-zero-with() {
    [[ $# -eq 0 ]] && echo "how-log-to-zero-with 13:00 5 12:00 20" && return
    time_delta_in_sec=$(($(date +%s -d "$1")-$(date +%s -d "$3")));
    done_delta=$(($4 - $2)); done_delta=$((done_delta*1.))
    rate=$((done_delta/time_delta_in_sec))
    time_in_sec=$(($2/rate))
    done_time="$(date -d "@$(($(date +%s -d "$3")+time_in_sec))0")"
    human_time="$(time_in_sec=$(sed 's/\..*//' <<<$time_in_sec) bash -c 'echo $((time_in_sec/3600))h $((time_in_sec%3600/60))min')"
    echo "done with $rate/s in $human_time at $done_time"
}
