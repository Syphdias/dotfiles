#test -f ~/.motd && cat ~/.motd && echo

# testing pyenv
#if command -v pyenv 1>/dev/null 2>&1; then
#    eval "$(pyenv init -)"
#fi

function prompt_p9k_compile() {
  emulate -L zsh
  unsetopt autopushd

  rm -f ${__P9K_DIRECTORY}/**/*.zwc
  rm -f ${HOME}/.zcompdump*.zwc

  for f in ${__P9K_DIRECTORY}/**/*.(p9k|zsh) ${HOME}/.zcompdump*; do
    [[ $f != *.zwc ]] && {
      echo "compiling $f ..."
      zcompile $f
    }
  done
}
#add-zsh-hook zshexit prompt_p9k_compile
#prompt_p9k_compile &
