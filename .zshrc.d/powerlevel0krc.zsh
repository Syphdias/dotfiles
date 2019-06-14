# Original location: https://github.com/romkatv/dotfiles-public/blob/master/.purepower.
# If you copy this file, keep the link to the original and this sentence intact; you are encouraged
# to change everything else.
# inspirations from https://github.com/sindresorhus/pure and https://github.com/iboyperson/p9k-theme-pastel

[[ $TERM == xterm* ]] || : ${PURE_POWER_MODE:=portable}

() {
  emulate -L zsh && setopt no_unset pipe_fail

  # `$(_pp_c x y`) evaluates to `y` if the terminal supports >= 256 colors and to `x` otherwise.
  zmodload zsh/terminfo
  if (( terminfo[colors] >= 256 )); then
    function _pp_c() { echo -E $2 }
  else
    function _pp_c() { echo -E $1 }
    typeset -g POWERLEVEL9K_IGNORE_TERM_COLORS=true
  fi

  # `$(_pp_s x y`) evaluates to `x` in portable mode and to `y` in fancy mode.
  if [[ ${PURE_POWER_MODE:-fancy} == fancy ]]; then
    function _pp_s() { echo -E $2 }
  else
    if [[ $PURE_POWER_MODE != portable ]]; then
      echo -En "purepower: invalid mode: ${(qq)PURE_POWER_MODE}; " >&2
      echo -E  "valid options are 'fancy' and 'portable'; falling back to 'portable'" >&2
    fi
    function _pp_s() { echo -E $1 }
    typeset -g POWERLEVEL9K_IGNORE_TERM_COLORS=true
  fi

  local ins=$(_pp_s '>' '❯')
  local cmd=$(_pp_s '<' '❮')
  if [[ $ZSH_THEME == *powerlevel10k* ]]; then
    local p="\${\${\${KEYMAP:-0}:#vicmd}:+${${ins//\\/\\\\}//\}/\\\}}}"
    p+="\${\${\$((!\${#\${KEYMAP:-0}:#vicmd})):#0}:+${${cmd//\\/\\\\}//\}/\\\}}}"
    typeset -g ZLE_RPROMPT_INDENT=1
    #typeset -g POWERLEVEL9K_SHOW_RULER=true
    typeset -g POWERLEVEL9K_RULER_CHAR=$(_pp_s '-' '─')
    typeset -g POWERLEVEL9K_RULER_BACKGROUND=none
    typeset -g POWERLEVEL9K_RULER_FOREGROUND=$(_pp_c 005 237)
  else
    p=$ins
  fi
  local ok="%F{$(_pp_c 002 076)}${p}%f"
  local err="%F{$(_pp_c 001 009)}${p}%f"


  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      virtualenv #pyenv rbenv
      dir_writable dir #newline dir
      vcs #gitstatus
      root_indicator
  )
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status
      command_execution_time
      background_jobs
      custom_rprompt
      vpn_ip
      time #newline
      #battery
      #context
  )

  # gerneral
  typeset -g POWERLEVEL9K_MODE="nerdfont-complete"
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%(?.$ok.$err) "

  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS=

  # dir
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER="%F{$(_pp_c 005 101)}*"
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=$(_pp_c 004 039)
  typeset -g POWERLEVEL9K_DIR_{ETC,HOME,HOME_SUBFOLDER,DEFAULT}_BACKGROUND=none
  typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND=$(_pp_c 003 209)
  typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND=white
  typeset -g POWERLEVEL9K_{ETC,FOLDER,HOME,HOME_SUB}_ICON=

  # virtenv
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=none
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=202

  # dir_writable
  typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND=none
  typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_VISUAL_IDENTIFIER_COLOR=003
  typeset -g POWERLEVEL9K_LOCK_ICON=$(_pp_s '#' '');
  # vcs
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_BACKGROUND=none
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$(_pp_c 002 076)
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$(_pp_c 006 014)
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$(_pp_c 003 011)
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$(_pp_c 005 244)
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNTRACKEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNSTAGEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STAGEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_INCOMING_CHANGESFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_OUTGOING_CHANGESFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STASHFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_ACTIONFORMAT_FOREGROUND=001
  typeset -g POWERLEVEL9K_VCS_LOADING_ACTIONFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_LOADING_FOREGROUND
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON=$'\uE729 '
  typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON="  "
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$(_pp_s '<' '⇣')
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$(_pp_s '>' '⇡')
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED}_MAX_NUM=99
  typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=$(_pp_s $'%{\b|%}' $'\uF126 ')
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON=$(_pp_s '@' $'\uE729 ')
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON=$(_pp_s $'%{\b!%}' $'\uF06A ')
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=$(_pp_s $'%{\b?%}' $'\uF059 ')
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON=$(_pp_s $'%{\b+%}' $'\uF055 ')
  typeset -g POWERLEVEL9K_VCS_STASH_ICON=$(_pp_s '*' $'\uF01C ')
  typeset -g POWERLEVEL9K_VCS_TAG_ICON=$(_pp_s $'%{\b#%}' $'\uF02B ')

  # root_indicator
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=none
  typeset -g POWERLEVEL9K_ROOT_ICON=$'\uF09C'

  # background_jobs
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=none
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR=002
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON=$(_pp_s '%%' '☰')

  # command_execution_time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=none
  typeset -g POWERLEVEL9K_EXECUTION_TIME_ICON=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$(_pp_c 005 101)

  # time
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=none
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=244
  typeset -g POWERLEVEL9K_TIME_ICON=

  # vpn_ip
  typeset -g POWERLEVEL9K_VPN_IP_INTERFACE=tun0

  # battery
  typeset -g POWERLEVEL9K_BATTERY_{LOW,CHARGING,CHARGED,DISCONNECTED}_BACKGROUND=none
  [[ ${PURE_POWER_MODE:-fancy} != fancy ]] && POWERLEVEL9K_BATTERY_STAGES="▁▂▃▄▅▆▇█" && P9K_BATTERY_STAGES=$POWERLEVEL9K_BATTERY_STAGES

  # status
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=none
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$(_pp_c 001 009)
  typeset -g POWERLEVEL9K_CARRIAGE_RETURN_ICON=

  # context
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT,REMOTE_SUDO,REMOTE,SUDO}_BACKGROUND=none
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND=$(_pp_c 007 244)
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$(_pp_c 003 011)

  # custom_rprompt
  function custom_rprompt() {}
  typeset -g POWERLEVEL9K_CUSTOM_RPROMPT=custom_rprompt
  typeset -g POWERLEVEL9K_CUSTOM_RPROMPT_BACKGROUND=none
  typeset -g POWERLEVEL9K_CUSTOM_RPROMPT_FOREGROUND=$(_pp_c 004 012)

  # gitstatus TODO
  P9K_GITSTATUS_DIR=~/.oh-my-zsh-custom/themes/powerlevel10k/gitstatus
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_BACKGROUND=none
  typeset -g P9K_GITSTATUS_CLEAN_FOREGROUND=076
  typeset -g P9K_GITSTATUS_UNTRACKED_FOREGROUND=014
  typeset -g P9K_GITSTATUS_MODIFIED_FOREGROUND=011
  typeset -g P9K_GITSTATUS_LOADING_FOREGROUND=244
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_UNTRACKEDFORMAT_FOREGROUND=$P9K_GITSTATUS_UNTRACKED_FOREGROUND
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_UNSTAGEDFORMAT_FOREGROUND=$P9K_GITSTATUS_MODIFIED_FOREGROUND
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_STAGEDFORMAT_FOREGROUND=$P9K_GITSTATUS_MODIFIED_FOREGROUND
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_INCOMING_CHANGESFORMAT_FOREGROUND=$P9K_GITSTATUS_CLEAN_FOREGROUND
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_OUTGOING_CHANGESFORMAT_FOREGROUND=$P9K_GITSTATUS_CLEAN_FOREGROUND
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_STASHFORMAT_FOREGROUND=$P9K_GITSTATUS_CLEAN_FOREGROUND
  typeset -g P9K_GITSTATUS_{CLEAN,UNTRACKED,MODIFIED}_ACTIONFORMAT_FOREGROUND=001
  typeset -g P9K_GITSTATUS_LOADING_ACTIONFORMAT_FOREGROUND=$P9K_GITSTATUS_LOADING_FOREGROUND
  typeset -g P9K_GITSTATUS_COMMIT_ICON=$'\uE729 '
  typeset -g P9K_GITSTATUS_INCOMING_CHANGES_ICON=$'\u2193'
  typeset -g P9K_GITSTATUS_OUTGOING_CHANGES_ICON=$'\u2191'

  # P9K `next` support
  P9K_IGNORE_VAR_WARNING=true
  P9K_IGNORE_DEPRECATION_WARNING=true

