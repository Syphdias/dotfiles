# Documentation: https://github.com/romkatv/zsh4humans/blob/v3/README.md.
# fixes https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte*.sh
fi

# Export XDG environment variables. Other environment variables are exported later.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/${UID}}"

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
zstyle ':z4h:'                auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:'                auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey'         keyboard         'pc'
# When fzf menu opens on TAB, another TAB moves the cursor down ('tab:down')
# or accepts the selection and triggers another TAB-completion ('tab:repeat')?
zstyle ':z4h:fzf-complete'    fzf-bindings     'tab:repeat' \
                                               'ctrl-a:toggle-all' 'ctrl-k:up'
#zstyle ':z4h:(fzf-complete|fzf-history|cd-down)' fzf-bindings 'ctrl-k:up'
zstyle ':z4h:fzf-complete'    fzf-flags        --no-exact   # EXPERIMENTAL
#zstyle ':z4h:fzf-history'    fzf-bindings     'tab:repeat' # history key binds
zstyle ':z4h:fzf-history'     fzf-flags        --no-preview # history extra flags

# When fzf menu opens on Alt+Down, TAB moves the cursor down ('tab:down')
# or accepts the selection and triggers another Alt+Down ('tab:repeat')?
zstyle ':z4h:cd-down'         fzf-bindings     'tab:down'
# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char     'partial-accept'

# Send these files over to the remote host when connecting over ssh.
# Multiple files can be listed here.
zstyle ':z4h:ssh:*'           send-extra-files '~/.iterm2_shell_integration.zsh'
# Disable automatic teleportation of z4h over ssh when connecting to some-host.
# This makes `ssh some-host` equivalent to `command ssh some-host`.
zstyle ':z4h:ssh:some-host'   passthrough      'yes'

# Move the cursor to the end when Up/Down fetches a command from history?
zstyle ':zle:up-line-or-beginning-search'   leave-cursor 'yes'
zstyle ':zle:down-line-or-beginning-search' leave-cursor 'yes'

# Clone additional Git repositories from GitHub. This doesn't do anything
# apart from cloning the repository and keeping it up-to-date. Cloned
# files can be used after `z4h init`.
z4h install ohmyzsh/ohmyzsh || return
z4h install so-fancy/diff-so-fancy || return
#z4h install zsh-users/zsh-history-substring-search || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Export environment variables.
export TERMINAL=tilix
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
export GPG_TTY=$TTY
export TIMEFMT="%J  %U user %S system %P cpu %MM memory %*E total"
export MAILCHECK=0
export WORDCHARS='-'    # ignore these chars on ctrl-w
LISTMAX=0               # In the line editor, the number of matches to list without asking first.
export PYENV_ROOT="$HOME/.pyenv"
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export SCREENRC="${XDG_CONFIG_HOME:-$HOME/.config}/screen/screenrc"

# Extend PATH.
path=(~/.local/bin $PYENV_ROOT/bin /usr/local/bin $GOPATH/bin ~/bin $path)

# Use additional Git repositories pulled in with `z4h install`.
plugins=(
    #command-not-found  # maybe
    extract             # needed
    git                 # maybe
    git-auto-fetch      # needed
)
for plugin in $plugins; do
    z4h source $Z4H/ohmyzsh/ohmyzsh/plugins/$plugin/$plugin.plugin.zsh
done
fpath+=(
    $Z4H/ohmyzsh/ohmyzsh/plugins/pass
    $Z4H/ohmyzsh/ohmyzsh/plugins/extract
    $Z4H/ohmyzsh/ohmyzsh/plugins/docker     # maybe (why is it not in the package?)
    $Z4H/ohmyzsh/ohmyzsh/plugins/docker-compose
)

# Source additional local files if they exist.
z4h source ~/.iterm2_shell_integration.zsh
z4h source /usr/share/autojump/autojump.zsh

# Define key bindings.
bindkey -e
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace
z4h bindkey backward-kill-line  Ctrl+U
#bindkey '^[o'        z4h-stash-buffer      # save buffer to "history" but not to HISTFILE
# emacsification of viins
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^[.' insert-last-word
bindkey -M viins '^[h' z4h-run-help
# TODO: set z4h vi keys
z4h source ~/.zshrc.d/z4h-keybinds.zsh # rebinding viins, vicmd
z4h source ~/.zshrc.d/keybinds.zsh # more complex stuff

# cd on keybind
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory
#z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory

# rebind Shift+Arrow to same as Ctrl-Arrow
for l in {A..D}; do bindkey -s '^[[1;2'$l '^[[1;5'$l; done
# rebind Alt+jk to same as Arrows Up/Down (will overwrite (parent/child) cd)
bindkey -s '^[j' '^[[A' # z4h-up-local-history
bindkey -s '^[k' '^[[B' # z4h-down-local-history

# Sort completion candidates when pressing Tab? TODO: rm this?
#zstyle ':completion:*'                           sort               false
#zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" "l:|=* r:|=*"   # from romkatv
#zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}"                 # z4h default
#                        case-insensitive,hyphen-insensitive   ?????   same-as-romkatv
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# Autoload functions.
autoload -Uz zmv

# Define aliases, functions and completions.
z4h source ~/.zshrc.d/alias.zsh
z4h source ~/.zshrc.d/function.zsh  # Define functions and completions
z4h source ~/.$(hostname).src       # Host-specific functions, etc.
z4h source ~/.zshrc.d/after-p10k-lean.zsh
z4h source ~/.zshrc.d/gitrepos.zsh
z4h source ~/.zshrc.d/openstack.zsh

# omz completion
#z4h source $Z4H/ohmyzsh/ohmyzsh/lib/completion.zsh  # omz-complete
#bindkey '^I' expand-or-complete     # bind tab back to normal completion (from omz)
#zstyle ':completion:*' list-colors $LS_COLORS   # fix colors after omz completion
#bindkey -M menuselect '^h' vi-backward-char
#bindkey -M menuselect '^k' vi-up-line-or-history
#bindkey -M menuselect '^l' vi-forward-char
#bindkey -M menuselect '^j' vi-down-line-or-history
# do i need that?
#zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -n $z4h_win_home ]] && hash -d w=$z4h_win_home

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots           # glob matches files starting with dot; `ls *` -> `ls *(D)`
setopt no_auto_menu        # require an extra TAB press to open the completion menu
setopt no_hup              # don't send SIGHUP to background processes
setopt pushd_ignore_dups
setopt pushd_minus
setopt no_hist_ignore_dups # _do_ store duplications
setopt list_packed         # make the completion list smaller (non-fzf)
setopt extended_history    # save duration in seconds to histfile

# Load virtualenvwrapper
if [[ -f ~/.local/bin/virtualenvwrapper.sh || -f /usr/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME="${HOME}/.virtualenvs"
    export PROJECT_HOME="${HOME}/ves"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    source ~/.local/bin/virtualenvwrapper.sh 2>/dev/null || source /usr/bin/virtualenvwrapper.sh
fi
