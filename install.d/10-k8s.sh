#!/usr/bin/env bash
# shellcheck source=/dev/null
# vim: ts=2 sw=2 noet :
set -e

INSTALL_PATH=$(dirname "$0")
. "$INSTALL_PATH/.env.sh"

if ! command -v kubectl > /dev/null ; then
    sudo snap install kubectl --classic
fi

if ! command -v helm > /dev/null ; then
    sudo snap install helm --classic
fi

sudo apt install -y jq

# Manage kube configuration directory

if [ ! -d "$HOME/.kube" ]; then
    mkdir ~/.kube
fi

if [ ! -d "${HOME:?}/$PROFILE_DIR" ]; then
    rm -rf "${HOME:?}/$PROFILE_DIR"
    mkdir -p "${HOME:?}/$PROFILE_DIR"
fi

cat <<EOF > "$HOME/$PROFILE_DIR/kubeconfig.sh"
KUBECONFIG=""
for i in ~/.kube/config.*; do
if [ -r "\$i" ]; then
    CONF_BASE=\$(basename "\$i")
    CONF_FILE="\$HOME/.kube/\$CONF_BASE"
    if [[ \$KUBECONFIG == "" ]]; then
    KUBECONFIG="\$CONF_FILE"
    else
    KUBECONFIG="\$KUBECONFIG:\$CONF_FILE"
    fi
fi
done
export KUBECONFIG
EOF

# Install krew plugin

if [ ! -d ~/.krew ]; then
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
fi

cat <<EOF > "$HOME/$PROFILE_DIR/krew.sh"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
EOF

# Install k8s operator sdk

OPERATOR_PATH=~/.kubernetes-operator
OPERATOR_PROFILE=~/$PROFILE_DIR/k8s-operator.sh

if [ ! -d "$OPERATOR_PATH" ]; then
    rm -rf "$OPERATOR_PATH"
    mkdir "$OPERATOR_PATH"
fi

RELEASE_VERSION=$(
    curl -s https://api.github.com/repos/operator-framework/operator-sdk/releases |
        jq '.[0] | .tag_name' -r)

curl -s \
    "https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/operator-sdk-${RELEASE_VERSION}-x86_64-linux-gnu" \
    -o "$OPERATOR_PATH/operator-sdk"

curl -s \
    "https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/ansible-operator-${RELEASE_VERSION}-x86_64-linux-gnu" \
    -o "$OPERATOR_PATH/ansible-operator"

curl -s \
    "https://github.com/operator-framework/operator-sdk/releases/download/${RELEASE_VERSION}/helm-operator-${RELEASE_VERSION}-x86_64-linux-gnu" \
    -o "$OPERATOR_PATH/helm-operator"

chmod 0755 $OPERATOR_PATH/*

cat <<-DONE > "$OPERATOR_PROFILE"
export PATH="$OPERATOR_PATH:$PATH"
DONE
