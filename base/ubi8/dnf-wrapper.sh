#!/bin/bash
set -euo pipefail

DNF_ORIGINAL_PATH=${DNF_ORIGINAL_PATH:-"/usr/bin/dnf.orig"}
PODMAN_WRAPPER_PATH=${PODMAN_WRAPPER_PATH:-"/usr/bin/podman.wrapper"}
PODMAN_ORIGINAL_PATH=${PODMAN_ORIGINAL_PATH:-"/usr/bin/podman.orig"}

DNF_ARGS=( "$@" )

TRUE=0
FALSE=1

exec_original_dnf() {
    ${DNF_ORIGINAL_PATH} "${DNF_ARGS[@]}"
}

check_if_setup_needed() {
    if command -v podman &> /dev/null && [ ! -e "$PODMAN_ORIGINAL_PATH" ]; then
        return $TRUE
    fi
    return $FALSE
}

install_kubedock() {
    curl -L https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/kubedock_${KUBEDOCK_VERSION}_linux_amd64.tar.gz | tar -C /usr/local/bin -xz --no-same-owner
    chmod +x /usr/local/bin/kubedock
}

setup_podman() {
    # Link wrapper to podman
    PODMAN_PATH=$(which podman)
    mv "$PODMAN_PATH" "$PODMAN_ORIGINAL_PATH"
    ln -f -s "$PODMAN_WRAPPER_PATH" "$PODMAN_PATH"

    # Adjust storage.conf to enable Fuse storage.
    sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf
    mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers
    touch /var/lib/shared/overlay-images/images.lock
    touch /var/lib/shared/overlay-layers/layers.lock

    # But use VFS since not all environments support fuse...
    mkdir -p "${HOME}"/.config/containers
    chown -R 10001 "${HOME}"/.config
   (echo '[storage]';echo 'driver = "vfs"') > "${HOME}"/.config/containers/storage.conf
}

exec_original_dnf
if check_if_setup_needed; then
    echo "Podman is installed, installing Kubedock..."
    install_kubedock
    echo "Kubedock installed"
    setup_podman
fi
