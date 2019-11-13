function dl () {
    cd ~/Downloads
    if [[ -n "$2" ]]; then
        noglob aria2c -x 16 -s 64 "$1" -o "$2"
    else
        noglob aria2c -x 16 -s 64 "$1"
    fi
}
alias dl='noglob dl'

# svi -- edit pipe stream with vim
function svi() { () { vim $1 </dev/tty >/dev/tty && cat $1 } =(cat) }

function c() {
    bc -l <<< "$@"
}
alias c="noglob c"

function fh() {
    eval $(
        ([ -n "$ZSH_NAME" ] && fc -l 1 || history) \
            | fzf +s --tac \
            | sed 's/ *[0-9]* *//'
    )
}

# g -- call grep recursively with useful defaults
# http://chneukirchen.org/dotfiles/.zshrc
unalias g
function g() {
    LC_ALL=C grep \
        ${${(M)@:#+*}:s/+/--include=*./} \
        --exclude "*~" --exclude "*.o" --exclude "tags" \
        --exclude-dir .bzr --exclude-dir .git --exclude-dir .hg --exclude-dir .svn \
        --exclude-dir CVS  --exclude-dir RCS --exclude-dir _darcs \
        --exclude-dir _build \
        --line-buffered -r -P ${${@:#+*}:?regexp missing}
}
function gg() {
    local p=$argv[-1]
    (( ARGC > 1 )) && { git rev-parse -q --verify $p >/dev/null || [ -d $p ] } &&
        argv[-1]=() || p='HEAD'
    LC_ALL=C git grep -P ${@:?regexp missing} $p
}

# n -- quickest note taker
function n() { [[ $# == 0 ]] && tail ~/.n || echo "$(date +'%F %R'): $*" >>~/.n }
alias n=' noglob n'

# zombies - list all zombies and their parents to kill
zombies() {
  ps f -eo state,pid,ppid,comm | awk '
    { cmds[$2] = $NF }
    /^Z/ { print $(NF-1) "/" $2 " zombie child of " cmds[$3] "/" $3 }'
}
# wat - a better and recursive which/whence
function wat() {
    ( # constrain unalias
    for cmd; do
        if (( $+aliases[$cmd] )); then
            printf '%s: aliased to %s\n' $cmd $aliases[$cmd]
            local -a words=(${${(z)aliases[$cmd]}:#(*=*|rlwrap|noglob|command)})
            unalias $cmd
            if [[ $words[1] == '\'* ]]; then
                words[1]=${words[1]#'\'}
                unalias $words[1] 2>/dev/null
            fi
            wat $words[1]
        elif (( $+functions[$cmd] )); then
            whence -v $cmd
            whence -f $cmd
        elif (( $+commands[$cmd] )); then
            wat $commands[$cmd]
        elif [[ -h $cmd ]]; then
            file $cmd
            wat $cmd:A
        elif [[ -x $cmd ]]; then
            file $cmd
        else
            which $cmd
        fi
    done
    )
}
compdef wat=which

zsh_stats_better() {
    fc -l 1 \
        | sed -E 's/(;|&&|\|\|)/\nnull /g' \
        | awk '{
              CMD[$2]++;
              count++;
            } END {
              for (a in CMD) print CMD[a] " " CMD[a]/count*100 "% " a;
            }' \
        | grep --color -v "./" \
        | column -c3 -s " " -t \
        | sort -nr \
        | nl \
        | head -n20
}

zshupdate () {
    usage () {
        echo -e "-a all\n-o omz\n-p p10k"
    }

    git=/usr/bin/git
    repo_omz="${ZSH}"
    repo_p10k="${ZSH_CUSTOM}/themes/powerlevel10k"

    while getopts alop opt; do
        case $opt in
            a) mode=all  ;;
            o) mode=omz  ;;
            p) mode=p10k ;;
            ?|*) usage
        esac
    done

    if [[ $mode == "omz" || $mode == "all" ]]; then
        $git --git-dir "$repo_omz/.git" --work-tree "$repo_omz" log -1
        $git --git-dir "$repo_omz/.git" --work-tree "$repo_omz" pull --ff-only
    fi
    if [[ $mode == "p10k" || $mode == "all" ]]; then
        $git --git-dir "$repo_p10k/.git" --work-tree "$repo_p10k" log -1
        $git --git-dir "$repo_p10k/.git" --work-tree "$repo_p10k" pull --ff-only
    fi
}

zshmode () {
    # kunde|customer|audit -> if 3rd party sees stuff
    #   no autosuggestions
    # copy -> for tickets
    #   no rprompt
    echo
}