#   () {
#     local envVar varType varName origVar newVar newVal
#     local oldVarsFound=false
#     for envVar in $(declare); do
#       if [[ ${envVar} =~ "POWERLEVEL9K_" ]]; then
#         oldVarsFound=true
#         varType=( "$(declare -p ${envVar})" )
#         varName=${${envVar##POWERLEVEL9K_}%=*}
#         origVar="POWERLEVEL9K_${varName}"
#         newVar="P9K_${varName}"
#         if [[ "${varType[1]:9:1}" == "a" || "${varType[1]:12:1}" == "a" ]]; then # array variable
#         case ${(U)varName} in
#           BATTERY_STAGES|BATTERY_LEVEL_BACKGROUND|LEFT_PROMPT_ELEMENTS|RIGHT_PROMPT_ELEMENTS)
#           [[ "${varType[2]}" == "" ]] && var=${varType[1]} || var=${varType[2]} # older ZSH installs have 2 lines for declare
#           newVal="${${${var##*\(}%\)*}//  / }" # remove brackets and extra spaces
#           newVal="${newVal%"${newVal##*[! $'\t']}"}" # severe trick - remove trailing whitespace
#           newVal="${newVal#"${newVal%%[! $'\t']*}"}" # severe trick - remove leading whitespace
#           ;;
#           BATTERY_STAGES)
#           newVal=${${newVal}//\'/}
#           ;;
#         esac
#         typeset -g -a $newVar
#         : ${(PA)newVar::=${(s: :)newVal}} # array assignment with values split on space
#       else
#         newVal=${(P)origVar}
#         : ${(P)newVar::=$newVal}
#       fi
#       unset $origVar
#     fi
#   done
# } "$@"


  P9K_LEFT_PROMPT_ELEMENTS=($POWERLEVEL9K_LEFT_PROMPT_ELEMENTS)
  P9K_RIGHT_PROMPT_ELEMENTS=($POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS)
  P9K_MODE=$POWERLEVEL9K_MODE
  P9K_PROMPT_ON_NEWLINE=$POWERLEVEL9K_PROMPT_ON_NEWLINE
  P9K_RPROMPT_ON_NEWLINE=$POWERLEVEL9K_RPROMPT_ON_NEWLINE
  P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON=$POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX
  P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON=$POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX
  typeset -g P9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR_ICON=$POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR
  typeset -g P9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR_ICON=$POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR
  typeset -g P9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS=$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS
  P9K_DIR_SHORTEN_STRATEGY=$POWERLEVEL9K_SHORTEN_STRATEGY
  P9K_DIR_SHORTEN_LENGTH=$POWERLEVEL9K_SHORTEN_DIR_LENGTH
  P9K_DIR_SHORTEN_DELIMITER=$POWERLEVEL9K_SHORTEN_DELIMITER
  P9K_DIR_PATH_HIGHLIGHT_FOREGROUND=$POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND
  typeset -g P9K_DIR_{ETC,HOME,HOME_SUBFOLDER,DEFAULT}_BACKGROUND=$POWERLEVEL9K_DIR_ETC_BACKGROUND
  typeset -g P9K_DIR_{ETC,DEFAULT}_FOREGROUND=$POWERLEVEL9K_DIR_ETC_FOREGROUND
  typeset -g P9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND=$POWERLEVEL9K_DIR_HOME_FOREGROUND
  typeset -g P9K_DIR_{ETC,FOLDER,HOME,HOME_SUBFOLDER}_ICON=$POWERLEVEL9K_ETC_ICON
  P9K_VIRTUALENV_BACKGROUND=$POWERLEVEL9K_VIRTUALENV_BACKGROUND
  P9K_VIRTUALENV_FOREGROUND=$POWERLEVEL9K_VIRTUALENV_FOREGROUND
  P9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND=$POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND
  P9K_DIR_WRITABLE_FORBIDDEN_ICON_COLOR=$POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_VISUAL_IDENTIFIER_COLOR
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_BACKGROUND=$POWERLEVEL9K_VCS_CLEAN_BACKGROUND
  P9K_VCS_CLEAN_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  P9K_VCS_UNTRACKED_FOREGROUND=$POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND
  P9K_VCS_MODIFIED_FOREGROUND=$POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  P9K_VCS_LOADING_FOREGROUND=$POWERLEVEL9K_VCS_LOADING_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNTRACKEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_UNTRACKEDFORMAT_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNSTAGEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_UNSTAGEDFORMAT_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STAGEDFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_STAGEDFORMAT_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_INCOMING_CHANGESFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_INCOMING_CHANGESFORMAT_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_OUTGOING_CHANGESFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_OUTGOING_CHANGESFORMAT_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STASHFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_STASHFORMAT_FOREGROUND
  typeset -g P9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_ACTIONFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_CLEAN_ACTIONFORMAT_FOREGROUND
  P9K_VCS_LOADING_ACTIONFORMAT_FOREGROUND=$POWERLEVEL9K_VCS_LOADING_ACTIONFORMAT_FOREGROUND
  P9K_VCS_COMMIT_ICON=$POWERLEVEL9K_VCS_COMMIT_ICON
  P9K_VCS_REMOTE_BRANCH_ICON=$POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON
  P9K_ROOT_INDICATOR_BACKGROUND=$POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND
  P9K_USER_ROOT_ICON=$POWERLEVEL9K_ROOT_ICON
  P9K_BACKGROUND_JOBS_VERBOSE=$POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE
  P9K_BACKGROUND_JOBS_BACKGROUND=$POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND
  P9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR=$POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR
  P9K_BACKGROUND_JOBS_ICON=$POWERLEVEL9K_BACKGROUND_JOBS_ICON
  P9K_COMMAND_EXECUTION_TIME_THRESHOLD=$POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD
  P9K_COMMAND_EXECUTION_TIME_BACKGROUND=$POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND
  P9K_COMMAND_EXECUTION_TIME_ICON=$POWERLEVEL9K_EXECUTION_TIME_ICON
  P9K_COMMAND_EXECUTION_TIME_FOREGROUND=$POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND
  P9K_TIME_BACKGROUND=$POWERLEVEL9K_TIME_BACKGROUND
  P9K_TIME_FOREGROUND=$POWERLEVEL9K_TIME_FOREGROUND
  P9K_TIME_ICON=$POWERLEVEL9K_TIME_ICON
  P9K_VPN_IP_INTERFACE=$POWERLEVEL9K_VPN_IP_INTERFACE
  typeset -g P9K_BATTERY_{LOW,CHARGING,CHARGED,DISCONNECTED}_BACKGROUND=$POWERLEVEL9K_BATTERY_LOW_BACKGROUND
  P9K_STATUS_OK=$POWERLEVEL9K_STATUS_OK
  P9K_STATUS_ERROR_CR_BACKGROUND=$POWERLEVEL9K_STATUS_ERROR_BACKGROUND
  P9K_STATUS_ERROR_CR_FOREGROUND=$POWERLEVEL9K_STATUS_ERROR_FOREGROUND
  P9K_STATUS_ERROR_CR_ICON=$POWERLEVEL9K_CARRIAGE_RETURN_ICON

  # NOTES/IDEAS
  #P9K_LEFT_SEGMENT_SEPARATOR_ICON=''
  #P9K_RIGHT_SEGMENT_SEPARATOR_ICON=' '
  # $'\ue0b8' $'\ue0b9' $'\ue0ba' $'\ue0bb' $'\ue0bc' $'\ue0bd' $'\ue0be' $'\ue0bf'
  #                                                                
  # ▶ ◀ ◥ ◤ ◆ ▬ ◼


  # TESTS
  # POWERLEVEL9K_DIR_SHORTEN_STRATEGY="truncate_to_unique"

  #setopt promptsubst

  #debug P9K_VCS_SHOW_CHANGESET=true
  #P9K_BATTERY_LEVEL_BACKGROUND=(blue red yellow green)
  #P9K_BATTERY_STAGES="▁▂▃▄▅▆▇█"
  #P9K_BATTERY_STAGES="abcdefghijklmnopqrstuvwxyz"
  #P9K_BATTERY_STAGES=1
  #P9K_BATTERY_STAGES=("lowest" "low" "medium" "high" "full")
  #   $'▏    ▏' $'▎    ▏' $'▍    ▏' $'▌    ▏' $'▋    ▏' $'▊    ▏' $'▉    ▏' $'█    ▏'
  #   $'█▏   ▏' $'█▎   ▏' $'█▍   ▏' $'█▌   ▏' $'█▋   ▏' $'█▊   ▏' $'█▉   ▏' $'██   ▏'
  #   $'██   ▏' $'██▎  ▏' $'██▍  ▏' $'██▌  ▏' $'██▋  ▏' $'██▊  ▏' $'██▉  ▏' $'███  ▏'
  #   $'███  ▏' $'███▎ ▏' $'███▍ ▏' $'███▌ ▏' $'███▋ ▏' $'███▊ ▏' $'███▉ ▏' $'████ ▏'
  #   $'████ ▏' $'████▎▏' $'████▍▏' $'████▌▏' $'████▋▏' $'████▊▏' $'████▉▏' $'█████▏' )


  ## for newline-revolution
  #unset P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON P9K_PROMPT_ON_NEWLINE P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON
  #P9K_PROMPT_ON_NEWLINE=true
  #P9K_LEFT_PROMPT_ELEMENTS=(dir newline vcs newline newline)
  #P9K_RIGHT_PROMPT_ELEMENTS=(dir newline vcs dir newline newline vcs)
  #P9K_RIGHT_PROMPT_ELEMENTS=(dir newline vcs dir newline dir newline vcs)
  #P9K_MULTILINE_LAST_NEWLINE_PROMPT_SUFFIX_ICON='❱'

  ## for newdir test
  #P9K_LEFT_PROMPT_ELEMENTS=(dir dirnew); P9K_RIGHT_PROMPT_ELEMENTS=(); P9K_DIR_PATH_ABSOLUTE=true; P9K_DIR_SHORTEN_STRATEGY='truncate_with_folder_marker'; P9K_DIR_SHORTEN_FOLDER_MARKER=.git
  #P9K_BATTERY_CHARGING_ICON_COLOR=blue

  unfunction _pp_c _pp_s
} "$@"
# needed!
