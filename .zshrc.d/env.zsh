# man zshoptions # http://zsh.sourceforge.net/Doc/Release/Options.html
# TODO: ???
#setopt appendhistory autocd extendedglob nomatch notify

# TODO: find out if I want these
# http://chneukirchen.org/dotfiles/.zshrc
setopt NO_BEEP
# setopt C_BASES
# setopt OCTAL_ZEROES
# setopt PRINT_EIGHT_BIT
# setopt SH_NULLCMD
# setopt AUTO_CONTINUE
# setopt NO_BG_NICE
# setopt PATH_DIRS
# setopt NO_NOMATCH
# setopt EXTENDED_GLOB
# disable -p '^'
# 
setopt LIST_PACKED # make the completion list smaller
# setopt BASH_AUTO_LIST
# setopt NO_AUTO_MENU
# setopt NO_CORRECT
# setopt NO_ALWAYS_LAST_PROMPT
# setopt NO_FLOW_CONTROL
#
# https://github.com/romkatv/dotfiles-public/blob/master/.zshrc
# setopt HIST_IGNORE_SPACE     # don't add commands starting with space to history
# setopt HIST_VERIFY           # if a cmd triggers history expansion, show it instead of running
# setopt HIST_REDUCE_BLANKS    # remove junk whitespace from commands before adding to history
# setopt EXTENDED_GLOB         # (#qx) glob qualifier and more
# setopt NO_BANG_HIST          # disable old history syntax
# setopt GLOB_DOTS             # glob matches files starting with dot; `*` becomes `*(D)`
# setopt MULTIOS               # allow multiple redirections for the same fd
# setopt NO_BG_NICE            # don't nice background jobs; not useful and doesn't work on WSL

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt INTERACTIVECOMMENTS

LISTMAX=0       # In the line editor, the number of matches to list without asking first.
# REPORTTIME=60
TIMEFMT="%J  %U user %S system %P cpu %MM memory %*E total"
MAILCHECK=0


# export stuff
#export PATH="${HOME}/.local/bin:${HOME}/bin:/usr/local/bin:${PATH}"
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH="$HOME/go"
export PATH="${HOME}/.local/bin:$PYENV_ROOT/bin:/usr/local/bin:$GOPATH/bin:${HOME}/bin:${PATH}"

export EDITOR='vim'
export TERMINAL=tilix
#export PAGER='vim -u ~/.vimrc.less -'
# This affects every invocation of `less`.
#   -R   color
#   -F   exit if there is less than one page of content
#   -X   keep content on screen after exit
#   -M   show more info at the bottom prompt line
#   -x4  tabs are 4 instead of 8
export LESS='-iR'


# history stuff
HISTFILE=~/.histfile
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTFILESIZE=1000000000
HIST_STAMPS="yyyy-mm-dd"

