# If not running interactively, don't do anything
# this! https://github.com/demure/dotfiles

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

source "$HOME/.config/zsh/alias.zsh"

case $- in
    *i*) ;;
      *) return;;
esac

# shopt
shopt -s histappend                 ## Appends hist on exit
shopt -s cmdhist                    ## Save multi-line hist as one line
shopt -s checkwinsize               ## Update col/lines after commands
shopt -s autocd 2>/dev/null         ## Can change dir without `cd`
shopt -s cdspell                    ## Fixes minor spelling errors in cd paths
shopt -s no_empty_cmd_completion    ## Stops empty line tab comp
shopt -s dirspell 2>/dev/null       ## Tab comp can fix dir name typos

# completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | \
  sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | \
  sed -e s/,.*//g | uniq | grep -v "\["`;)" ssr
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | \
  sed -e s/,.*//g | uniq | grep -v "\["`;)" ssa
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | \
  sed -e s/,.*//g | uniq | grep -v "\["`;)" sss
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | \
  sed -e s/,.*//g | uniq | grep -v "\["`;)" ping

# prompt
__prompt_command() {
  local exit_code="$?"
  local RCol='\[\e[0m\]'
  local Red='\[\e[0;31m\]'
  local Gre='\[\e[0;32m\]'
  local LGre='\[\e[1;32m\]'
  local BYel='\[\e[1;33m\]'
  local BBlu='\[\e[1;34m\]'
  local Pur='\[\e[0;35m\]'

  if [[ "${exit_code}" != 0 ]];then
    #local clock_var="${Red}[$(date +%T)]\e[10D"
    #clock_var+="$(printf "[%8s]" "${exit_code}")"
    local clock_var="${RCol}[\A$(printf "${Red}%3s${RCol}" "${exit_code}")]"
  else
    local clock_var="${RCol}[\t]"
  fi
  local cur_dir="${BBlu}\w"

  local virt_env_prefix=''
  if [[ ! -z ${VIRTUAL_ENV+x} ]]; then
    virt_env_prefix="($(basename "$VIRTUAL_ENV")) "
  fi

  PS1="${virt_env_prefix}${clock_var}${RCol}${debian_chroot:+($debian_chroot)} ${LGre}\h ${cur_dir}${RCol}\n\$ "

  # https://stackoverflow.com/questions/16715103/bash-prompt-with-last-exit-code
  # https://github.com/demure/dotfiles/blob/master/subbash/prompt
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color)
    color_prompt=yes
    ;;
  xterm*|rxvt*)
    # If this is an xterm set the title to user@host:dir
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi


if [ "$color_prompt" = yes ]; then
  PROMPT_COMMAND=__prompt_command
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w '
fi

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r"

unset color_prompt force_color_prompt

#PATH
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

export HISTCONTROL=ignoreboth
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT='%F %T '

export EDITOR="vim"

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
