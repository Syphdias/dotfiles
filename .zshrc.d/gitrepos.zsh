function toggle-gitdir() {
    () {
        emulate -L zsh
        local -a repos=("${XDG_CONFIG_HOME:-${HOME}/.config}/dotgit"/*(/))
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

# TODO chpwd hook
# - reset on cd into git repo
#   command env -u GIT_DIR git -C . rev-parse -q
# - maybe: reset on cd into non managed dir
#   git ls-files | sed "s,^,$(git rev-parse --show-toplevel)/,;s,/[^/]*$,," |sort |uniq
# - hook is also being called in toggle-gitdir
function un-git-dir() {
    if [[ -n "$GIT_DIR" ]] && command env -u GIT_DIR git -C . rev-parse 2>&- >&-; then
        echo -e "\e[33mWARNING: \e[31mGIT_DIR\e[33m ist still set\e[0m" >&2
        #unset GIT_DIR
        #unset GIT_WORK_TREE
    fi
}
add-zsh-hook chpwd un-git-dir

