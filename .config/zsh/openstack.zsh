export CLIFF_FIT_WIDTH=1

prompt_openstack() {
    [[ -n "$OS_CLOUD" ]] \
        && p10k segment -f 197 -t $OS_CLOUD
}
