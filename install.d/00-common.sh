#!/usr/bin/env bash
# shellcheck source=/dev/null

INSTALL_PATH=$(dirname "$0")
. "$INSTALL_PATH/.env.sh"

sudo sh -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$USER"
sudo sed -ie 's/cr\.archive\.ubuntu\.com/us.archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt update
sudo apt upgrade -y
sudo apt autoclean -y
sudo apt autoremove -y
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
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

if [ -r "$HOME/.profile" ]; then
   . "$HOME/.profile"
fi

if [ -r "$HOME/.bashrc" ]; then
   . "$HOME/.bashrc"
fi
EOF

cat <<EOF > "$HOME/$PROFILE_DIR/alias.sh"
alias beep='paplay /usr/share/sounds/gnome/default/alerts/sonar.ogg'
EOF
