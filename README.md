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
| **TOTAL SIZE**      | **903MB** (341MB compressed)        | **TODO**   |

### Extending the base image
When extending the base image, `source kubedock_setup` should be called in the new image's entrypoint to set up kubedock support. This sets up a wrapper for podman to use kubedock for the following podman commands if the `KUBEDOCK_ENABLED` env variable is set to `true`:
```
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

An example is available in the Universal Developer Image dockerfile [here](https://github.com/devfile/developer-images/blob/main/universal/ubi9/entrypoint.sh#L3).

## Developer Universal Image

### Red Hat Universal Base Image ([UBI](https://developers.redhat.com/articles/ubi-faq#)) based image ([quay.io/devfile/universal-developer-image:ubi9-latest](https://quay.io/repository/devfile/universal-developer-image))

Run the following command to test it with Docker: 

```bash
docker run -ti --rm \
       quay.io/devfile/universal-developer-image:ubi9-latest \
       bash
```
### Included Development Tools

| Tool or language    | ubi9 based image                    |
|---------------------|-------------------------------------|
|--------JAVA---------|-------------------------------------|
| `sdk`               |`<https://get.sdkman.io>`            |
| `java`              |`<8.0.432-tem via sdkman>`           |
| `java`              |`<11.0.25-tem via sdkman>`           |
| `java`              |`<17.0.13-tem via sdkman>/default`   |
| `java`              |`<21.0.5-tem via sdkman>`   |
| `maven`             |`<via sdkman>`                       |
| `gradle`            |`<via sdkman>`                       |
| `mandrel`           |`<22.1.2.r21-mandrel via sdkman>`  |
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

### Included libraries

#### e2fsprogs v1.46.5

### Environment Variables

#### Java
JAVA_HOME_8, JAVA_HOME_11, JAVA_HOME_17, JAVA_HOME_21

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
* [![release latest stable UBI 9](https://github.com/devfile/developer-images/actions/workflows/ubi9-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi9-build.yaml)
* [![release latest stable UBI 10](https://github.com/devfile/developer-images/actions/workflows/ubi10-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi10-build.yaml)

Downstream builds can be found at the link below, which is _internal to Red Hat_. Stable builds can be found by replacing the 3.x with a specific version like 3.2.  

* [udi_3.x](https://main-jenkins-csb-crwqe.apps.ocp-c1.prod.psi.redhat.com/job/DS_CI/job/udi_3.x)

# License

Che is open sourced under the Eclipse Public License 2.0.
