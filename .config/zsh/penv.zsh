# I need functions to manage my environment
# this cannot be done in a program because it would fork and not be able to
# modify the environment
# Requires go-yq not the jq warpper yq
# TODO:
# - don't activate non-existing projects
typeset -ga PENV=()

function penv() {
    case "$1" in
        list)
            shift
            penv-list $*
            ;;
        on)
            shift
            penv-on $*
            ;;
        off)
            shift
            penv-off $*
            ;;
        show)  penv-list -vf ;;
        clear) penv-clear ;;
        *)     penv-help ;;
    esac
}

function penv-list() {
    # penv-list [-v] [-f]
    # -v for showing environment variables
    # -f for not showing projects not in PENV
    local verbose=0
    local filter=0
    while getopts "vf" opt; do
        case "$opt" in
            v) verbose=1 ;;
            f) filter=1 ;;
        esac
    done
    local project env_project
    local projects=$(yq -r 'keys |.[]' ~/.config/penv.yaml)
    while read -u 3 project; do
        if [[ ${#PENV[@]} -gt 0 && ${PENV[(Ie)$project]} -gt 0 ]]; then
            sed "s/${project}/${project} */" <<<$project
        else
            if [[ "$filter" == "1" ]]; then
                continue
            fi
            echo $project
        fi

        if [[ "$verbose" == "1" ]]; then
            local project_envs=$(yq -r '.["'$project'"].env |keys |"  " + .[]' ~/.config/penv.yaml)
            while read -u 4 project_env; do
                if [[ $(yq -r '.["'$project'"].env["'$project_env'"]' ~/.config/penv.yaml) == "${(P)project_env}" ]]; then
                    # FIXME: Show which ones are equal
                    echo "  $project_env *"
                else
                    echo "  $project_env"
                fi
            done 4<<<$project_envs
        fi
    done 3<<<$projects

    for project in ${(@)PENV}; do
        if [[ ${projects[(Ie)$project]} -eq 0 ]]; then
            echo "$project #"
        fi
    done
}

function penv-on() {
    eval $(yq '.["'$1'"].env' ~/.config/penv.yaml \
           |sed 's/^/export /; s/: /=/')
    eval $(yq -r '.["'$1'"].commands//[] |.[] + " ;"' ~/.config/penv.yaml)
    if [[ ${PENV[(Ie)$1]} -eq 0 ]]; then
        PENV+=("$1")
    fi
}

function penv-off() {
    local project
    local projects=$(yq -r 'keys |.[]' ~/.config/penv.yaml)
    if [[ -n "$1" ]]; then
        # FIXME: catch error for non-existent project
        unset $(yq -r '.["'$1'"].env |keys |.[]' ~/.config/penv.yaml  |xargs)
        PENV=(${(@)PENV:#${1}})

    elif [[ ${#PENV[@]} -gt 0 ]]; then
        for project in $projects; do
            unset $(yq -r '.["'$project'"].env |keys |.[]' ~/.config/penv.yaml  |xargs)
            PENV=(${(@)PENV:#${project}})
        done

    else
        echo No penv active 2>/dev/null
        return 1
    fi
}

function penv-show() {
    # use penv list -v and filter for 
    local project
    if [[ "${#PENV[@]}" -gt 0 ]]; then
        for project in ${(@)PENV}; do
            echo "${project}"
            yq -r '.["'${project}'"].env |keys |.[]' ~/.config/penv.yaml
        done
    else
        echo "No active project"
    fi
}

function penv-clear() {
    local project
    # loop over all projects and unset all envionments
    for project in $(yq -r 'keys |.[]' ~/.config/penv.yaml); do
        unset $(yq -r '.["'$project'"].env |keys |.[]' ~/.config/penv.yaml |xargs)
    done
    typeset -ga PENV=()
}

function penv-help() {
    cat <<-EOF
penv list [-v] [-f] # list projects
penv show           # list projects
penv on PROJECT     # activate envs from project
penv off [PROJECT]  # unset envs from active envs
penv clear          # unset all envs mentioned in the config
EOF
}
