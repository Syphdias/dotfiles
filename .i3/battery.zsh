#!/usr/bin/env zsh

#                                                                                                        
#"LOW"           "${DEFAULT_COLOR}" "red"                       '\u'${CODEPOINT_OF_AWESOME_BATTERY_FULL}  $'\uF240 '
#"CHARGING"      "${DEFAULT_COLOR}" "yellow"                    '\u'${CODEPOINT_OF_AWESOME_BATTERY_FULL}  $'\uF240 '
#"CHARGED"       "${DEFAULT_COLOR}" "green"                     '\u'${CODEPOINT_OF_AWESOME_BATTERY_FULL}  $'\uF240 '
#"DISCONNECTED"  "${DEFAULT_COLOR}" "${DEFAULT_COLOR_INVERTED}" '\u'${CODEPOINT_OF_AWESOME_BATTERY_FULL}  $'\uF240 '

local -i POWERLEVEL9K_BATTERY_LOW_THRESHOLD=10
local -i POWERLEVEL9K_BATTERY_MEDIUM_THRESHOLD=20
local -i POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD=999
local -a POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND
local POWERLEVEL9K_BATTERY_VERBOSE=true
typeset -g POWERLEVEL9K_BATTERY_STAGES

typeset -gA _P9K_BATTERY_STATES=(
  'low'           'red'
  'medium'        'orange'
  'charging'      'yellow'
  'charged'       'green'
  'disconnected'  'white'
)


function _p9k_read_file() {
  _P9K_RETVAL=''
  [[ -n $1 ]] && read -r _P9K_RETVAL <$1
  [[ -n $_P9K_RETVAL ]]
}

local state remain
local -i bat_percent

local -a bats=( /sys/class/power_supply/(BAT*|battery)/(FN) )
(( $#bats )) || return

local -i energy_now energy_full power_now 
local -i is_full=1 is_calculating is_charching
local dir
for dir in $bats; do
  local -i pow=0
  _p9k_read_file $dir/(energy|charge)_now(N)  && (( energy_now+=_P9K_RETVAL ))
  _p9k_read_file $dir/(energy|charge)_full(N) && (( energy_full+=_P9K_RETVAL ))
  _p9k_read_file $dir/(power|current)_now(N)  && (( power_now+=${pow::=$_P9K_RETVAL} ))
  _p9k_read_file $dir/status(N) && local bat_status=$_P9K_RETVAL || continue
  [[ $bat_status != Full                                ]] && is_full=0
  [[ $bat_status == Charging                            ]] && is_charching=1
  [[ $bat_status == (Charging|Discharging) && $pow == 0 ]] && is_calculating=1
done 

if (( energy_full )); then
  bat_percent=$(( 100 * energy_now / energy_full ))
  (( bat_percent > 100 )) && bat_percent=100
fi

if (( is_full || bat_percent == 100 )); then
  state=charged
else
  if (( is_charching )); then
    state=charging
  elif (( bat_percent < POWERLEVEL9K_BATTERY_LOW_THRESHOLD )); then
    state=low
  elif (( bat_percent < POWERLEVEL9K_BATTERY_MEDIUM_THRESHOLD )); then
    state=medium
  else
    state=disconnected
  fi

  if (( power_now > 0 )); then
    (( is_charching )) && local -i e=$((energy_full - energy_now)) || local -i e=energy_now
    local -i minutes=$(( 60 * e / power_now ))
    (( minutes > 0 )) && remain=$((minutes/60)):${(l#2##0#)$((minutes%60))}
  elif (( is_calculating )); then
    remain="..."
  fi
fi

(( bat_percent >= POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD )) && return

local msg="$bat_percent%"
[[ $POWERLEVEL9K_BATTERY_VERBOSE == true && -n $remain ]] && msg+=" ($remain)"

local icon=BATTERY_ICON bg=$DEFAULT_COLOR
if (( $#POWERLEVEL9K_BATTERY_STAGES || $#POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND )); then
  local -i idx=$#POWERLEVEL9K_BATTERY_STAGES
  (( bat_percent < 100 )) && idx=$((bat_percent * $#POWERLEVEL9K_BATTERY_STAGES / 100 + 1))
  if (( $#POWERLEVEL9K_BATTERY_STAGES )); then
    icon+=_$idx
    typeset -g POWERLEVEL9K_$icon=$POWERLEVEL9K_BATTERY_STAGES[idx]
  fi
  (( $#POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND )) && bg=$POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND[idx]
fi

# $state -> color

[[ "$state" == "charging" ]] && msg+="⚡"

# Pop-Up
[[ "$state" == "disconnected" ]] && (( bat_percent < 5 )) && notify-send Battery "is at ${bat_percent}%" -u critical
[[ "$state" == "disconnected" ]] && (( bat_percent < 2 )) && notify-send Battery "is at ${bat_percent}%" -u critical
[[ "$state" == "disconnected" ]] && (( bat_percent < 2 )) && notify-send Battery "is at ${bat_percent}%" -u critical

#echo $state $2 "$bg" "$_P9K_BATTERY_STATES[$state]" $icon 0 '' $msg
if [[ "$state" == "charged" || "$state" == "disconnected" ]]; then
  echo "$msg"
else
  echo "<span color='${_P9K_BATTERY_STATES[$state]}'>$msg</span>"
fi
