function md() {
    [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1"
}
compdef _directories md

function dl () {
    cd ~/Downloads
    if [[ -n "$2" ]]; then
        aria2c -x 16 -s 64 "$1" -o "$2"
    else
        aria2c -x 16 -s 64 "$1"
    fi
}
alias dl='noglob dl'
function dl+ () {
    dl $@ && vlc $_ &
}
alias dl+='noglob dl+'

# svi -- edit pipe stream with vim
function svi() { () { vim $1 </dev/tty >/dev/tty && cat $1 } =(cat) }

function fh() {
    eval $(
        ([ -n "$ZSH_NAME" ] && fc -l 1 || history) \
            | fzf +s --tac \
            | sed 's/ *[0-9]* *//'
    )
}

# g -- call grep recursively with useful defaults
# http://chneukirchen.org/dotfiles/.zshrc
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
function zombies() {
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
            whence -v -- $cmd
            whence -f -- $cmd
        elif (( $+commands[$cmd] )); then
            wat $commands[$cmd]
        elif [[ -h $cmd ]]; then
            file $cmd
            wat $cmd:A
        elif [[ -x $cmd ]]; then
            file -- $cmd
        else
            which -- $cmd
        fi
    done
    )
}
compdef wat=which

function zsh_stats_better() {
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

function gen-i3-conf () {
    source /etc/os-release
    update-conf.py -f "${XDG_CONFIG_HOME:-${HOME}/.config}/i3/config" -v
    if [[ "$ID_LIKE" == "debian" ]]; then
        sed -i \
            's/^smart_gaps/#smart_gaps/; s/^smart_borders/#smart_borders/; s/^gaps/#gaps/' \
            "${XDG_CONFIG_HOME:-${HOME}/.config}/i3/config" || true
        sed -i \
            's#command=/usr/lib/i3blocks/$BLOCK_NAME/$BLOCK_NAME#command=/usr/share/i3blocks/$BLOCK_NAME#' \
            ~/.config/i3blocks/config || true
    fi
}

function zshmode () {
    # kunde|customer|audit -> if 3rd party sees stuff
    #   no autosuggestions
    # copy -> for tickets
    #   no rprompt
    echo
}

compdef _pass notes
zstyle ':completion::complete:notes::' prefix "$HOME/.notes"
function notes() {
  PASSWORD_STORE_DIR=$HOME/.notes pass $@
}

# do git stuff for all directories in current working directory
function all () {
    cur_pwd=$(pwd)

    for i in $(ls -d *); do
        if cd ${cur_pwd}/${i}; then

            echo -e "\e[36m$(pwd)\e[0m"
            $@
            if [ $? -ne 0 ] ; then
                >&2 echo -e "\e[31mError in $(pwd)\e[0m"
            fi
            echo

        else
            >&2 echo -e "\e[31mcd to \e[36m${cur_pwd}/${i}\e[31m was not sucessfull. $@ did not execute.\e[0m"
        fi

    done

    cd ${cur_pwd}

    # feature for future:
    # - possibility for aliases
    # - sameline output for short stuff: $all +short -- git status oder all -n -- git status
    #   - echo -n "$(pwd): $(git status)"
    # - specify director(y|ies) with POSIX wildcards (e.g. all -d dir* -- doing_stuff)
    # - bug: if files in folder it will try them -> for read < find -type d
    # help page (-h|--help|no options) -> all [-n] [-d <dir|posix]> [[--] COMMAND]
    #   example --helps: ssh, tig, cp,git,vim
}

# screen hack
function rename_screen_tab () {
    echo -ne "\x1bk$@\x1b\\"
    return 0
}
if [[ "${TERM}" = screen* ]]; then
    echo
    PROMPT_COMMAND="rename_screen_tab ${USER}@${HOSTNAME%%.*};
    ${PROMPT_COMMAND}"
fi

function goodnight () {
    local delaytime="${1:-1}"
    sudo aptitude update && sudo aptitude upgrade && \
    echo -e "\e[31m" && sudo shutdown -h ${delaytime} 2>&1 && echo -e "\e[0m"
}

function ggrep () {
    # just branches + remotes
    git branch -a | tr -d \* | sed '/->/d' | xargs git grep "$1"

    # all revs
    #git grep "$1" $(git rev-list --all)

    #git rev-list --all | (
    #  while read revision; do
    #    git grep -F "$1" $revision
    #  done
    #)
}

function llrec () {
    local f="$1"
    while true; do
        ls -ld "$f"
        f=$(dirname "$f")
        if [[ "$f" == "/" || "$f" == "." ]]; then
            ls -ld "$f"
            break
        fi
    done | column -t
}

function copymode() {
    # features:
    #   - https://github.com/bhilburn/powerlevel9k#disabling--enabling-powerlevel9k
    #     prompt_powerlevel9k_teardown + prompt_powerlevel9k_setup
    #   - ZHS + BASH
    #   - /tmp/copymode.$$ ?
    # ZSH
    echo "icons[LEFT_SEGMENT_SEPARATOR]=$icons[LEFT_SEGMENT_SEPARATOR]" > /tmp/copymode
    echo "POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=($POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS)" >> /tmp/copymode
    echo "POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=($POWERLEVEL9K_LEFT_PROMPT_ELEMENTS)" >> /tmp/copymode
    icons[LEFT_SEGMENT_SEPARATOR]='$'
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=()

    echo copymode on
}

function nocopymode() {
    source /tmp/copymode
    echo copymode off
}

function cs() {
    wal -i "~/Pictures/1440p" --iterative $@
}

function profzsh() {
    shell=${1-$SHELL}
    ZPROF=true $shell -i -c exit
}

function timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do time $shell -i -c exit; done
}

