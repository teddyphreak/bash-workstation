#!/usr/bin/env bash
INSTALL_PATH=$(dirname $0)
. $INSTALL_PATH/.env.sh

sudo sh -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$USER"
sudo sed -ie 's/cr\.archive\.ubuntu\.com/us.archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y
sudo apt autoclean -y
sudo apt autoremove -y
sudo apt install -y \
     ubuntu-restricted-extras \
     libxml2-dev \
     libxslt1-dev \
     xsel \
     httpie \
     silversearcher-ag \
     xkcdpass
