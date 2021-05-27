#!/usr/bin/env bash
# shellcheck source=/dev/null
# vim: ts=2 sw=2 noet :

set -e

INSTALL_PATH=$(dirname "$0")
. "$INSTALL_PATH/.env.sh"

sudo apt install -y git

BASHER_PATH=~/.basher
BASHER_INIT=~/$PROFILE_DIR/basher.sh

if [ ! -d $BASHER_PATH ]; then
    git clone https://github.com/basherpm/basher.git $BASHER_PATH
fi

if [ ! -d "${HOME:?}/$PROFILE_DIR" ]; then
    rm -rf "${HOME:?}/$PROFILE_DIR"
    mkdir -p "${HOME:?}/$PROFILE_DIR"
fi

cat <<-DONE > "$BASHER_INIT"
export PATH="$HOME/.basher/bin:$PATH"
eval "\$(basher init - bash)"
DONE
export PATH="$HOME/.basher/bin:$PATH"
eval "$(basher init - bash)"

sudo apt install -y shellcheck
basher install sstephenson/bats
