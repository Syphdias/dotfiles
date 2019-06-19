if [[ -f ~/.local/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME="${HOME}/.virtualenvs"
    export PROJECT_HOME="${HOME}/ves"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    source ~/.local/bin/virtualenvwrapper.sh
fi
