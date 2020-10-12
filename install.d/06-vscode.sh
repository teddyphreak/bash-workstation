#!/usr/bin/env bash
set -e
INSTALL_PATH=$(dirname ${BASH_SOURCE[0]})
. $INSTALL_PATH/.env.sh

sudo snap install code --classic
code --force --install-extension vscodevim.vim
code --force --install-extension vspacecode.vspacecode
code --force --install-extension kahole.magit
