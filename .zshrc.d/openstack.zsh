
prompt_openstack() {
    [[ -n "$OS_CLOUD" ]] \
        && p10k segment -f white -t $OS_CLOUD
}
