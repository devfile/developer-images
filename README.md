[![Contribute](https://www.eclipse.org/che/contribute.svg)](https://workspaces.openshift.com#https://github.com/devfile/developer-images)
[![Dev](https://img.shields.io/static/v1?label=Open%20in&message=Che%20dogfooding%20server%20(with%20VS%20Code)&logo=eclipseche&color=FDB940&labelColor=525C86)](https://che-dogfooding.apps.che-dev.x6e0.p1.openshiftapps.com/#https://github.com/devfile/developer-images)

# Developer Images

[![Build of UBI 9 based Developer Images](https://github.com/devfile/developer-images/actions/workflows/ubi9-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi9-build.yaml)
[![Build of UBI 10 based Developer Images](https://github.com/devfile/developer-images/actions/workflows/ubi10-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi10-build.yaml)

Containers images with tools for developers 👨‍💻👩‍💻

## Developer Base Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based images

Available versions:

- **UBI 9**: [quay.io/devfile/base-developer-image:ubi9-latest](https://quay.io/repository/devfile/base-developer-image)
- **UBI 10**: [quay.io/devfile/base-developer-image:ubi10-latest](https://quay.io/repository/devfile/base-developer-image)

Run the following commands to test with Docker:

**UBI 9:**

```bash
$ docker run -ti --rm \
       quay.io/devfile/base-developer-image:ubi9-latest \
       bash
```

**UBI 10:**

```bash
$ docker run -ti --rm \
       quay.io/devfile/base-developer-image:ubi10-latest \
       bash
```

### Included Development Tools

| Tool                | ubi9 based image                    | ubi10 based image                   |
|---------------------|-------------------------------------|-------------------------------------|
| `bash`              |`bash`                               |`bash`                               |
| `bat`               |`<gh releases>`                      |`<gh releases>`                      |
| `buildah`           |`buildah`                            |`buildah`                            |
| `curl`              |`curl`                               |`curl`                               |
| `ps`                |`ps`                                 |`ps`                                 |
| `diff`              |`diffutils`                          |`diffutils`                          |
| `emacs`             |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `fish`              |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `gh`                |`<gh releases>`                      |`<gh releases>`                      |
| `git`               |`git`                                |`git`                                |
| `git-lfs`           |`git-lfs`                            |`git-lfs`                            |
| `ip`                |`iproute`                            |`iproute`                            |
| `jq`                |`jq`                                 |`jq`                                 |
| `htop`              |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `kubedock`          |`<gh releases>`                      |`<gh releases>`                      |
| `less`              |`less`                               |`less`                               |
| `lsof`              |`lsof`                               |`lsof`                               |
| `man`               |`man`                                |`man`                                |
| `nano`              |`nano`                               |`nano`                               |
| `netcat`            |`NOT AVAILABLE`                      |`NOT AVAILABLE`                      |
| `netstat`           |`net-tools`                          |`net-tools`                          |
| `openssh-client`    |`openssh-clients`                    |`openssh-clients`                    |
| `podman`            |`podman`                             |`podman`                             |
| `7z`                |`p7zip-plugins`                      |`p7zip-plugins`                      |
| `ripgrep`           |`<gh releases>`                      |`<gh releases>`                      |
| `rsync`             |`rsync`                              |`rsync`                              |
| `scp`               |`openssh-clients`                    |`openssh-clients`                    |
| `screen`            |`NOT AVAILABLE`                      |`NOT AVAILABLE`                      |
| `sed`               |`sed`                                |`sed`                                |
| `shasum`            |`perl-Digest-SHA`                    |`perl-Digest-SHA`                    |
| `socat`             |`socat`                              |`socat`                              |
| `sudo`              |`sudo`                               |`sudo`                               |
| `ss`                |`NOT AVAILABLE`                      |`NOT AVAILABLE`                      |
| `ssl-cert`          |`NOT AVAILABLE`                      |`NOT AVAILABLE`                      |
| `stow`              |`stow`                               |`stow`                               |
| `tail`              |`<built in>`                         |`<built in>`                         |
| `tar`               |`tar`                                |`tar`                                |
| `time`              |`time`                               |`time`                               |
| `tldr`              |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `tmux`              |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `vim`               |`vim`                                |`vim`                                |
| `wget`              |`wget`                               |`wget`                               |
| `zip`               |`zip`                                |`zip`                                |
| `zsh`               |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| **TOTAL SIZE**      | **800MB** (255MB compressed)        | **789MB** (256MB compressed)   |

### Extending the base image

When extending the base image, `source kubedock_setup` should be called in the new image's entrypoint to set up kubedock support. This sets up a wrapper for podman to use kubedock for the following podman commands if the `KUBEDOCK_ENABLED` env variable is set to `true`:

```text
podman run
podman ps
podman exec
podman cp
podman logs
podman inspect
podman kill
podman rm
podman wait
podman stop
podman start
```

An example is available in the [Universal Developer Image dockerfile](https://github.com/devfile/developer-images/blob/main/universal/ubi9/entrypoint.sh#L3).

## Developer Universal Image

### UBI 9 based image

**Image:** [quay.io/devfile/universal-developer-image:ubi9-latest](https://quay.io/repository/devfile/universal-developer-image)

**Test:**

```bash
docker run -ti --rm quay.io/devfile/universal-developer-image:ubi9-latest bash
```

**Included Development Tools:**

| Tool or language    | ubi9 based image                    |
|---------------------|-------------------------------------|
|--------JAVA---------|-------------------------------------|
| `sdk`               |`<https://get.sdkman.io>`            |
| `java`              |`<8.0.432-tem via sdkman>`           |
| `java`              |`<11.0.25-tem via sdkman>`           |
| `java`              |`<17.0.13-tem via sdkman>/default`   |
| `java`              |`<21.0.5-tem via sdkman>`            |
| `maven`             |`<via sdkman>`                       |
| `gradle`            |`<via sdkman>`                       |
| `mandrel`           |`<22.1.2.r21-mandrel via sdkman>`    |
| `jbang`             |`<via sdkman>`                       |
|--------SCALA--------|-------------------------------------|
| `cs`                |`<https://get-coursier.io/>`         |
| `sbt`               |`<sbt launch script>`                |
| `mill`              |`<mill launch script>`               |
|--------C/CPP--------|-------------------------------------|
| `clang`             |`clang`                              |
| `clangd`            |`llvm-toolset`                       |
| `gdb`               |`gdb`                                |
|--------PHP----------|-------------------------------------|
| `php`               |`php`                                |
| `composer`          |`https://getcomposer.org/`           |
| `xdebug`            |`pecl`                               |
|-------NODEJS--------|-------------------------------------|
| `nodejs`            |`nodejs`                             |
| `npm`               |`npm`                                |
| `yarn`              |`<via npm>`                          |
|--------GO-----------|-------------------------------------|
| `go`                |`go-toolset`                         |
| `gopls`             |`golang.org/x/tools/gopls v0.21.0`   |
|--------.NET---------|-------------------------------------|
| `dotnet`            |`dotnet-sdk-8.0`                     |
|------PYTHON---------|-------------------------------------|
| `python`            |`python3.11`                         |
| `setuptools`        |`python3.11-setuptools`              |
| `pip`               |`python3.11-pip`                     |
| `pylint`            |`<via pip>`                          |
| `yq`                |`<via pip>`                          |
|--------RUST---------|-------------------------------------|
| `rustup`            |`<sh.rustup.rs>`                     |
| `rust-src`          |`<via rustup>`                       |
| `rust-analysis`     |`<via rustup>`                       |
|--------Platform-----|-------------------------------------|
| `camel-k`           |`<gh release>`                       |
|------CLOUD----------|-------------------------------------|
| `oc`                |`mirror.openshift.com`               |
| `tkn`               |`mirror.openshift.com`               |
| `podman`            |`container-tools:rhel8`              |
| `buildah`           |`container-tools:rhel8`              |
| `skopeo`            |`container-tools:rhel8`              |
| `kubectl`           |`<kubernetes dnf repo>`              |
| `krew`              |`<gh releases>`                      |
| `helm`              |`<get.helm.sh>`                      |
| `kustomize`         |`<gh releases>`                      |
| `tkn`               |`<gh releases>`                      |
| `kn`                |`<gh releases>`                      |
| `terraform`         |`<releases.hashicorp.com>`           |
| `docker`            |`<download.docker.com>`              |
| `docker-compose`    |`<gh releases>`                      |
| `kamel`             |`<gh release>`                       |
| **TOTAL SIZE**      | **8.75GB** (3.6GB compressed)       |

**Libraries:**

- e2fsprogs v1.46.5

**Environment Variables:**

- JAVA_HOME_8, JAVA_HOME_11, JAVA_HOME_17, JAVA_HOME_21

### UBI 10 based image

**Image:** [quay.io/devfile/universal-developer-image:ubi10-latest](https://quay.io/repository/devfile/universal-developer-image)

**Test:**

```bash
docker run -ti --rm quay.io/devfile/universal-developer-image:ubi10-latest bash
```

**Included Development Tools:**

| Tool or language    | ubi10 based image                   |
|---------------------|-------------------------------------|
|--------JAVA---------|-------------------------------------|
| `sdk`               |`<https://get.sdkman.io>`            |
| `java`              |`<8.0.472-tem via sdkman>`           |
| `java`              |`<11.0.29-tem via sdkman>`           |
| `java`              |`<17.0.17-tem via sdkman>`           |
| `java`              |`<21.0.9-tem via sdkman>`            |
| `java`              |`<23.0.2-tem via sdkman>/default`    |
| `java`              |`<25.0.1.r25-mandrel via sdkman>`    |
| `maven`             |`<via sdkman>`                       |
| `gradle`            |`<via sdkman>`                       |
| `jbang`             |`<via sdkman>`                       |
|--------SCALA--------|-------------------------------------|
| `cs`                |`<https://get-coursier.io/>`         |
| `sbt`               |`<sbt launch script>`                |
| `mill`              |`<mill launch script>`               |
|--------C/CPP--------|-------------------------------------|
| `gcc`               |`gcc`                                |
| `g++`               |`gcc-c++`                            |
| `clang`             |`clang`                              |
| `gdb`               |`gdb`                                |
|--------PHP----------|-------------------------------------|
| `php`               |`php 8.3`                            |
| `composer`          |`dnf`                                |
| `xdebug`            |`php-pecl-xdebug`                    |
|-------NODEJS--------|-------------------------------------|
| `nodejs`            |`24.12.0 (default), 22.21.1`         |
| `npm`               |`npm`                                |
| `yarn`              |`v1.22.22`                           |
|--------GO-----------|-------------------------------------|
| `go`                |`go-toolset 1.25+`                   |
| `gopls`             |`golang.org/x/tools/gopls v0.21.0`   |
|--------.NET---------|-------------------------------------|
| `dotnet`            |`dotnet-sdk-10.0`                    |
|------PYTHON---------|-------------------------------------|
| `python`            |`python3.13`                         |
| `setuptools`        |`python3.13-setuptools`               |
| `pip`               |`python3.13-pip`                     |
| `pylint`            |`<via pip>`                          |
| `yq`                |`<via pip>`                          |
|--------RUST---------|-------------------------------------|
| `rustup`            |`<sh.rustup.rs>`                     |
| `rust-src`          |`<via rustup>`                       |
| `rust-analysis`     |`<via rustup>`                       |
| `rust-analyzer`     |`<via rustup>`                       |
|--------Platform-----|-------------------------------------|
| `camel-k`           |`v2.8.0`                             |
|------CLOUD----------|-------------------------------------|
| `oc`                |`v4.20`                              |
| `tkn`               |`v1.20.0 (OpenShift)`                |
| `kubectl`           |`v1.28`                              |
| `krew`              |`v0.4.5`                             |
| `helm`              |`v4.0.4`                             |
| `kustomize`         |`v5.8.0`                             |
| `tkn`               |`v0.43.0 (Tekton)`                   |
| `kn`                |`v1.20.0`                            |
| `terraform`         |`v1.14.2`                            |
| `skaffold`          |`<latest>`                           |
| `kamel`             |`v2.8.0`                             |
| `shellcheck`        |`v0.11.0`                            |
| **TOTAL SIZE**      | **TBD**                             |

**Libraries:**

- e2fsprogs v1.47.3

**Environment Variables:**

- JAVA_HOME_8, JAVA_HOME_11, JAVA_HOME_17, JAVA_HOME_21, JAVA_HOME_23, JAVA_HOME_25

## Configuration

### Registry Override

The workflows support using custom container registries through the `REGISTRY` environment variable. This is useful for forks that want to publish to their own registry.

**Default behavior:** Images are published to `quay.io/devfile`

**To override in a fork:**

1. Go to your repository **Settings** → **Secrets and Variables** → **Actions** → **Variables**
2. Add a repository variable: `REGISTRY` = `your-registry.com/your-namespace`
3. All workflows will automatically use your custom registry

**Example registry formats:**

- `quay.io/youruser`
- `ghcr.io/youruser`
- `docker.io/youruser`
- `your-private-registry.com/namespace`

# Builds

This repo contains [actions](https://github.com/devfile/developer-images/actions), including:

- [![release latest stable UBI 9](https://github.com/devfile/developer-images/actions/workflows/ubi9-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi9-build.yaml)
- [![release latest stable UBI 10](https://github.com/devfile/developer-images/actions/workflows/ubi10-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi10-build.yaml)

Downstream builds can be found at the link below, which is _internal to Red Hat_. Stable builds can be found by replacing the 3.x with a specific version like 3.2.

- [udi_3.x](https://main-jenkins-csb-crwqe.apps.ocp-c1.prod.psi.redhat.com/job/DS_CI/job/udi_3.x)

# License

Che is open sourced under the Eclipse Public License 2.0.
