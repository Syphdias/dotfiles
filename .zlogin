# https://github.com/docwhat/dotfiles/blob/master/zlogin
#if (( $+functions[compinit] )); then
#    unfunction compinit
#fi
#autoload -Uz compinit
#compinit -i -d "${ZSH_COMPDUMP}"

# Execute code that does not affect the current session in the background.

{
    # Compile the completion dump to increase startup speed.
    if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
        zcompile "$ZSH_COMPDUMP"
    fi
} &!


# https://github.com/docwhat/dotfiles/blob/master/local/libexec/tools-update/zsh
function zc() {
    local file
    for file in "$@"; do
        if [[ $file == *.zwc ]]; then continue; fi
        print -P "%F{blue}zcompile %F{cyan}${file}%F{reset}"
        zcompile "$file"
    done
}

# Remove old compile files that may be stale
#rm -f ~/.zshrc.zwc
#find ~/.zshrc.d -name '*.zwc' -print0 | xargs -0 rm 2>/dev/null
#
#zc ~/.zshrc{.d/*.zsh}(N^/) &!
