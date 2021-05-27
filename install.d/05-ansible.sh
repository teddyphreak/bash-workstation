#!/usr/bin/env bash
# shellcheck source=/dev/null

INSTALL_PATH=$(dirname "${BASH_SOURCE[0]}")
. "$INSTALL_PATH/.env.sh"

sudo apt-get install -y libcurl4-gnutls-dev libgnutls28-dev libxml2-dev
if [ ! -d ~/.ansible_vault ]; then
    mkdir ~/.ansible_vault
fi
ansibleenvfile=~/$PROFILE_DIR/ansible.sh
cat <<-DONE > "$ansibleenvfile"
ANSIBLE_VAULT_IDENTITY_LIST=""
for i in ~/.ansible_vault/*; do
    if [ -r \$i ]; then
        VAULT_NAME=\$(basename \$i);
        VAULT="\$VAULT_NAME@\$i";
        if [[ \$ANSIBLE_VAULT_IDENTITY_LIST == "" ]]; then
            ANSIBLE_VAULT_IDENTITY_LIST="\$VAULT";
        else
            ANSIBLE_VAULT_IDENTITY_LIST="\$ANSIBLE_VAULT_IDENTITY_LIST,\$VAULT";
        fi
    fi
done
export ANSIBLE_VAULT_IDENTITY_LIST
DONE
chmod 755 "$ansibleenvfile"
. "$ansibleenvfile"
