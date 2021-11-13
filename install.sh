#!/usr/bin/env bash
set -e

export ANSIBLE_LOAD_CALLBACK_PLUGINS=true
export ANSIBLE_STDOUT_CALLBACK=json

OK=0
KO=1

GUI=$KO
DOCKER=$KO
ANSIBLE=$OK

# detect argument name
ARGS=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --gui)
        GUI=$OK
        ARGS+=("$1")
        shift
        ;;
        --docker)
        DOCKER=$OK
        ARGS+=("$1")
        shift
        ;;
        *)
        ARGS+=("\$1")
        shift # past argument
        ;;
    esac
done
set -- "\${ARGS[@]}"

if ! type -p "ansible"; then
    ANSIBLE=$KO
    sudo apt-get install -y ansible
fi
export ANSIBLE_LOAD_CALLBACK_PLUGINS=true
export ANSIBLE_STDOUT_CALLBACK=json

sudo ansible localhost -m apt -a "name=git"
sudo ansible localhost -m snap -a "name=yq"

unset ANSIBLE_LOAD_CALLBACK_PLUGINS
unset ANSIBLE_STDOUT_CALLBACK

yq e '.[]' <(ansible-galaxy role list 2>/dev/null | cut -d, -f1) | xargs ansible-galaxy role remove

curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-bash/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-emacs/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-tmux/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-vim/master/install.sh | bash

export PYENV_VERSION=ansible

if [[ $GUI == "$OK" ]]; then
    sudo ansible localhost -m apt -a "name=autorandr"
    curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-i3/master/install.sh | bash
fi

if [[ $DOCKER == "$OK" ]]; then
    curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-docker/master/install.sh | bash
fi

unset PYENV_VERSION

export ANSIBLE_LOAD_CALLBACK_PLUGINS=true
export ANSIBLE_STDOUT_CALLBACK=json

if [[ $ANSIBLE == "$KO" ]]; then
    sudo ansible localhost -m apt -a "name=ansible state=absent purge=yes"
fi

sudo ansible localhost -m apt -a "upgrade=safe"
sudo ansible localhost -m apt -a "autoremove=yes"

unset ANSIBLE_LOAD_CALLBACK_PLUGINS
unset ANSIBLE_STDOUT_CALLBACK
