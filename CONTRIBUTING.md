Contribute to Developer Images
================

## Developer Base Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based images

Available versions:
- **UBI 9**: [quay.io/devfile/base-developer-image:ubi9-latest](https://quay.io/repository/devfile/base-developer-image/)
- **UBI 10**: [quay.io/devfile/base-developer-image:ubi10-latest](https://quay.io/repository/devfile/base-developer-image/)

Build with Docker buildkit:

**UBI 9:**
```bash
$ cd base/ubi9
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/base-developer-image:ubi9-latest .
```

**UBI 10:**
```bash
$ cd base/ubi10
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/base-developer-image:ubi10-latest .
```

## Developer Universal Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based image ([quay.io/devfile/universal-developer-image:ubi9-latest](https://quay.io/repository/devfile/universal-developer-image/))

Build with Docker buildkit:

```bash
$ cd universal/ubi9
$ DOCKER_BUILDKIT=1 docker image build --progress=plain -t quay.io/devfile/universal-developer-image:ubi9-latest .
```

To build for a specific architecture:

**UBI 9:**
```bash
# amd64
$ DOCKER_BUILDKIT=1 docker image build --platform linux/amd64 --progress=plain -t quay.io/devfile/universal-developer-image:ubi9-latest .

# arm64
$ DOCKER_BUILDKIT=1 docker image build --platform linux/arm64 --progress=plain -t quay.io/devfile/universal-developer-image:ubi9-latest .
```

**UBI 10 Base Image:**
```bash
# amd64
$ DOCKER_BUILDKIT=1 docker image build --platform linux/amd64 --progress=plain -t quay.io/devfile/base-developer-image:ubi10-latest .

# arm64
$ DOCKER_BUILDKIT=1 docker image build --platform linux/arm64 --progress=plain -t quay.io/devfile/base-developer-image:ubi10-latest .
```

## Registry Configuration

### Using Custom Registry

The build workflows support custom container registries through repository variables. This is useful for forks that want to publish to their own registry.

**To configure:**
1. In your fork, go to **Settings** → **Secrets and Variables** → **Actions** → **Variables**
2. Add a repository variable: `REGISTRY` = `your-registry.com/your-namespace`
3. All workflows will automatically use your custom registry

**Example:** Setting `REGISTRY` to `ghcr.io/youruser` will publish images to:
- `ghcr.io/youruser/base-developer-image:ubi9-latest`
- `ghcr.io/youruser/base-developer-image:ubi10-latest`
- `ghcr.io/youruser/universal-developer-image:ubi9-latest`
