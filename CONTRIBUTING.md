Contribute to Developer Images
================

## Developer Base Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based image ([quay.io/devfile/base-developer-image:ubi9-latest](https://quay.io/repository/devfile/base-developer-image/))

Build with Docker buildkit:

```bash
$ cd base/ubi9
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/base-developer-image:ubi9-latest .
```

## Developer Universal Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based image ([quay.io/devfile/universal-developer-image:ubi9-latest](https://quay.io/repository/devfile/universal-developer-image/))

Build with Docker buildkit:

```bash
$ cd universal/ubi9
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/universal-developer-image:ubi9-latest .
```

To build for a specific architecture:

```bash
# amd64
$ DOCKER_BUILDKIT=1 docker image build --platform linux/amd64 --progress=plain -t quay.io/devfile/universal-developer-image:ubi9-latest .

# arm64
$ DOCKER_BUILDKIT=1 docker image build --platform linux/arm64 --progress=plain -t quay.io/devfile/universal-developer-image:ubi9-latest .
```
