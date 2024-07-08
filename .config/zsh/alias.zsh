# vim:set syntax=sh:

# dotfiles
alias dotpublic='/usr/bin/git --git-dir="${XDG_CONFIG_HOME:-${HOME}/.config}/dotgit/public/" --work-tree="${HOME}"'
alias dotprivate='/usr/bin/git --git-dir="${XDG_CONFIG_HOME:-${HOME}/.config}/dotgit/private/" --work-tree="${HOME}"'
alias dotcheat='/usr/bin/git --git-dir="${XDG_CONFIG_HOME:-${HOME}/.config}/dotgit/cheat/" --work-tree="${HOME}"'

# aliases
## git aliases
alias gst='git status'
alias gr='git pull --rebase'
alias gf='git fetch'
alias gcm='git commit -m'
alias gcsm='git commit -S -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gpl='git pull'
alias gps='git push'
alias gsf='git submodule foreach'
## other
alias ls="${aliases[ls]:-ls} -A" # Add flags to existing aliases
alias l='ls -lFh'
alias ll='ls -lahv'
alias la='ls -lAFh'
alias s='screen -rd ddd'
alias t='timew'
alias c=' noglob calc'
alias tree='tree -a -I .git'
alias doc='docker compose'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias dicten=' dict -d fd-eng-deu'
alias dictde=' dict -d fd-deu-eng'
alias dict=' dict'
alias vless='vim -u ~/.config/vim/vimrc.less -'
alias apachelog='sudo tail -f /var/log/apache2/error.log'
alias ds='dig +short'
alias zshrc="vim ~/.zshrc"
alias aecho=' echo; echo'
alias k='kubectl'
alias gok='gok -i gokrazy'
alias v='nvim'

# zsh aliases
# extra files?
if [[ "$SHELL" =~ "zsh" && -n "$ZSH_VERSION" ]]; then
    alias -g H='| head'
    alias -g T='| tail'
    alias -g G='| grep'
    alias -g L="| less"
    alias -g LL="2>&1 | less"
    alias -g NE="2> /dev/null"
    alias -g NUL="> /dev/null 2>&1"
    alias -g EXGIT='--exclude-dir .git'
    alias -g NC="|grep -vE '^\s*(#|$)'"
    alias -g ':L'='|less -F'
    alias -g ':LL'='2>&1|less -F'
    alias -g PT="|sed 's/but was:/\r\n        but was:/g'"
    alias -g JQ='| jq -C .'
    alias -g JQL='| jq -C . | less -A'
    alias -g ...="../.."
    alias -g ....="../../.."
    alias -g R='$(fc -s -- -1 2>/dev/null)'
fi


# Y U ADD HERE? echo >> much?
