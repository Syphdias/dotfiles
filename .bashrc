# If not running interactively, don't do anything
# this! https://github.com/demure/dotfiles

if [ -d $HOME/.bashrc.d ]; then
  unset a i
  while IFS= read -r -d $'\0' file; do
    source $file
  done < <(find -L $HOME/.bashrc.d -type f -not -name *.swp -print0)
fi

case $- in
    *i*) ;;
      *) return;;
esac

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

source "$HOME/.local/bin/virtualenvwrapper.sh"

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
