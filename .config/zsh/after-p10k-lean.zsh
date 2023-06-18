zmodload zsh/terminfo
if (( terminfo[colors] >= 256 )); then
else
  typeset -g POWERLEVEL9K_IGNORE_TERM_COLORS=true
fi

function insert_segment_before() {
    local idx=${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[(Ie)$2]}
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[1,${idx}-1]}
        $1
        ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[${idx},${#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS}]}
    )
}
function insert_segment_after() {
    local idx=${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[(Ie)$1]}
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[1,${idx}]}
        $2
        ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[${idx}+1,${#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS}]}
    )
}

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context root_indicator  # user@hostname 
    dir dir_writable        # current/directory 
    my_git_dir vcs          # dotfiles git_status
    newline                 # \n
    prompt_char             # prompt symbol
)

# Remove segment context from right prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=("${(@)POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS:#context}")

# Append context segments to left prompt and remove from right
context_segments=(
    penv
    kubecontext terraform
    aws azure gcloud openstack
    virtualenv pyenv goenv
)
for context_segment in ${(@)context_segments}; do
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        "${(@)POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS:#${context_segment}}"
    )
    insert_segment_before $context_segment dir
done

# general
typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=  # disable icons for all segments

# dir
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0                            # always shorten path
typeset -g POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND=039           # disable bold highlighting
typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND=209
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND=white
typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION=''
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=076
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=009

# virtenv
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=202

# git
typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN=
POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS=true

# root_indicator
# TODO: typeset -g POWERLEVEL9K_ROOT_VISUAL_IDENTIFIER_EXPANSION=$'\uF09C'

# background_jobs
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='☰'

# command_execution_time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1

# time
typeset -g POWERLEVEL9K_TIME_FOREGROUND=244
typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

# context
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND=244
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=011

# status
typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_CONTENT_EXPANSION='${P9K_CONTENT#SIG}'
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_CONTENT_EXPANSION='${P9K_CONTENT//SIG}'
