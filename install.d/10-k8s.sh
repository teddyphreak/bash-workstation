#!/usr/bin/env bash
# vim: ts=2 sw=2 noet :
set -e

INSTALL_PATH=$(dirname "$0")
. $INSTALL_PATH/.env.sh

OPERATOR_PATH=~/.kubernetes-operator
OPERATOR_PROFILE=~/$PROFILE_DIR/k8s-operator.sh

if [ ! -d "$OPERATOR_PATH" ]; then
    rm -rf "$OPERATOR_PATH"
    mkdir "$OPERATOR_PATH"
fi

if [ ! -d "${HOME:?}/$PROFILE_DIR" ]; then
    rm -rf "${HOME:?}/$PROFILE_DIR"
    mkdir -p "${HOME:?}/$PROFILE_DIR"
fi

sudo snap install kubectl --classic
sudo snap install helm --classic
sudo apt install -y wget jq

# Install k8s operator sdk
RELEASE_VERSION=$(
    curl -s https://api.github.com/repos/operator-framework/operator-sdk/releases |
        jq '.[] | .tag_name' -r |
        sort |
        tail -1)

wget \
    "https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu" \
    -O "$OPERATOR_PATH/operator-sdk"

wget \
    "https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/ansible-operator-${RELEASE_VERSION}-x86_64-linux-gnu" \
    -O "$OPERATOR_PATH/ansible-operator"

wget \
    "https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/helm-operator-${RELEASE_VERSION}-x86_64-linux-gnu" \
    -O "$OPERATOR_PATH/helm-operator"

chmod 0755 $OPERATOR_PATH/*

cat <<-DONE > "$OPERATOR_PROFILE"
export PATH="$HOME/$OPERATOR_PATH:$PATH"
DONE
