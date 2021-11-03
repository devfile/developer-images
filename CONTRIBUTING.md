Contribute to Developer Images
================

## Developer Base Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based image ([quay.io/devfile/base-developer-image:ubi8-latest](https://quay.io/repository/devfile/base-developer-image/))

Build with Docker buildkit:

```bash
$ cd base/ubi8
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/base-developer-image:ubi8-latest .
```

## Developer Universal Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based image ([quay.io/devfile/universal-developer-image:ubi8-latest](https://quay.io/repository/devfile/universal-developer-image/))

Build with Docker buildkit:

```bash
$ cd universal/ubi8
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/universal-developer-image:ubi8-latest .
```
