#!/bin/bash

# Kubedock
if [ "${KUBEDOCK_ENABLED:-false}" = "true" ]; then
    echo
    echo "Kubedock is enabled (env variable KUBEDOCK_ENABLED is set to true)."

    SECONDS=0
    until [ -f $KUBECONFIG ]; do
        if (( SECONDS > 10 )); then
            echo "Giving up..."
            exit 1
        fi
        echo "Kubeconfig doesn't exist yet. Waiting..."
        sleep 1
    done
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
    echo
    echo "Kubedock is disabled. It can be enabled with the env variable \"KUBEDOCK_ENABLED=true\""
    echo "set in the workspace Devfile or in a Kubernetes ConfigMap in the developer namespace."
    echo
    ln -f -s /usr/bin/podman.orig /home/tooling/.local/bin/podman
fi

# /home/user/ will be mounted to by a PVC if persistUserHome is enabled
if mountpoint -q /home/user/; then
    # Create symbolic links from /home/tooling/ -> /home/user/
    stow . -t /home/user/ -d /home/tooling/ --no-folding
    # Vim does not permit .viminfo to be a symbolic link for security reasons, so manually copy it
    cp /home/tooling/.viminfo /home/user/.viminfo
fi

exec "$@"
