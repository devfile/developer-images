# syntax=docker/dockerfile:1.3-labs

# https://registry.access.redhat.com/ubi8/ubi
FROM registry.access.redhat.com/ubi8/ubi:8.7-1112
LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="devfile-base-container"
LABEL name="devfile/base-developer-image"
LABEL version="ubi8"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="devfile base developer image"
LABEL description="Image with base developers tools. Languages SDK and runtimes excluded."
LABEL io.k8s.display-name="devfile-developer-base"
LABEL io.openshift.expose-services=""

USER 0

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf update -y && \
    dnf install -y bash curl diffutils git git-lfs iproute jq less lsof man nano procps p7zip p7zip-plugins \
                   perl-Digest-SHA net-tools openssh-clients rsync socat sudo time vim wget zip && \
                   dnf clean all

## gh-cli
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    GH_VERSION="2.0.0"; \
    GH_ARCH="linux_amd64"; \
    GH_TGZ="gh_${GH_VERSION}_${GH_ARCH}.tar.gz"; \
    GH_TGZ_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/${GH_TGZ}"; \
    GH_CHEKSUMS_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_checksums.txt"; \
    curl -sSLO "${GH_TGZ_URL}"; \
    curl -sSLO "${GH_CHEKSUMS_URL}"; \
    sha256sum --ignore-missing -c "gh_${GH_VERSION}_checksums.txt" 2>&1 | grep OK; \
    tar -zxvf "${GH_TGZ}"; \
    mv "gh_${GH_VERSION}_${GH_ARCH}"/bin/gh /usr/local/bin/; \
    cd -; \
    rm -rf "${TEMP_DIR}"

## ripgrep
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    RG_VERSION="13.0.0"; \
    RG_ARCH="x86_64-unknown-linux-musl"; \
    RG_TGZ="ripgrep-${RG_VERSION}-${RG_ARCH}.tar.gz"; \
    RG_TGZ_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/${RG_TGZ}"; \
    curl -sSLO "${RG_TGZ_URL}"; \
    tar -zxvf "${RG_TGZ}"; \
    mv "ripgrep-${RG_VERSION}-${RG_ARCH}"/rg /usr/local/bin/; \
    cd -; \
    rm -rf "${TEMP_DIR}"

## bat
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    BAT_VERSION="0.18.3"; \
    BAT_ARCH="x86_64-unknown-linux-musl"; \
    BAT_TGZ="bat-v${BAT_VERSION}-${BAT_ARCH}.tar.gz"; \
    BAT_TGZ_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${BAT_TGZ}"; \
    curl -sSLO "${BAT_TGZ_URL}"; \
    tar -zxvf "${BAT_TGZ}"; \
    mv "bat-v${BAT_VERSION}-${BAT_ARCH}"/bat /usr/local/bin/; \
    cd -; \
    rm -rf "${TEMP_DIR}"

COPY --chown=0:0 entrypoint.sh /
RUN \
    # add user and configure it
    useradd -u 10001 -G wheel,root -d /home/user --shell /bin/bash -m user && \
    # Setup $PS1 for a consistent and reasonable prompt
    echo "export PS1='\W \`git branch --show-current 2>/dev/null | sed -r -e \"s@^(.+)@\(\1\) @\"\`$ '" >> /home/user/.bashrc && \
    # Copy the global git configuration to user config as global /etc/gitconfig
    #  file may be overwritten by a mounted file at runtime
    cp /etc/gitconfig /home/user/.gitconfig && \
    # Set permissions on /etc/passwd and /home to allow arbitrary users to write
    chgrp -R 0 /home && \
    chmod -R g=u /etc/passwd /etc/group /home && \
    chmod +x /entrypoint.sh

USER 10001
ENV HOME=/home/user
WORKDIR /projects
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["tail", "-f", "/dev/null"]
