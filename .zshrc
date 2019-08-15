[[ "$ZPROF" == true ]] && zmodload zsh/zprof
[[ "$ZDATE" == true ]] && zmodload zsh/datetime && _timer=${EPOCHREALTIME}

# fixes https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte-2.91.sh
fi

# TODO:
# comon-aliases, compleat, debian, dirhistory(autojump, fasd)
# git*, pass, pip, pylint, python, screen, tig, virtualenvwrapper
# confrc anpassen
# bash-complete? -> man zsh -> bashcompinit
  # https://stackoverflow.com/questions/3249432/can-a-bash-tab-completion-script-be-used-in-zsh
  #autoload bashcompinit
  #bashcompinit
  #source /path/to/your/bash_completion_file
#
# notes
# RPROMT is nice: e_motty, branchname framing: b_ira, ➤ ▶
# GREP_COLOR(S) LS_COLORS


DISABLE_AUTO_UPDATE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"          # is this overwirtten by zsh-autosuggestions?
DISABLE_UNTRACKED_FILES_DIRTY="true"    # probably ignored by my theme
ZSH_AUTOSUGGEST_MANUAL_REBIND=1         # speed up autosuggest
DISABLE_MAGIC_FUNCTIONS=true            # disables weird paste behaviour

plugins=(
  sudo                                  # ESC+ESC adds sudo
  #replace-command                       # ESC+1 adds vim or removes command
  autojump
  #autopep8
  common-aliases
  command-not-found
  #compleat
  dirhistory
  docker
  extract
  history
  zsh-completions
  #virtualenvwrapper
  git
  ansible
  pass
  #notes
  #incr?? https://github.com/zsh-users/zsh/blob/master/Functions/Zle/incremental-complete-word
  #zsh-syntax-highlighting               # highlights commands, parameters
  fast-syntax-highlighting
  zsh-autosuggestions                   # shows history as suggstions
  #git-autofetch
  zsh-prompt-benchmark
)

function my_source () {
    [[ -f "$1" ]] \
        && source "$1"
}

# Oh My Zsh
ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${HOME}/.oh-my-zsh-custom"
: ${ZSH_THEME=powerlevel10k/powerlevel10k}
#my_source "${HOME}/.zshrc.d/powerlevel0krc.zsh"
my_source "${HOME}/.zshrc.d/p10k-lean.zsh"
my_source "${HOME}/.zshrc.d/after-p10k-lean.zsh"
my_source "$ZSH/oh-my-zsh.sh"

my_source "${HOME}/.zshrc.d/env.zsh"
my_source "${HOME}/.zshrc.d/completion.zsh"
my_source "${HOME}/.zshrc.d/keybinds.zsh"
my_source "${HOME}/.zshrc.d/agents.zsh"
my_source "${HOME}/.zshrc.d/virtenvwrapper.zsh"

my_source "${HOME}/.bashrc.d/50_function"
my_source "${HOME}/.bashrc.d/60_alias"
my_source "${HOME}/.$(hostname).src"

my_source "${HOME}/.zshrc.d/testing.zsh"

[[ "$ZDATE" == true ]] && echo $((EPOCHREALTIME - _timer)) >&2
[[ "$ZPROF" == true ]] && zprof || true
