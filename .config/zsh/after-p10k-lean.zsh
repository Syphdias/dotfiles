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
    prenv
    kubecontext terraform
    aws azure gcloud openstack
    pyenv virtualenv goenv
)
for context_segment in ${(@)context_segments}; do
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        "${(@)POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS:#${context_segment}}"
    )
    insert_segment_before $context_segment dir
done

# colors for context segments
typeset -g POWERLEVEL9K_PRENV_FOREGROUND='#fff8e7'
typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND='#3970E4'
typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND='#a067da' #7b42bc
typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND='#ff9900'
typeset -g POWERLEVEL9K_AZURE_FOREGROUND='#007Fff'
typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND='#FBBc05'
typeset -g POWERLEVEL9K_OPENSTACK_FOREGROUND='#ed1844'
typeset -g POWERLEVEL9K_PYENV_FOREGROUND='#4B8Bbe'
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#ffe873'
typeset -g POWERLEVEL9K_GOENV_FOREGROUND='#00add8'

# general
typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=  # disable icons for all segments

# dir
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0                            # always shorten path
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#2ac3de'
typeset -g POWERLEVEL9K_DIR_{ANCHOR,PATH_HIGHLIGHT}_FOREGROUND='#27a1b9'           # disable bold highlighting
typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND='#e0af68'
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND='#c0caf5'
typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION=''
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#a9b1d6'

# prompt
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=076
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=009

# virtenv
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=202

# git
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#9ece6a'
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#6183bb'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#449dab'
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR="$POWERLEVEL9K_VCS_CLEAN_FOREGROUND"
typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN=
POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS=true

# root_indicator
# TODO: typeset -g POWERLEVEL9K_ROOT_VISUAL_IDENTIFIER_EXPANSION=$'\uF09C'

# background_jobs
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#73daca'
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='☰'

# command_execution_time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#737aa2'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1

# time
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#565f89'
typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

# context
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND='#565f89'
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#e0af68'

# status
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND='#9ece6a'
typeset -g POWERLEVEL9K_STATUS_ERROR{_SIGNAL,_PIPE,}_FOREGROUND='#db4b4b'
typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_CONTENT_EXPANSION='${P9K_CONTENT#SIG}'
typeset -g POWERLEVEL9K_STATUS_{ERROR,OK}_PIPE_CONTENT_EXPANSION='${P9K_CONTENT//SIG}'

# terraform
typeset -g POWERLEVEL9K_TERRAFORM_SHOW_ON_COMMAND='terraform|terragrunt'
