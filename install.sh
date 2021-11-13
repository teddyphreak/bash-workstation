#!/usr/bin/env bash
set -e
INSTALL_PATH=$(dirname "${BASH_SOURCE[0]}")

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
sudo apt-get install -y git

curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-bash/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-emacs/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-tmux/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-vim/master/install.sh | bash

export PYENV_VERSION=ansible

if [[ $GUI == "$OK" ]]; then
    sudo apt install -y autorandr
    curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-i3/master/install.sh | bash
fi

if [[ $DOCKER == "$OK" ]]; then
    curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-docker/master/install.sh | bash
fi

unset PYENV_VERSION

if [[ $ANSIBLE == "$KO" ]]; then
    sudo apt-get purge -y ansible
fi

sudo apt-get autoremove -y
