#!/usr/bin/env bash
INSTALL_PATH=$(dirname ${BASH_SOURCE[0]})
. $INSTALL_PATH/.env.sh

sudo sed -ie 's/cr\./us./g' /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y
sudo apt autoclean -y
sudo apt autoremove -y
