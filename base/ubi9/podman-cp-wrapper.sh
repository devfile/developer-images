#!/bin/bash
set -euo pipefail

# This script replaces 'podman cp' with 'oc cp', mapping the container to the correct pod via the kubedock label.

# Parse options (stop at first non-option argument)
OPTIONS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -*) OPTIONS+=("$1"); shift ;;
        *) break ;;
    esac
done

# Now $1 and $2 are [CONTAINER:]SRC_PATH [CONTAINER:]DEST_PATH
if [[ $# -lt 2 || -z "${1:-}" || -z "${2:-}" ]]; then
    echo "Error: Both [CONTAINER:]SRC_PATH and [CONTAINER:]DEST_PATH must be specified." >&2
    exit 1
fi

SRC="$1"
DEST="$2"

get_pod_for_container() {
    local container_ref="$1"
    if [[ "$container_ref" == *:* ]]; then
        local container_id="${container_ref%%:*}"
        # Find pod with label kubedock.containerid=<container_id>
        local pod_name
        pod_name=$(oc get pods -l "kubedock.containerid=${container_id}" -o jsonpath='{.items[0].metadata.name}')
        if [[ -z "$pod_name" ]]; then
            echo "Error: No pod found for container id: $container_id" >&2
            exit 1
        fi
        # Return pod:rest_of_path
        echo "${pod_name}:${container_ref#*:}"
    else
        # No container ref, just return as is
        echo "$container_ref"
    fi
}

OC_SRC=$(get_pod_for_container "$SRC")
OC_DEST=$(get_pod_for_container "$DEST")

exec oc cp "${OPTIONS[@]}" "$OC_SRC" "$OC_DEST"