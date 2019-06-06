keychain id_rsa id_rsa2048 --agents gpg,ssh
#if (( $+commands[keychain] )); then
#    eval "$(keychain --eval --quick --noask --nogui --quiet --inherit 'any' --agents 'gpg,ssh' --ignore-missing id_rsa id_rsa2048)"
#fi


# Used for TMUX (and for screen?)
if [ "${SSH_AUTH_SOCK:-}" != "$HOME/.ssh/ssh_auth_sock" ]; then
    if [[ -S "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
        ln -nsf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    fi
fi
