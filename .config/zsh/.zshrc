# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Export XDG environment variables. Other environment variables are exported later.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/${UID}}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
# ZDOTDIR is set in .profile to have it available before window manager starts
# and thus before zsh starts. Alternatives: .xinitrc, .pam_environment (deprecated)
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Automaticaly wrap TTY with a transparent tmux ('integrated'), or start a
# full-fledged tmux ('system'), or disable features that require tmux ('no').
zstyle ':z4h:' start-tmux       'no'
# Move prompt to the bottom when zsh starts up so that it's always in the
# same position. Has no effect if start-tmux is 'no'.
zstyle ':z4h:' prompt-at-bottom 'no'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard 'pc'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
    --color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
# Set key bindings for fzf menus
# toggle-all: only for fzf-complete
# repeat: `accept`s for fzf-history and fzf-dir-history
zstyle ':z4h:(fzf-complete|fzf-history|fzf-dir-history|cd-down)' \
                              fzf-bindings     'tab:repeat' \
                                               'ctrl-a:toggle-all' \
                                               'ctrl-k:up' 'ctrl-j:down'
zstyle ':z4h:fzf-complete'    fzf-flags        ${=FZF_DEFAULT_OPTS} \
                                               --no-exact  # EXPERIMENTAL
zstyle ':z4h:fzf-history'     fzf-flags        ${=FZF_DEFAULT_OPTS} \
                                               --preview-window=down:20%:wrap --height 50% # history extra flags
zstyle ':z4h:*'               fzf-flags        ${=FZF_DEFAULT_OPTS}

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char     'partial-accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# ssh when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over ssh to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' "${ZDOTDIR}/env.zsh"

# Move the cursor to the end when Up/Down fetches a command from history?
zstyle ':zle:up-line-or-beginning-search'   leave-cursor 'yes'
zstyle ':zle:down-line-or-beginning-search' leave-cursor 'yes'

# Misc
zstyle ':z4h:' iterm2-integration 'yes'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return
z4h install so-fancy/diff-so-fancy || return
z4h install alexanderjeurissen/ranger_devicons || return
z4h install SL-RU/ranger_udisk_menu || return
z4h install Syphdias/prenv || return
#z4h install zsh-users/zsh-history-substring-search || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY
PROMPT_EOL_MARK=$'%{\e]8;;\a\e]8;;\a%}%K{red} %k'  # reset OSC 8: romkatv/powerlevel10k#2148

# Source additional local files if they exist.
z4h source "${ZDOTDIR}/env.zsh"

# Ghostty shell integration
z4h source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"

# Extend PATH further
[[ -n "$GOPATH" ]] && path+=($GOPATH/bin)
[[ -n "$PYENV_ROOT" ]] && path+=($PYENV_ROOT/bin)

# Use additional Git repositories pulled in with `z4h install`.
plugins=(               # needed?
    #command-not-found  # maybe
    extract             # yes
    git                 # maybe
    git-auto-fetch      # yes
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

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace
z4h bindkey backward-kill-line  Ctrl+U
# emacsification of viins
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^[.' insert-last-word
# TODO: set z4h vi keys
z4h source ${ZDOTDIR}/z4h-keybinds.zsh # rebinding viins, vicmd
z4h source ${ZDOTDIR}/keybinds.zsh # more complex stuff
z4h source $Z4H/Syphdias/prenv/prenv.zsh
z4h source $Z4H/Syphdias/prenv/_prenv
z4h source $Z4H/Syphdias/prenv/prenv-p10k-segment.zsh


# rebind Shift+Arrow to same as Ctrl-Arrow
#for l in {A..D}; do bindkey -s '^[[1;2'$l '^[[1;5'$l; done
# rebind Alt+jk to same as Arrows Up/Down (will overwrite (parent/child) cd)
bindkey -s '^[k' '^[[A' # z4h-up-substring-local
bindkey -s '^[j' '^[[B' # z4h-down-substring-local

# Sort completion candidates when pressing Tab? TODO: rm this?
#zstyle ':completion:*'                           sort               false
#zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}" "l:|=* r:|=*"   # from romkatv
#zstyle ':completion:*' matcher-list "m:{a-z}={A-Z}"                 # z4h default
#                        case-insensitive,hyphen-insensitive   ?????   same-as-romkatv
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# Autoload functions.
autoload -Uz zmv

z4h source "${ZDOTDIR}/alias.zsh"                    # Define aliases, functions and completions.
z4h source "${ZDOTDIR}/utils.zsh"                    # Essential tools for me
z4h source "${ZDOTDIR}/function.zsh"                 # Define functions and completions
z4h source "${ZDOTDIR}/$(hostnamectl hostname 2>/dev/null || hostname -s).zsh"  # Host-specific functions, etc.
z4h source "${ZDOTDIR}/after-p10k-lean.zsh"
z4h source "${ZDOTDIR}/gitrepos.zsh"
z4h source "${ZDOTDIR}/openstack.zsh"
z4h source "${ZDOTDIR}/completion.zsh"

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

# Define named directories
hash -d o=~/Documents/obsidian-palace/
[[ -n $z4h_win_home ]] && hash -d w=$z4h_win_home  # ~w <=> Windows home directory on WSL.

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
