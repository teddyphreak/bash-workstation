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

ansible localhost -m apt -a "name=git" --become >/dev/null 2>&1
ansible localhost -m snap -a "name=yq" --become >/dev/null 2>&1

ANSIBLE_ROLES=$(yq e '.[]' <(ansible-galaxy role list 2>/dev/null | cut -d, -f1) | xargs)
if [ -n "$ANSIBLE_ROLES" ]; then
    ansible-galaxy role remove $ANSIBLE_ROLES
fi

curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-bash/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-emacs/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-tmux/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-vim/master/install.sh | bash

export PYENV_VERSION=ansible

if [[ $GUI == "$OK" ]]; then
    ansible localhost -m apt -a "name=autorandr" --become >/dev/null 2>&1
    curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-i3/master/install.sh | bash
fi

if [[ $DOCKER == "$OK" ]]; then
    curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-docker/master/install.sh | bash
fi

unset PYENV_VERSION

if [[ $ANSIBLE == "$KO" ]]; then
    ansible localhost -m apt -a "name=ansible state=absent purge=yes" --become >/dev/null 2>&1
fi

ansible localhost -m apt -a "upgrade=safe" --become >/dev/null 2>&1
ansible localhost -m apt -a "autoremove=yes" --become >/dev/null 2>&1
