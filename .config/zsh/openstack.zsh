export CLIFF_FIT_WIDTH=1

prompt_openstack() {
    [[ -n "$OS_CLOUD" ]] \
        && p10k segment -f 197 -t $OS_CLOUD
}

typeset -g POWERLEVEL9K_OPENSTACK_SHOW_ON_COMMAND='barbican|ceilometer|cinder|cloudkitty|freezer|glance|heat|keystone|magnum|manila|mistral|monasca|murano|neutron|nova|openstack|swift|tacker|trove|vitrage|watcher'
