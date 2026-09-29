#!/usr/bin/sh

[ -e /etc/containers/nodocker ] || \
echo "Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg." >&2
if [ "${KUBEDOCK_ENABLED:-false}" = "true" ]; then
  exec /usr/bin/podman.wrapper "$@"
else
  exec /usr/bin/podman "$@"
fi
