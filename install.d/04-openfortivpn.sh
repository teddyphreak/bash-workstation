#!/usr/bin/env bash
# shellcheck source=/dev/null

INSTALL_PATH=$(dirname ${BASH_SOURCE[0]})
. "$INSTALL_PATH/.env.sh"

sudo apt-get install -y openfortivpn network-manager-fortisslvpn network-manager-fortisslvpn-gnome
