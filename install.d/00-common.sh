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

cat <<EOF > ~/.bash_profile
# ~/.bash_profile: executed by the command interpreter for login shells.

# Because of this file's existence, neither ~/.bash_login nor ~/.profile
# will be sourced.

# See /usr/share/doc/bash/examples/startup-files for examples.
# The files are located in the bash-doc package.

# Because ~/.profile isn't invoked if this files exists,
# we must source ~/.profile to get its settings:

if [ -r ~/.profile ]; then
   . "$HOME/.profile"
fi

if [ -r ~/.bashrc ]; then
   . "$HOME/.bashrc"
fi
EOF
