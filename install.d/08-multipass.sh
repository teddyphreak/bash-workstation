#!/usr/bin/env bash
# vim: ts=2 sw=2 noet :
set -e

INSTALL_PATH=$(dirname $0)
. $INSTALL_PATH/.env.sh

MULTIPASS=/snap/bin/multipass
if [ ! -f $MULTIPASS ]; then
    sudo snap install multipass --classic
fi

mkdir -p ~/.multipass/bin
cat <<-EOF > ~/.multipass/bin/multipass
ORIG_ARGS=("\${@[@]}")
EXTRA_ARGS=""
CLINIT=\$(mktemp "./.cloudinit.XXXXXXXXXXXX.yaml")
if [ -f ~/.ssh/id_rsa.pub ]; then
	if (( \$# > 0 )); then
		if [[ "\$1" == "launch" ]]; then
				cat <<-DONE > \$CLINIT
				users:
				  - name: \$USER
				    shell: \$SHELL
				    ssh_authorized_keys:
				      - \$(cat ~/.ssh/id_rsa.pub)
				DONE
	      EXTRA_ARGS="--cloud-init \$CLINIT"
        if ! [[ "$@" =~ "-n" ]]; then
          if NAME=\$(curl --fail -s https://frightanic.com/goodies_content/docker-names.php); then
            INSTANCE="\$(echo \$NAME | sed -e 's/_/-/g')"
            EXTRA_ARGS="\$EXTRA_ARGS -n \$INSTANCE"
            EXTRA_CMD="$MULTIPASS mount $HOME \$INSTANCE:$HOME"
          fi
        fi
    fi
  fi
fi
echo running $MULTIPASS \$@ \$EXTRA_ARGS
$MULTIPASS \$@ \$EXTRA_ARGS
if [ ! -z "\$EXTRA_CMD" ]; then
  echo running \$EXTRA_CMD
  \$EXTRA_CMD
fi
rm -rf \$CLINIT
EOF
chmod uog+x ~/.multipass/bin/multipass

cat <<EOF > ~/$PROFILE_DIR/multipass.sh
export PATH="/home/$USER/.multipass/bin:\$PATH"
EOF
