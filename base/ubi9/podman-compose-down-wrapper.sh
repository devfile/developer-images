#!/bin/bash
set -euo pipefail

# This script is a wrapper for 'podman compose down' or 'docker compose down'
# It removes the containers/services defined in the docker-compose file using 'podman rm'
# This is needed when running with kubedock, as 'compose down' cannot shut down pods directly

usage() {
    echo "Usage: $0 [OPTIONS] [SERVICES]"
    echo "  OPTIONS: Options for docker-compose down (e.g., -f docker-compose.yml)"
    echo "  SERVICES: Optional list of services to remove"
    exit 1
}

# Parse options and service names
COMPOSE_FILE="docker-compose.yml"
OPTIONS=()
SERVICES=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            if [[ -n "${2:-}" ]]; then
                COMPOSE_FILE="$2"
                OPTIONS+=("$1" "$2")
                shift 2
            else
                echo "Error: Missing argument for $1"
                usage
            fi
            ;;
        --file=*)
            COMPOSE_FILE="${1#*=}"
            OPTIONS+=("$1")
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            OPTIONS+=("$1")
            shift
            ;;
        *)
            SERVICES+=("$1")
            shift
            ;;
    esac
done

# If no -f/--file was provided, support both docker-compose.yml and docker-compose.yaml
if [[ "${COMPOSE_FILE}" == "docker-compose.yml" ]]; then
    if [[ -f "docker-compose.yml" ]]; then
        COMPOSE_FILE="docker-compose.yml"
    elif [[ -f "docker-compose.yaml" ]]; then
        COMPOSE_FILE="docker-compose.yaml"
    else
        echo "Error: No docker-compose.yml or docker-compose.yaml found in the current directory."
        exit 1
    fi
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "Error: Compose file '$COMPOSE_FILE' not found."
    exit 1
fi

# Get service names from compose file if none specified
if [[ ${#SERVICES[@]} -eq 0 ]]; then
    # Try to use yq if available, else fallback to grep/sed/awk
    if command -v yq >/dev/null 2>&1; then
        mapfile -t SERVICES < <(yq '.services | keys | .[]' "$COMPOSE_FILE")
    else
        # Fallback: extract service names by finding top-level keys under 'services:'
        mapfile -t SERVICES < <(awk '/services:/ {flag=1; next} /^[^[:space:]]/ {flag=0} flag && /^[[:space:]]+[a-zA-Z0-9_-]+:/ {gsub(":",""); print $1}' "$COMPOSE_FILE" | sed 's/^[[:space:]]*//')
    fi
fi

if [[ ${#SERVICES[@]} -eq 0 ]]; then
    echo "No services found in compose file '$COMPOSE_FILE'."
    exit 0
fi

# Compose container name: <current-dir>-<service-name>-1
PROJECT_NAME="$(basename "$PWD")"

echo "Removing services: ${SERVICES[*]}"
for svc in "${SERVICES[@]}"; do
    # Try to get container_name from compose file
    CONTAINER_NAME=""
    if command -v yq >/dev/null 2>&1; then
        CONTAINER_NAME=$(yq ".services.${svc}.container_name // \"\"" "$COMPOSE_FILE" | tr -d '"')
    fi
    if [[ -z "$CONTAINER_NAME" ]]; then
        CONTAINER_NAME="${PROJECT_NAME}-${svc}-1"
    fi
    # Check if the container exists
    if ! podman ps -a --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
        echo "No container found for service '$svc' (expected name: $CONTAINER_NAME)"
        continue
    fi
    echo "Removing container: $CONTAINER_NAME"
    podman rm -f "$CONTAINER_NAME"
done

echo "All specified services have been removed."