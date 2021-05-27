#!/usr/bin/env bash
# shellcheck source=/dev/null

set -e
INSTALL_PATH=$(dirname "${BASH_SOURCE[0]}")
. "$INSTALL_PATH/.env.sh"

if ! command -v code > /dev/null ; then
    sudo snap install code --classic
fi

code --force --install-extension vscodevim.vim
code --force --install-extension vspacecode.vspacecode
code --force --install-extension kahole.magit
