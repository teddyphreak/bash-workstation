#!/usr/bin/env bash
# shellcheck source=/dev/null

set -e
INSTALL_PATH=$(dirname "$0")
. "$INSTALL_PATH/.env.sh"

curl -s https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | PROFILE=/dev/null bash
cat <<-DONE > ~/$PROFILE_DIR/nvm.sh
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
DONE
. ~/.nvm/nvm.sh
nvm install --lts
nvm use --lts
nvm alias default "$(nvm current)"
