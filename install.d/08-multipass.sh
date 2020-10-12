#!/usr/bin/env bash
INSTALL_PATH=$(dirname $0)
. $INSTALL_PATH/.env.sh

sudo snap install multipass --classic
