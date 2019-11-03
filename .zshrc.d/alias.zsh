# expand aliases
globalias() {
    if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
        # basically filters for global aliases (not perfect)
        zle _expand_alias
        zle expand-word
    fi
    zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches
