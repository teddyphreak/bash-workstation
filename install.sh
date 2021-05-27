#!/usr/bin/env bash
set -e
INSTALL_PATH=$(dirname "${BASH_SOURCE[0]}")

for i in "$INSTALL_PATH"/install.d/*.sh
do
    bash "$i"
done

sudo apt install -y autorandr

export PYENV_VERSION=ansible

curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-bash/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-tmux/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-i3/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-vim/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-emacs/master/install.sh | bash
curl -s https://raw.githubusercontent.com/nephelaiio/ansible-role-docker/master/install.sh | bash

sudo apt-get autoremove -y
unset PYENV_VERSION
