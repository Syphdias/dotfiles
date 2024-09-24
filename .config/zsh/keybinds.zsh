z4h bindkey z4h-forward-word Alt+L

foreground-vi() {
    fg %nvim 2>/dev/null || fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi

# expand on undo
bindkey "^_" undo
# https://www.zsh.org/mla/users/2015/msg00652.html
after_zle-line-init () {
    if [[ -n $ZLE_LINE_ABORTED ]]; then
        local savebuf="$BUFFER" savecur="$CURSOR"
        BUFFER="$ZLE_LINE_ABORTED"
        CURSOR="$#BUFFER"
        zle split-undo
        BUFFER="$savebuf" CURSOR="$savecur"
    fi
}
bindkey "^[_" redo

# patching it dirtly
# https://unix.stackexchange.com/questions/450043/overwrite-and-reuse-existing-function-in-zsh
functions[zle-line-init]="
    $functions[zle-line-init]
    after_zle-line-init
"


# cd on keybind
z4h bindkey z4h-cd-up               Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down             Alt+Down   # cd into a child directory
z4h bindkey z4h-cd-back-or-cached   Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward          Alt+Right  # cd into the next directory

# cd back into last_cd if shell just started
function z4h-cd-back-or-cached() {
    if [[ -f ${XDG_CACHE_HOME:-~/.cache}/last_cd && ${#$(dirs -v)} == 2 ]]; then
        cd $(<${XDG_CACHE_HOME:-~/.cache}/last_cd)
        # This must run with user options (because of reset-prompt).
        local f
        for f in chpwd "${chpwd_functions[@]}" precmd "${precmd_functions[@]}"; do
            [[ "${+functions[$f]}" == 0 ]] || "$f" &>/dev/null || true
        done
        zle .reset-prompt
        zle -R
    else
        z4h-cd-back
    fi
}
zle -N z4h-cd-back-or-cached

# automatically save last cd to last_cd
function set-cd-cache() {
    if [[ $PWD != ~ ]]; then
        echo "${PWD}" >| ${XDG_CACHE_HOME:-~/.cache}/last_cd
    fi
}
add-zsh-hook chpwd set-cd-cache

# manually save pwd to last_cd
alias d='echo "${PWD}" > ~/.cache/last_cd'

# autojump to last_cd if it was modified in the last 10s
if [[ -f ${XDG_CACHE_HOME:-~/.cache}/last_cd \
        && ${#$(dirs -v)} == 2 \
        && $(zstat -F '%s' +mtime -- ${XDG_CACHE_HOME:-~/.cache}/last_cd) -ge $(date +%s)-10 \
    ]]; then
    cd "$(<${XDG_CACHE_HOME:-~/.cache}/last_cd)"
fi

bindkey -v
# non default working vi mode bindings
for keymap in viins vicmd; do
    bindkey -M $keymap '^[[1;5D' z4h-backward-word
    bindkey -M $keymap '^[[1;5C' z4h-forward-word
    bindkey -M $keymap '^[[F'    end-of-line                    # end
done

# TODO: What do I want? http://chneukirchen.org/dotfiles/.zshrc
# # Disable bracketed paste.
# unset zle_bracketed_paste
#
# # This is even better than copy-prev-shell-word, can be called repeatedly.
# autoload -Uz copy-earlier-word
# zle -N copy-earlier-word
# bindkey "^[m" copy-earlier-word
#
# # Remove prompt on line paste (cf. last printed char in cnprompt6).
# bindkey -s $nbsp '^u'
#
# # Shortcut for ' inside ' quoting
# bindkey -s "\C-x'" \''\\'\'\'
#
# # Expand to two last commands
# bindkey -s "\C-x2" '!-2\t ; !-1\t'
#
# # Standard keybindings
# [[ -n $terminfo[khome] ]] && bindkey $terminfo[khome] beginning-of-line
# [[ -n $terminfo[kend]  ]] && bindkey $terminfo[kend]  end-of-line
# [[ -n $terminfo[kdch1] ]] && bindkey $terminfo[kdch1] delete-char
# [[ -n $terminfo[kpp]   ]] && bindkey $terminfo[kpp] backward-word
# [[ -n $terminfo[knp]   ]] && bindkey $terminfo[knp] forward-word
# [[ -n $terminfo[kpp]   ]] && bindkey -M menuselect $terminfo[kpp] backward-word
# [[ -n $terminfo[knp]   ]] && bindkey -M menuselect $terminfo[knp] forward-word
#
# # Move by physical lines, like gj/gk in vim
# _physical_up_line()   { zle backward-char -n $COLUMNS }
# _physical_down_line() { zle forward-char  -n $COLUMNS }
# zle -N physical-up-line _physical_up_line
# zle -N physical-down-line _physical_down_line
# bindkey "\e\e[A" physical-up-line
# bindkey "\e\e[B" physical-down-line
#
# # M-DEL should stop at /.
# WORDCHARS="*?_-.[]~&;$%^+"
#
# # backward-kill-default-word (with $WORDCHARS from zsh -f and :)
# _backward_kill_default_word() {
#   WORDCHARS='*?_-.[]~=/&:;!#$%^(){}<>' zle backward-kill-word
# }
# zle -N backward-kill-default-word _backward_kill_default_word
# bindkey '\e=' backward-kill-default-word   # = is next to backspace
#
# # transpose-words acts on shell words
# autoload -Uz transpose-words-match
# zstyle ':zle:transpose-words' word-style shell
# zle -N transpose-words transpose-words-match
#
# # History search with globs.
# autoload -Uz narrow-to-region
# _history-incremental-preserving-pattern-search-backward() {
#   local state
#   MARK=CURSOR  # magick, else multiple ^R don't work
#   narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
#   zle end-of-history
#   zle history-incremental-pattern-search-backward
#   narrow-to-region -R state
# }
# zle -N _history-incremental-preserving-pattern-search-backward
# bindkey "^R" _history-incremental-preserving-pattern-search-backward
# bindkey -M isearch "^R" history-incremental-pattern-search-backward
# bindkey -M isearch -s ' ' '*'
# bindkey -M isearch -s '  ' '[[:blank:]]'
# bindkey "^S" history-incremental-pattern-search-forward
#
# # Quote stuff that looks like URLs automatically.
# autoload -U url-quote-magic
# zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
# zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='  # dropped { }
# zle -N self-insert url-quote-magic
#
# # Edit command line with $VISUAL.
# autoload -z edit-command-line
# zle -N edit-command-line
# bindkey "^X^E" edit-command-line
#
# # Force file name completion on C-x TAB, Shift-TAB.
# autoload -Uz match-words-by-style
# _args() {
#   local -a ign
#   match-words-by-style
#   [[ -z "$matched_words[3]" ]] && ign=("$matched_words[2]$matched_words[5]")
#   compadd -F ign -- ${(Q)${(z)BUFFER}}
# }
# zle -C complete-files complete-word _generic
# zstyle ':completion:complete-files:*' completer _files _args
# zstyle ':completion:complete-files:*' force-list always
# bindkey "^X^I" complete-files
# bindkey "^[[Z" complete-files
#
# # Force menu on C-f.
# zle -C complete-menu menu-select _generic
# _complete_menu() {
#   setopt localoptions alwayslastprompt
#   zle complete-menu
# }
# zle -N _complete_menu
# bindkey '^F' _complete_menu
# bindkey -M menuselect '^F' accept-and-infer-next-history
# bindkey -M menuselect '/'  accept-and-infer-next-history
# bindkey -M menuselect '^?' undo
# bindkey -M menuselect ' ' accept-and-hold
# bindkey -M menuselect '*' history-incremental-search-forward
#
# # Move to where the arguments belong.
# after-first-word() {
#   zle beginning-of-line
#   zle forward-word
# }
# zle -N after-first-word
# bindkey "^X1" after-first-word
#
# # Scroll up in tmux on PageUp.
# _tmux_copy_mode() { tmux copy-mode -eu }
# zle -N _tmux_copy_mode
# [[ $TMUX_PANE && -n $terminfo[kpp] ]] && bindkey $terminfo[kpp] _tmux_copy_mode
#
# # fg editor on ^Z
# foreground-vi() { fg %vi }
# zle -N foreground-vi
# bindkey '^Z' foreground-vi
#
# # Allow to recover from C-c or failed history expansion (thx Mikachu).
# _recover_line_or_else() {
#   if [[ -z $BUFFER && $CONTEXT = start && $zsh_eval_context = shfunc
#         && -n $ZLE_LINE_ABORTED
#         && $ZLE_LINE_ABORTED != $history[$((HISTCMD-1))] ]]; then
#     LBUFFER+=$ZLE_LINE_ABORTED
#     unset ZLE_LINE_ABORTED
#   else
#     zle .$WIDGET
#   fi
# }
# zle -N up-line-or-history _recover_line_or_else
# _zle_line_finish() { ZLE_LINE_ABORTED=$BUFFER }
# zle -N zle-line-finish _zle_line_finish
#
# # Inject mkdir call to create the dirname of the current argument.
# autoload -Uz modify-current-argument
# _mkdir_arg() {
#   local arg=
#   modify-current-argument '${arg:=$ARG}'
#   zle push-line
#   LBUFFER="    mkdir -p $arg:h"
#   RBUFFER=
# }
# zle -N mkdir-arg _mkdir_arg
# bindkey '^[M' mkdir-arg
#
# # Keep an archive of all commands typed.
# # Initialize using:
# #   cat /data/dump/juno/2015<->/home/chris/.zsh_history | sort -u | grep '^:' |
# #     gawk -F: '{print $0 >> "chris@juno-" strftime("%Y-%m-%d", $2)}'
# mkdir -p ~/.zarchive
# zshaddhistory() {
#   local words=( ${(z)1} )
#   local w1=$words[1]
#   (( $+aliases[$w1] )) && w1=$aliases[$w1]
#   if [[ -n $1 && $1 != $'\n' && $w1 != " "* ]]; then
#     printf ': %s:%s:0;%s' ${(%):-'%D{%s}'} ${(%):-%~} "$1" >> \
#       ~/.zarchive/${(%):-%n@%m-'%D{%Y-%m-%d}'}
#   fi
# }
#
# # za WORDS... - search .zarchive for WORDS
# za() {
#   grep -a -r -e "${(j:.*:)@}" ~/.zarchive |
#     sed 's/[ \t]*$//' |
#     sort -r | sort -t';' -k2 -u | sort |
#     sed $'s,^[^:]*/,,; s,::[^;]*;,\u00A0\u00A0,'
# }
# alias za=' za'
#
# # zd [WORDS...] - list last commands in PWD from .zarchive
# zd() {
#   grep -a -r -e :${(%):-%~}: ~/.zarchive |
#     sed 's/[ \t]*$//' |
#     sort -r | sort -t';' -k2 -u | sort |
#     awk -F: -v dir=${(%):-%~} '$4 == dir && $5 ~ /^0;/' |
#     sed $'s,^[^:]*/,,; s,::[^;]*;,\u00A0\u00A0,'
# }
# alias zd=' zd'
