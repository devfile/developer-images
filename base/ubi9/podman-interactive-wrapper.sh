#!/bin/bash
set -euo pipefail

# This script transparently replaces problematic 'podman run -it ...' invocations
# with a workaround for kubedock compatibility:
#   podman exec -it $(podman run -d --rm [OPTIONS] IMAGE tail -f /dev/null) [COMMAND]

usage() {
    echo "Usage: $0 run [OPTIONS] IMAGE [COMMAND] [ARG...]"
    exit 1
}

ARGS=( "$@" )
if [[ "${ARGS[0]:-}" != "run" ]]; then
    usage
fi

RUN_OPTS=()
IMAGE=""
CMD_ARGS=()

skip_next=0
found_image=0
for ((i=1; i<${#ARGS[@]}; i++)); do
    arg="${ARGS[$i]}"
    if [[ $skip_next -eq 1 ]]; then
        # Only skip for --tty/--interactive with space value
        RUN_OPTS+=("$arg")
        skip_next=0
        continue
    fi
    if [[ $found_image -eq 0 ]]; then
        # Remove all forms of interactive/tty options for internal run
        case "$arg" in
            -i|-t|-it|-ti)
                continue
                ;;
            --tty|--interactive)
                # skip this and the next arg if it does not start with '-'
                if [[ $((i+1)) -lt ${#ARGS[@]} && "${ARGS[$((i+1))]}" != "-"* ]]; then
                    skip_next=1
                fi
                continue
                ;;
            --tty=*|--interactive=*)
                continue
                ;;
            # Options that take a value
            -u=*|--user=*)
                # Handle -u=root and --user=root
                RUN_OPTS+=("--user=$(id -u)")
                continue
                ;;
            -u|--user)
                # Handle -u root and --user root
                RUN_OPTS+=("--user=$(id -u)")
                ((i++)) # Skip the next argument (the value)
                continue
                ;;
            -v|--volume|-e|--env|-w|--workdir|--name|--hostname|--entrypoint|--add-host|--device|--label|--network|--cap-add|--cap-drop|--security-opt|--tmpfs|--ulimit|--mount|--publish|--expose|--dns|--dns-search|--dns-option|--mac-address|--memory|--memory-swap|--cpu-shares|--cpus|--cpu-period|--cpu-quota|--cpu-rt-runtime|--cpu-rt-period|--cpuset-cpus|--cpuset-mems|--blkio-weight|--blkio-weight-device|--device-read-bps|--device-write-bps|--device-read-iops|--device-write-iops|--shm-size|--sysctl|--log-driver|--log-opt|--restart|--stop-signal|--stop-timeout|--health-cmd|--health-interval|--health-retries|--health-timeout|--health-start-period|--userns|--cgroup-parent|--pid|--ipc|--uts|--runtime|--storage-opt|--volume-driver|--volumes-from|--env-file|--group-add|--init|--isolation|--kernel-memory|--memory-reservation|--memory-swappiness|--oom-kill-disable|--oom-score-adj|--pids-limit|--privileged|--publish-all|--read-only|--sig-proxy)
                RUN_OPTS+=("$arg")
                skip_next=1
                continue
                ;;
            --*=*)
                # long option with value, e.g. --workdir=/foo
                # filter out --tty= and --interactive=
                if [[ "$arg" == --tty=* || "$arg" == --interactive=* ]]; then
                    continue
                fi
                if [[ "$arg" == --user=* ]]; then
                    RUN_OPTS+=("--user=$(id -u)")
                    continue
                fi
                RUN_OPTS+=("$arg")
                continue
                ;;
            --)
                found_image=1
                continue
                ;;
            -*)
                # Handle combined short options, e.g. -itv, -tiv, etc.
                # Remove i and t, keep the rest
                if [[ "$arg" =~ ^-([it]+)$ ]]; then
                    # skip if only i/t/it/ti
                    continue
                elif [[ "$arg" =~ ^-([it]+)(.+)$ ]]; then
                    rest="${BASH_REMATCH[2]}"
                    if [[ -n "$rest" ]]; then
                        RUN_OPTS+=("-$rest")
                    fi
                    continue
                else
                    RUN_OPTS+=("$arg")
                    continue
                fi
                ;;
            *)
                IMAGE="$arg"
                found_image=1
                continue
                ;;
        esac
    else
        CMD_ARGS+=("$arg")
    fi
done
# Remove duplicate --rm if present
has_rm=0
for opt in "${RUN_OPTS[@]}"; do
    if [[ "$opt" == "--rm" ]]; then
        has_rm=1
        break
    fi
done


FINAL_RUN_OPTS=("${RUN_OPTS[@]}")
if [[ $has_rm -eq 0 ]]; then
    FINAL_RUN_OPTS+=("--rm")
fi

if [[ -z "$IMAGE" ]]; then
    echo "Error: Could not determine image name in podman run command."
    usage
fi


CONTAINER_ID=$(podman run -d "${FINAL_RUN_OPTS[@]}" "$IMAGE" tail -f /dev/null)

if [[ ${#CMD_ARGS[@]} -eq 0 ]]; then
    CMD_ARGS=(bash)
fi

exec podman exec -it "$CONTAINER_ID" "${CMD_ARGS[@]}"
