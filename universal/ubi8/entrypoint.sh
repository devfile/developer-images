#!/bin/bash

# Kubedock
if [ "${KUBEDOCK_ENABLED:-false}" = "true" ]; then
    echo
    echo "Kubedock is enabled (env variable KUBEDOCK_ENABLED is set to true)."

    SECONDS=0
    KUBEDOCK_TIMEOUT=${KUBEDOCK_TIMEOUT:-10}
    until [ -f $KUBECONFIG ]; do
        if (( SECONDS > KUBEDOCK_TIMEOUT )); then
            break 
        fi
        echo "Kubeconfig doesn't exist yet. Waiting..."
        sleep 1
    done

    if [ -f $KUBECONFIG ]; then 
        echo "Kubeconfig found."

        KUBEDOCK_PARAMS=${KUBEDOCK_PARAMS:-"--reverse-proxy --kubeconfig $KUBECONFIG"}

        echo "Starting kubedock with params \"${KUBEDOCK_PARAMS}\"..."
        
        kubedock server ${KUBEDOCK_PARAMS} > /tmp/kubedock.log 2>&1 &
        
        echo "Done."

        echo "Replacing podman with podman-wrapper..."

        ln -f -s /usr/bin/podman.wrapper /home/tooling/.local/bin/podman

        export TESTCONTAINERS_RYUK_DISABLED="true"
        export TESTCONTAINERS_CHECKS_DISABLE="true"

        echo "Done."
        echo
    else 
        echo "Could not find Kubeconfig at $KUBECONFIG"
        echo "Giving up..."
    fi
else
    echo
    echo "Kubedock is disabled. It can be enabled with the env variable \"KUBEDOCK_ENABLED=true\""
    echo "set in the workspace Devfile or in a Kubernetes ConfigMap in the developer namespace."
    echo
    ln -f -s /usr/bin/podman.orig /home/tooling/.local/bin/podman
fi


# Stow
## Required for https://github.com/eclipse/che/issues/22412

# /home/user/ will be mounted to by a PVC if persistUserHome is enabled
mountpoint -q /home/user/; HOME_USER_MOUNTED=$?

# This file will be created after stowing, to guard from executing stow everytime the container is started
STOW_COMPLETE=/home/user/.stow_completed

if [ $HOME_USER_MOUNTED -eq 0 ] && [ ! -f $STOW_COMPLETE ]; then
    # Create symbolic links from /home/tooling/ -> /home/user/
    stow . -t /home/user/ -d /home/tooling/ --no-folding -v 2 > /tmp/stow.log 2>&1
    # Vim does not permit .viminfo to be a symbolic link for security reasons, so manually copy it
    cp /home/tooling/.viminfo /home/user/.viminfo
    # We have to restore bash-related files back onto /home/user/ (since they will have been overwritten by the PVC)
    # but we don't want them to be symbolic links (so that they persist on the PVC)
    cp /home/tooling/.bashrc /home/user/.bashrc
    cp /home/tooling/.bash_profile /home/user/.bash_profile
    touch $STOW_COMPLETE
fi

exec "$@"
