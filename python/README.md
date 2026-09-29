# Info

Dependencies can be created as container layers building upon a base image.

Specifically we are installing dependencies for Python on a udi-cuda base.

## Quickstart

```
cd ubi8/3.9

BASE_IMAGE=ghcr.io/redhat-na-ssa/udi-cuda:11.8.0-cudnn8-devel-ubi8

# local build - runtime
podman build . \
  -t udi-cuda:11.8.0-cudnn8-runtime-ubi8-python39 \
  --build-arg IMAGE_NAME=${BASE_IMAGE}

# local build - devel
podman build . \
  -t udi-cuda:11.8.0-cudnn8-devel-ubi8-python39 \
  --build-arg IMAGE_NAME=${BASE_IMAGE}

cd ubi8/3.11

# local build - runtime
podman build . \
  -t udi-cuda:11.8.0-cudnn8-runtime-ubi8-python311 \
  --build-arg IMAGE_NAME=${BASE_IMAGE}

# local build - devel
podman build . \
  -t udi-cuda:11.8.0-cudnn8-devel-ubi8-python311 \
  --build-arg IMAGE_NAME=${BASE_IMAGE}
```

## Links

- [Dev Spaces - Developer Images](https://github.com/devfile/developer-images)

## Notes
