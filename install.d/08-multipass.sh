#!/usr/bin/env bash
# vim: ts=2 sw=2 noet :
# shellcheck source=/dev/null

set -e

INSTALL_PATH=$(dirname "$0")
. "$INSTALL_PATH/.env.sh"

if ! command -v multipass > /dev/null ; then
    sudo snap install multipass --classic
fi

sudo apt install -y jq

mkdir -p ~/.multipass/bin
cat <<-EOF > ~/.multipass/bin/multipass

# detect argument name
ARGS=()
while [[ \$# -gt 0 ]]; do
    key="\$1"
    case \$key in
        -n|--name)
        INSTANCE="\$2"
        ARGS+=("\$1")
        shift
        ;;
        *)
        ARGS+=("\$1")
        shift # past argument
        ;;
    esac
done
set -- "\${ARGS[@]}"

# initialize vars and interrupt handlers
CMDS=()
EXTRA_ARGS=""
CLINIT=\$(mktemp "./cloudinit.XXXXXXXXXXXX.yaml")
trap cleanup INT
function cleanup() {
    rm -rf \$CLINIT
}

# determine extra arguments and post commands
if [ -f ~/.ssh/id_rsa.pub ]; then
	if (( \$# > 0 )); then
		if [[ "\$1" == "ssh" ]]; then
      if (( \$# < 2 )); then
        echo Name argument is required
      elif (( \$# > 2 )); then
        echo Too many arguments
      else
        INSTANCE_IP=\$($MULTIPASS info \$2 --format json | jq ".info[\"\$2\"].ipv4[0]" -r)
        ssh \$USER@\$INSTANCE_IP -i ~/.ssh/id_rsa
      fi
    elif [[ "\$1" == "launch" ]]; then
			cat <<-DONE > \$CLINIT
			users:
			  - name: \$USER
			    shell: \$SHELL
			    uid: \$UID
			    ssh_authorized_keys:
			      - \$(cat ~/.ssh/id_rsa.pub)
			DONE
	    EXTRA_ARGS="--cloud-init \$CLINIT"
      if [ -z \$INSTANCE ]; then
        if NAME=\$(curl --fail -s https://frightanic.com/goodies_content/docker-names.php); then
          INSTANCE="\$(echo \$NAME | sed -e 's/_/-/g')"
          EXTRA_ARGS="\$EXTRA_ARGS -n \$INSTANCE"
        fi
      fi
      CMDS+=("$MULTIPASS \$* \$EXTRA_ARGS")
      CMDS+=("$MULTIPASS mount -u \$UID:\$UID \$HOME \$INSTANCE:\$HOME")
      CMDS+=("$MULTIPASS mount /etc/profile.d \$INSTANCE:/etc/profile.d")
      CMDS+=("$MULTIPASS mount /etc/sudoers.d \$INSTANCE:/etc/sudoers.d")
    else
      CMDS+=("$MULTIPASS \$*")
    fi
  else
    CMDS+=("$MULTIPASS \$*")
  fi
else
  CMDS+=("$MULTIPASS \$*")
fi

# execute commands
for CMD in "\${CMDS[@]}"; do
   echo \$CMD
   \$CMD
done

cleanup
EOF
chmod uog+x "$HOME/.multipass/bin/multipass"

cat <<EOF > "$HOME/$PROFILE_DIR/multipass.sh"
export PATH="/home/$USER/.multipass/bin:\$PATH"
EOF
