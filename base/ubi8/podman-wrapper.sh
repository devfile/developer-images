#!/bin/bash
set -euo pipefail

ORIGINAL_PODMAN_PATH=${ORIGINAL_PODMAN_PATH:-"/usr/bin/podman.orig"}
KUBEDOCK_SUPPORTED_COMMANDS=${KUBEDOCK_SUPPORTED_COMMANDS:-"run ps exec cp logs inspect kill rm wait stop start"}

PODMAN_ARGS=( "$@" )

TRUE=0
FALSE=1

exec_original_podman() {
    exec ${ORIGINAL_PODMAN_PATH} "${PODMAN_ARGS[@]}"
}

exec_kubedock_podman() {
    exec env CONTAINER_HOST=tcp://127.0.0.1:2475 "${ORIGINAL_PODMAN_PATH}" "${PODMAN_ARGS[@]}"
}

podman_command() {
    echo "${PODMAN_ARGS[0]}"
}

command_is_supported_by_kubedock() {
    CMD=$(podman_command)
    for SUPPORTED_CMD in $KUBEDOCK_SUPPORTED_COMMANDS; do
        if [ "$SUPPORTED_CMD" = "$CMD" ]; then
            return $TRUE
        fi
    done
    return ${FALSE}
}

if command_is_supported_by_kubedock; then
  exec_kubedock_podman
else
  exec_original_podman
fi
