# probably alread done by oh-my-zsh
# zmodload zsh/complist
# autoload -Uz compinit && compinit
# load bashcompinit for some old bash completions; then source bashcomplete file
# autoload bashcompinit && bashcompinit

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' special-dirs ..    # offer `..`

# Disable requiring a prefix, e.g. `git <tab>` -> offer nothing if setting is true
# (not all completion even honors this setting, e.g. git...)
zstyle ':completion::complete:*::options' prefix-needed false


# TODO: include recommendations /etc/zsh/newuser.zshrc.recommended
# TODO: find out if I want these
# http://chneukirchen.org/dotfiles/.zshrc
# zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' special-dirs ..
# zstyle ':completion:*' accept-exact-dirs true
# zstyle ':completion:*' use-ip true
# zstyle ':completion::*' insert-tab pending=1
# zstyle ':completion::complete:*' use-cache on
# zstyle ':completion::complete:*' rehash true
# 
# zstyle ':completion:*:functions' ignored-patterns '_*'
# zstyle ':completion:*:*:*:*:processes*' force-list always
# zstyle ':completion:*:*:kill:*:processes' insert-ids single
# zstyle ':completion:*:*:kill:*:processes' sort false
# zstyle ':completion:*:*:kill:*:processes' command 'ps -u "$USER"'
# zstyle ':completion:*:processes-names' command "ps -eo cmd= | sed 's:\([^ ]*\).*:\1:;s:\(/[^ ]*/\)::;/^\[/d'"
# zstyle ':completion:*:evince::' file-patterns '*.(#i)(dvi|djvu|tiff|pdf|ps|xps)(|.bz2|.gz|.xz|.z) *(-/)' '*'
# compdef pkill=killall
# compdef ping6=ping
# compdef _gnu_generic curl emacs emacsclient file head mv paste
# compdef _gnu_generic tail touch scrot shred watch wc zsh
# 
# # Don't complete the same twice for kill/diff.
# zstyle ':completion:*:(kill|diff):*'       ignore-line yes
# 
# # Don't complete from PATH for sh and rc.
# zstyle ':completion:*:(sh|rc):*' tag-order '! commands builtins' -
# 
# # Don't complete backup files as commands.
# zstyle ':completion:*:complete:-command-::*' ignored-patterns '*\~'
# 
# # Don't complete .pdf for less.
# zstyle ':completion:*:less:*' file-patterns '*~*.pdf'
# 
# # Cycle through history completion (M-/, M-,).
# zstyle ':completion:history-words:*:history-words' stop yes
# zstyle ':completion:history-words:*:history-words' list no
# zstyle ':completion:history-words:*' remove-all-dups yes

## add the ability to print >> << for the portion of the cli we'll be using
#autoload -Uz narrow-to-region
#
#function _history-incremental-preserving-pattern-search-backward
#{
#  local state
#  MARK=CURSOR  
#  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
#  zle end-of-history
#  zle history-incremental-pattern-search-backward
#  narrow-to-region -R state
#}
#
## load the function into zle
#zle -N _history-incremental-preserving-pattern-search-backward
#
## bind it to ctrl+r
#bindkey "^R" _history-incremental-preserving-pattern-search-backward
#bindkey -M isearch "^R" history-incremental-pattern-search-backward
#bindkey "^S" history-incremental-pattern-search-forward
