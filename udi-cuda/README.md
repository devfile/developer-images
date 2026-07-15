# Info

Universal Developer Images (UDI) are containers that can be used
in OpenShift Dev Spaces.

Containers usable for Dev Spaces can use the [upstream container
build from Nvidia](https://hub.docker.com/r/nvidia/cuda)

## Quickstart

```
cd ubi8

# local build - runtime
podman build . \
  -t udi-cuda:11.8.0-cudnn8-runtime-ubi8 \
  --build-arg IMAGE_NAME=docker.io/nvidia/cuda:11.8.0-cudnn8-runtime-ubi8

# local build - devel
podman build . \
  -t udi-cuda:11.8.0-cudnn8-devel-ubi8 \
  --build-arg IMAGE_NAME=docker.io/nvidia/cuda:11.8.0-cudnn8-devel-ubi8

# local build - runtime
podman build . \
  -t udi-cuda:12.2.0-runtime-ubi8 \
  --build-arg IMAGE_NAME=docker.io/nvidia/cuda:12.2.0-runtime-ubi8

# local build - devel
podman build . \
  -t udi-cuda:12.2.0-devel-ubi8 \
  --build-arg IMAGE_NAME=docker.io/nvidia/cuda:12.2.0-devel-ubi8
```

## Links

- [Nvidia - CUDA Container Sources](https://gitlab.com/nvidia/container-images/cuda.git)

## Notes
