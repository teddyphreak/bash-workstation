#!/usr/bin/env bash
INSTALL_PATH=$(dirname ${BASH_SOURCE[0]})
. $INSTALL_PATH/.env.sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y curl git arandr openssh-server pavucontrol python3 python3-pip tree python-is-python3
if [ ! -d ~/$PROFILE_DIR ]; then
    rm -rf ~/$PROFILE_DIR
    mkdir -p ~/$PROFILE_DIR
fi
if [ ! -d ~/.pyenv ]; then
    rm -rf ~/.pyenv
    curl -s https://pyenv.run | bash
fi
pyenvfile=~/$PROFILE_DIR/pyenv.sh
touch $pyenvfile
cat <<-DONE > $pyenvfile
export PATH="/home/$USER/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
DONE
chmod 755 $pyenvfile
. $pyenvfile
pyenv3=$(pyenv install --list | grep "^ *3" | egrep -v "(dev|rc)" | tail -1 | sed -s 's/ +//g')
if [[ ! $(pyenv versions | grep $pyenv3) ]] ; then
    sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
         libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
         xz-utils tk-dev libffi-dev liblzma-dev python-openssl
    pyenv install $pyenv3
fi
if [[ ! $(pyenv versions | grep ansible) ]] ; then
    pyenv virtualenv $pyenv3 ansible
fi
pyenv shell ansible
eval "$(pyenv init -)"
pip install --upgrade pip
pip install ansible
pip install cookiecutter
