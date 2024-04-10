export GPG_TTY=$TTY
export EDITOR=nvim
#export PAGER='vim -u ~/.config/vim/vimrc.less -'
# This affects every invocation of `less`.
#   -R   color
#   -F   exit if there is less than one page of content
#   -X   keep content on screen after exit
#   -M   show more info at the bottom prompt line
#   -x4  tabs are 4 instead of 8
export LESS='-iR'
export SYSTEMD_PAGER='cat'
export TIMEFMT="%J  %U user %S system %P cpu %MM memory %*E total"
export MAILCHECK=0
export WORDCHARS='-'    # ignore these chars on ctrl-w
LISTMAX=0               # In the line editor, the number of matches to list without asking first.
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export SCREENRC="${XDG_CONFIG_HOME:-$HOME/.config}/screen/screenrc"