function mans(){
    man -k . \
    | fzf -n1,2 --preview "echo {} \
    | cut -d' ' -f1 \
    | sed 's# (#.#' \
    | sed 's#)##' \
    | xargs -I% man %" --bind "enter:execute: \
      (echo {} \
      | cut -d' ' -f1 \
      | sed 's# (#.#' \
      | sed 's#)##' \
      | xargs -I% man % \
      | less -R)"
}

function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
  | fzf --ansi --preview "echo {} \
    | grep -o '[a-f0-9]\{7\}' \
    | head -1 \
    | xargs -I % sh -c 'git show --color=always %'" \
        --bind "enter:execute:
            (grep -o '[a-f0-9]\{7\}' \
                | head -1 \
                | xargs -I % sh -c 'git show --color=always % \
                | less -R') << '-FZF-EOF'
            {}
            FZF-EOF"
}

function syu() {
    if command -v paru >/dev/null; then
        command paru -Syu --sudoloop
    elif command -v yay >/dev/null; then
        command yay -Syu --sudoloop
    elif command -v pacman >/dev/null; then
        command sudo pacman -Syu
    elif command -v aptitude >/dev/null; then
        command sudo aptitude update \
            && command sudo aptitude dist-upgrade
    elif command -v apt >/dev/null; then
        command sudo apt update \
            && command sudo apt dist-upgrade
    elif command -v yum >/dev/null; then
        command sudo yum upgrade
    fi
}

function kgetall {
    kubectl api-resources --verbs=list --namespaced -o name \
        | xargs -t -n1 kubectl get --show-kind --ignore-not-found "$@"
}
complete -F __start_kubectl kgetall

function 2os() {
    mv -i $1 ~o/_sources/
}
function _2os() {
    local files=(~/Downloads/MarkDownloads/*(.:t))
    compadd -f -q -P '~/Downloads/MarkDownloads/' -S '' -a files
}
compdef _2os 2os

function m() {
    if [[ -e ~/.cache/m-last-run && $(stat -c %Y ~/.cache/m-last-run) > $(date +%s -d -2days) ]]; then
        echo wait
    else
        syu
        flatpak update
        pipx upgrade-all
        nvim --headless '+Lazy! sync' +TSUpdateSync +qa
        dot pull
        touch  ~/.cache/m-last-run
        # needs to be last since it replaces shell
        z4h update
    fi
}

# alias is just here to make function work with POWERLEVEL9K_*_SHOW_ON_COMMAND
alias tf='terraform'
function tf() {
    # automatically read tfvars file taken form environment
    if ! [[ $* =~ "(destroy|apply|plan|import)" ]]; then
        command terraform $@
        return
    fi

    # get TF_VARFILE_<workspace> or default to TF_VARFILE
    _TF_VARFILE="${(P)${:-TF_VARFILE_${$(terraform workspace show)}}:-${TF_VARFILE}}"
    if [[ -e "${_TF_VARFILE}" ]]; then
        command terraform $1 -var-file "${_TF_VARFILE}" ${@:2}
    else
        command terraform $@
    fi
}
compdef tf=terraform
