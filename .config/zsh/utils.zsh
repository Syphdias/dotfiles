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
    # TODO: detect no value change in time or in value
    if [[ $# -eq 0 ]]; then
        echo "Provide to time value pairs to calculate when value reach zero"
        echo "times need to be valid \`date\` format"
        echo "how-long-to-zero-with 13:00 5 12:00 20"
        echo "how-long-to-zero-with 12:00 20 13:00 5"
        return
    fi

    # detect bigger value and set times and values accordingly
    if [[ $2 -gt $4 ]]; then
        first_time="$1"
        first_value="$2"
        second_time="$3"
        second_value="$4"
    else
        first_time="$3"
        first_value="$4"
        second_time="$1"
        second_value="$2"
    fi


    first_time_sec="$(date +%s -d "$first_time")"
    second_time_sec="$(date +%s -d "$second_time")"
    if [[ $first_time_sec -gt $second_time_sec ]]; then
        echo "You provided ascending values. The value will never reach zero." >&2
        echo "This assumes linar change" >&2
        return 1
    fi


    time_delta_sec=$((second_time_sec - first_time_sec));
    value_delta=$((first_value - second_value))
    value_delta=$((value_delta*1.)) # workaround I don't remember; convert to float?
    value_per_time=$((value_delta/time_delta_sec))

    time_in_sec=$((second_value/value_per_time))
    # append 0 in case the calculation ends in .
    done_time="$(date -d "@$((second_time_sec + time_in_sec))0")"

    # "cast to int"
    time_in_sec="$(sed 's/\..*//' <<<$time_in_sec)"
    human_time="$((time_in_sec/3600))h $((time_in_sec%3600/60))min"
    echo "${(q)first_time} ${(q)first_value} -> ${(q)second_time} ${(q)second_value}"
    echo "done with $value_per_time/s in $human_time at $done_time"
}
