# Developer Images

[![Build of UBI 8 based Developer Images](https://github.com/devfile/developer-images/actions/workflows/ubi8-build.yaml/badge.svg)](https://github.com/devfile/developer-images/actions/workflows/ubi8-build.yaml)

Containers images with tools for developers 👨‍💻👩‍💻

## Base Images

### [Red Hat Universal Base Image (UBI)](https://developers.redhat.com/articles/ubi-faq#) based image ([quay.io/devfile/base-developer-image:ubi8-latest](https://quay.io/repository/devfile/base-developer-image/))

Run the following command to test it with docker 

```bash
docker run -ti --rm \
       --entrypoint=bash \
       quay.io/devfile/base-developer-image:ubi8-latest
```
### Tools included in the images

| Tool                | ubi8 based imate                    |
|---------------------|-------------------------------------|
| `bash`              |`bash`                               |
| `bat`               |`<gh releases>`                      |
| `curl`              |`curl`                               |
| `diff`              |`diffutils`                          |
| `emacs`             |`NOT AVAILABLE (fedora only)`        |
| `fish`              |`NOT AVAILABLE (fedora only)`        |
| `gh`                |`<gh releases>`                      |
| `git`               |`git`                                |
| `ip`                |`iproute`                            |
| `jq`                |`jq`                                 |
| `htop`              |`NOT AVAILABLE (fedora only)`        |
| `less`              |`less`                               |
| `lsof`              |`lsof`                               |
| `man`               |`man`                                |
| `nano`              |`nano`                               |
| `netcat`            |`NOT AVAILABLE`                      |
| `netstat`           |`net-tools`                          |
| `openssh-client`    |`openssh-clients`                    |
| `ripgrep`           |`<gh releases>`                      |
| `rsync`             |`rsync`                              |
| `scp`               |`openssh-clients`                    |
| `screen`            |`NOT AVAILABLE`                      |
| `sed`               |`sed`                                |
| `socat`             |`socat`                              |
| `sudo`              |`sudo`                               |
| `ss`                |`NOT AVAILABLE`                      |
| `ssl-cert`          |`NOT AVAILABLE`                      |
| `tail`              |`<built in>`                         |
| `tar`               |`tar`                                |
| `time`              |`time`                               |
| `tldr`              |`NOT AVAILABLE (fedora only)`        |
| `tmux`              |`NOT AVAILABLE (fedora only)`        |
| `vim`               |`vim`                                |
| `wget`              |`wget`                               |
| `zip`               |`zip`                                |
| `zsh`               |`NOT AVAILABLE (fedora only)`        |
| **TOTAL SIZE**      | **411MB** (143MB compressed)        |

## Universal Images

### [Red Hat Universal Base Image (UBI)](https://developers.redhat.com/articles/ubi-faq#) based image ([quay.io/devfile/universal-developer-image:ubi8-latest](https://quay.io/repository/devfile/universal-developer-image/))

Run the following command to test it with docker 

```bash
docker run -ti --rm \
       --entrypoint=bash \
       quay.io/devfile/universal-developer-image:ubi8-latest
```


| Tool or language    | ubi8 based image                    |
|---------------------|-------------------------------------|
| `sdk`               |`<https://get.sdkman.io>`            |
| `java`              |`<11.0.12-open via sdkman>`          |
| `maven`             |`<via sdkman>`                       |
| `gradle`            |`<via sdkman>`                       |
|---------------------|-------------------------------------|
| `nodejs`            |`nodejs`                             |
| `npm`               |`npm`                                |
| `yarn`              |`<via npm>`                          |
|---------------------|-------------------------------------|
| `go`                |`go-toolset`                         |
|---------------------|-------------------------------------|
| `python`            |`python39`                           |
| `setuptools`        |`python39-setuptools`                |
| `pip`               |`python39-pip`                       |
|---------------------|-------------------------------------|
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
| **TOTAL SIZE**      | **2.72GB** (1.1GB compressed)       |














