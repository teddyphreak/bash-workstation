#!/usr/bin/env bash
INSTALL_PATH=$(dirname $0)
. $INSTALL_PATH/.env.sh

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh
