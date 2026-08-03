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
| `bat`               |`v0.26.0 <gh releases>`             |`v0.18.3 <gh releases>`             |
| `buildah`           |`buildah`                            |`buildah`                            |
| `curl`              |`curl`                               |`curl`                               |
| `ps`                |`procps`                             |`procps`                             |
| `diff`              |`diffutils`                          |`diffutils`                          |
| `emacs`             |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `fd`                |`10.3.0 <gh releases>`              |`8.7.0 <gh releases>`               |
| `fish`              |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `gh`                |`2.83.2 <gh releases>`              |`2.78.0 <gh releases>`              |
| `git`               |`git`                                |`git`                                |
| `git-lfs`           |`git-lfs`                            |`git-lfs`                            |
| `ip`                |`iproute`                            |`iproute`                            |
| `jq`                |`jq`                                 |`jq`                                 |
| `htop`              |`NOT AVAILABLE (fedora only)`        |`NOT AVAILABLE (fedora only)`        |
| `kubedock`          |`0.19.0 <gh releases>`              |`0.18.2 <gh releases>`              |
| `less`              |`less`                               |`less`                               |
| `lsof`              |`lsof`                               |`lsof`                               |
| `man`               |`man`                                |`man`                                |
| `nano`              |`nano`                               |`nano`                               |
| `netcat`            |`NOT AVAILABLE`                      |`NOT AVAILABLE`                      |
| `netstat`           |`net-tools`                          |`net-tools`                          |
| `openssh-client`    |`openssh-clients`                    |`openssh-clients`                    |
| `podman`            |`podman`                             |`podman`                             |
| `7z`                |`p7zip-plugins`                      |`p7zip-plugins`                      |
| `ripgrep`           |`15.1.0 <gh releases>`              |`<gh releases>`                     |
| `rsync`             |`rsync`                              |`rsync`                              |
| `scp`               |`openssh-clients`                    |`openssh-clients`                    |
| `screen`            |`NOT AVAILABLE`                      |`NOT AVAILABLE`                      |
| `sed`               |`sed`                                |`sed`                                |
| `shasum`            |`perl-Digest-SHA`                    |`perl-Digest-SHA`                    |
| `skopeo`            |`skopeo`                             |`skopeo`                             |
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
| `sdk`               |`SDKMAN 5.23.0`                      |
| `java`              |`<8.0.432-tem via sdkman>`           |
| `java`              |`<11.0.25-tem via sdkman>`           |
| `java`              |`<17.0.13-tem via sdkman>/default`   |
| `java`              |`<21.0.5-tem via sdkman>`            |
| `maven`             |`<via sdkman>`                       |
| `gradle`            |`<via sdkman>`                       |
| `mandrel`           |`<23.1.5.r21-mandrel via sdkman>`    |
| `jbang`             |`<via sdkman>`                       |
| `lombok`            |`1.18.18`                            |
|--------SCALA--------|-------------------------------------|
| `cs`                |`<https://get-coursier.io/>`         |
| `sbt`               |`<sbt launch script>`                |
| `mill`              |`<mill launch script>`               |
|--------C/CPP--------|-------------------------------------|
| `gcc`               |`gcc`                                |
| `g++`               |`gcc-c++`                            |
| `clang`             |`clang`                              |
| `clangd`            |`llvm-toolset`                       |
| `gdb`               |`gdb`                                |
|--------PHP----------|-------------------------------------|
| `php`               |`php 8.2`                            |
| `composer`          |`https://getcomposer.org/`           |
| `xdebug`            |`php-pecl-xdebug`                    |
|-------NODEJS--------|-------------------------------------|
| `nodejs`            |`22.22.3 (default), 20.20.2, 18.20.8`|
| `npm`               |`npm`                                |
| `yarn`              |`v1.22.22`                           |
|--------GO-----------|-------------------------------------|
| `go`                |`go 1.22.5`                          |
| `gopls`             |`golang.org/x/tools/gopls v0.16.2`   |
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
| Apache Camel K (`kamel`)           |`v2.2.0`                             |
|------CLOUD----------|-------------------------------------|
| `oc`                |`v4.15`                              |
| `tkn`               |`0.20.0`                |
| `kubectl`           |`v1.30.1`                            |
| `krew`              |`v0.5.0`                             |
| `helm`              |`v3.14.3`                            |
| `kustomize`         |`v5.3.0`                             |
| `tkn`               |`v0.20.0 (Tekton)`                   |
| `kn`                |`v1.13.0`                            |
| `terraform`         |`v1.7.5`                             |
| `skaffold`          |`<latest>`                           |
| `kamel`             |`v2.2.0`                             |
| `gcloud`            |`565.0.0`                            |
| `shellcheck`        |`v0.8.0`                             |
| `tmux`              |`3.6a`                               |
| `herdr`             |`v0.7.3`                             |
|------SANDBOX---------|-------------------------------------|
| `bubblewrap`        |`v0.11.2 (built from source)`        |
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
| `sdk`               |`SDKMAN 5.23.0`                      |
| `java`              |`<8.0.472-tem via sdkman>`           |
| `java`              |`<11.0.29-tem via sdkman>`           |
| `java`              |`<17.0.17-tem via sdkman>`           |
| `java`              |`<21.0.9-tem via sdkman>`            |
| `java`              |`<23.0.2-tem via sdkman>/default`    |
| `mandrel`           |`<25.0.1.r25-mandrel via sdkman>`    |
| `maven`             |`<via sdkman>`                       |
| `gradle`            |`<via sdkman>`                       |
| `jbang`             |`<via sdkman>`                       |
| `lombok`            |`1.18.42`                            |
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
| `php`               |`php`                                |
| `composer`          |`dnf`                                |
| `xdebug`            |`php-pecl-xdebug`                    |
|-------NODEJS--------|-------------------------------------|
| `nodejs`            |`24.12.0 (default), 22.21.1`         |
| `npm`               |`npm`                                |
| `yarn`              |`v1.22.22`                           |
|--------GO-----------|-------------------------------------|
| `go`                |`go 1.25.5`                          |
| `gopls`             |`golang.org/x/tools/gopls v0.21.0`   |
|--------.NET---------|-------------------------------------|
| `dotnet`            |`dotnet-sdk-10.0`                    |
|------PYTHON---------|-------------------------------------|
| `python`            |`python3.13`                         |
| `setuptools`        |`python3.13-setuptools`              |
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
| `kubectl`           |`v1.30.1`                            |
| `krew`              |`v0.5.0`                             |
| `helm`              |`v4.0.4`                             |
| `kustomize`         |`v5.8.0`                             |
| `tkn`               |`v0.43.0 (Tekton)`                   |
| `kn`                |`v1.20.0`                            |
| `terraform`         |`v1.14.0`                            |
| `skaffold`          |`<latest>`                           |
| `kamel`             |`v2.8.0`                             |
| `gcloud`            |`565.0.0`                            |
| `shellcheck`        |`v0.11.0`                            |
| `tmux`              |`3.6a`                               |
| `herdr`             |`v0.7.3`                             |
|------SANDBOX---------|-------------------------------------|
| `bubblewrap`        |`v0.11.2 (built from source)`        |
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
