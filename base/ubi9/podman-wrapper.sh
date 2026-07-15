#!/bin/bash
set -euo pipefail

PODMAN_ORIGINAL_PATH=${PODMAN_ORIGINAL_PATH:-"/usr/bin/podman.orig"}
KUBEDOCK_SUPPORTED_COMMANDS=${KUBEDOCK_SUPPORTED_COMMANDS:-"run ps exec cp logs inspect kill rm wait stop start"}

PODMAN_ARGS=( "$@" )

# Check for 'compose down' command and delegate to the special wrapper
if [[ "${PODMAN_ARGS[0]:-}" == "compose" && "${PODMAN_ARGS[1]:-}" == "down" ]]; then
    # Forward all args after 'compose down' to the wrapper
    exec "/usr/bin/podman-compose-down-wrapper.sh" "${PODMAN_ARGS[@]:2}"
fi

# Intercept 'podman run' with interactive/tty flags and delegate to the interactive wrapper
if [[ "${PODMAN_ARGS[0]:-}" == "run" ]]; then
    has_interactive=0
    has_tty=0
    for arg in "${PODMAN_ARGS[@]}"; do
        case "$arg" in
            -i|--interactive) has_interactive=1 ;;
            -t|--tty) has_tty=1 ;;
            -it|-ti) has_interactive=1; has_tty=1 ;;
        esac
    done
    if [[ $has_interactive -eq 1 && $has_tty -eq 1 ]]; then
        exec "/usr/bin/podman-interactive-wrapper.sh" "${PODMAN_ARGS[@]}"
    fi
fi

# Intercept 'podman cp' and delegate to the cp wrapper
if [[ "${PODMAN_ARGS[0]:-}" == "cp" ]]; then
    exec "/usr/bin/podman-cp-wrapper.sh" "${PODMAN_ARGS[@]:1}"
fi

TRUE=0
FALSE=1

exec_original_podman() {
    exec ${PODMAN_ORIGINAL_PATH} "${PODMAN_ARGS[@]}"
}

exec_kubedock_podman() {
    exec env CONTAINER_HOST=tcp://127.0.0.1:2475 "${PODMAN_ORIGINAL_PATH}" "${PODMAN_ARGS[@]}"
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
