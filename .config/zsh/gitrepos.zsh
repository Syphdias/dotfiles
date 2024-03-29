export GITWERE_ROOT="${XDG_CONFIG_HOME:-${HOME}/.config}/gitwhere"

# dotrepot utilities
function dot() {
    if [[ "$1" == "off" ]]; then
        unset GIT_DIR
        unset GIT_WORK_TREE
    elif [[ "$1" == "on" ]]; then
        if [[ -d "${GITWERE_ROOT}/$2" ]]; then
            export GIT_DIR="${GITWERE_ROOT}/$2"
        else
            export GIT_DIR="$2"
        fi
    elif [[ "$1" == "exec" ]]; then
        local TMP_GIT_DIR="$GIT_DIR"
        for d in "${GITWERE_ROOT}/"*(/); do
            echo -e "\e[33m${d}\e[0m"
            export GIT_DIR="$d"
            eval "$2"
        done
        GIT_DIR="${TMP_GIT_DIR}"
    elif [[ "$1" == "search" ]]; then
        dot ls-files \
            | grep -Fe "${GITWERE_ROOT}/" -e "$2" \
            | grep -B1 "$2" \
            | grep -F "${GITWERE_ROOT}/"
    else
        for d in "${GITWERE_ROOT}/"*(/); do
            echo -e "\e[33m${d}\e[0m"
            command git --git-dir="${d}/" $@
        done
    fi
}
compdef '_dispatch git git' dot
compdef '_files -g "${GITWERE_ROOT}/*(/)"' dot on

function gitdir() {
    export GIT_DIR="${GITWERE_ROOT}/${1}"
}


# maintenance functions
function dot-find-duplicates() {
    dot ls-files | awk '
        /\/dotgit\// {d=$1}
        ! /\/dotgit\// {count[$0]++; repo[$0]=repo[$0]""d"\n"}
        END {
            for (f in count) {
                if (count[f] > 1)
                    printf("%s in:\n%s\n", f, repo[f])
        }}'
}

# check file status
function dot-status() {
    command git status --porcelain \
        | awk '
            BEGIN {
                unstaged=0; staged=0; untracked=0
            }
            /^[MD]/  {staged++}
            /^.[MD]/ {unstaged++}
            /^\?\?/  {untracked++}
            END {
                print staged, "staged ", unstaged, "unstaged ", untracked, "untracked"
            }' \
        | sed -E $'s,([0-9]+[0-9]|[1-9]),\e[31m\\1\e[0m,g'
}

# show if in sync
function dot-up-to-date() {
    local branch_info="$(git branch -v |grep -F '*' )"
    local out="up-to-date"
    local amount=$(grep -Po '(?<=\[)(ahead|behind) [0-9]+(?=\])' <<< $branch_info)
    if [[ -n "$amount" ]]; then
        amount="${${=amount}[2]} ${${=amount}[1]}"
        out="\e[31m${(r:10:)amount}\e[0m"
    fi
    echo $out
}

# TODO: only show not synced
alias dot-utd="dot exec 'dot-up-to-date |tr -d \"\n\"; echo -n \"   \"; dot-status' NE"

# TODO: deal with broken ls-files in sysconfig repos
# TODO: check if permissions broke with sysconfig checkouts -> develop solution



# function to cycle through dotrepos with <Ctrl-N> and <Ctrl-P>
function toggle-gitdir() {
    if [[ "$1" == "reverse" ]]; then
        sorting_glob="on" # on is the default and _o_rders by _n_ame
    else
        sorting_glob="On" # On orders in reverse by name
    fi

    () {
        emulate -L zsh
        local -a repos=("${GITWERE_ROOT}"/*(/${sorting_glob}))
        local -i current_idx=repos[(I)${GIT_DIR}]

        if [[ -n "${GIT_DIR}" \
                && (${current_idx} == 0 || ${current_idx} == ${#repos}) \
            ]]; then
            # foreign git dir or last one in list
            unset GIT_DIR
            unset GIT_WORK_TREE
        else
            export GIT_DIR=${repos[${current_idx}+1]}
        fi
    }

    # This must run with user options (because of reset-prompt).
    local f
    for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
        [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
    done
    zle .reset-prompt
    zle -R
}
zle -N toggle-gitdir
bindkey '^P' toggle-gitdir

function toggle-gitdir-reverse() {
    toggle-gitdir reverse
}
zle -N toggle-gitdir-reverse
bindkey '^N' toggle-gitdir-reverse

# p10k segment
# https://github.com/romkatv/dotfiles-public/blob/ae571837d2ab612397411608fa931bc89bb7e23a/.zshrc
function prompt_my_git_dir() {
  emulate -L zsh
  [[ -n $GIT_DIR ]] || return
  local repo=${GIT_DIR:t}
  [[ $repo == .git ]] && repo=${GIT_DIR:h:t}
  #[[ $repo == .dotfiles-(public|private) ]] && repo=${repo#.dotfiles-}
  p10k segment -b 0 -f 208 -t ${repo//\%/%%}
}


# chpwd hook to warn if GIT_DIR is set but you moved to a git directory
# TODOs:
# - reset on cd into git repo
#   command env -u GIT_DIR git -C . rev-parse -q
# - maybe: reset on cd into non managed dir
#   git ls-files | sed "s,^,$(git rev-parse --show-toplevel)/,;s,/[^/]*$,," |sort |uniq
# - hook is also being called in toggle-gitdir
function un-git-dir() {
    if [[ -n "$GIT_DIR" ]] && command env -u GIT_DIR git -C . rev-parse 2>&- >&-; then
        echo -e "\e[33mWARNING: \e[31mGIT_DIR\e[33m ist still set to ${GIT_DIR}\e[0m" >&2
        #unset GIT_DIR
        #unset GIT_WORK_TREE
    fi
}
add-zsh-hook chpwd un-git-dir
