# syntax=docker/dockerfile:1.3-labs

# https://registry.access.redhat.com/ubi10/ubi
FROM --platform=$BUILDPLATFORM registry.access.redhat.com/ubi10/ubi:10.0-1756805986

ARG TARGETARCH
LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="devfile-base-container"
LABEL name="devfile/base-developer-image"
LABEL version="ubi10"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="devfile base developer image"
LABEL description="Image with base developers tools. Languages SDK and runtimes excluded."
LABEL io.k8s.display-name="devfile-developer-base"
LABEL io.openshift.expose-services=""

USER 0

ENV HOME=/home/tooling
RUN mkdir -p /home/tooling/

## install packages from epel 10
RUN \
    # Install the primary EPEL 10 repository
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm && \
    \
    # Install the main list of packages
    dnf install -y diffutils git git-lfs iproute jq less lsof man nano procps p7zip p7zip-plugins \
    perl-Digest-SHA net-tools openssh-clients rsync socat sudo time vim wget zip && \
    # Final update and cleanup
    dnf update -y && \
    dnf clean all

# install stow from EPEL 9 as it is not yet available in EPEL 10
RUN \
    # Import EPEL 9 key and create the disabled repo file
    rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-9 && \
    printf '[epel9]\nname=Extra Packages for Enterprise Linux 9 - $basearch\nmetalink=https://mirrors.fedoraproject.org/metalink?repo=epel-9&arch=$basearch\nenabled=0\ngpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-9\n' > /etc/yum.repos.d/epel-9.repo && \
    # Install stow using the temporarily enabled repo
    dnf install -y --enablerepo=epel9 stow && \
    dnf clean all && \
    rm /etc/yum.repos.d/epel-9.repo

## podman buildah skopeo
RUN dnf -y reinstall shadow-utils && \
    dnf -y install podman buildah skopeo fuse-overlayfs && \
    dnf clean all

# Download and install gh-cli depending on the architecture.
# See release page for details https://github.com/cli/cli/releases/tag/v2.73.0
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    GH_VERSION="2.73.0"; \
    GH_ARCH="linux_$TARGETARCH"; \
    GH_TGZ="gh_${GH_VERSION}_${GH_ARCH}.tar.gz"; \
    GH_TGZ_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/${GH_TGZ}"; \
    GH_CHEKSUMS_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_checksums.txt"; \
    curl -sSLO "${GH_TGZ_URL}"; \
    curl -sSLO "${GH_CHEKSUMS_URL}"; \
    sha256sum --ignore-missing -c "gh_${GH_VERSION}_checksums.txt" 2>&1 | grep OK; \
    tar -zxv --no-same-owner -f "${GH_TGZ}"; \
    mv "gh_${GH_VERSION}_${GH_ARCH}"/bin/gh /usr/local/bin/; \
    mv "gh_${GH_VERSION}_${GH_ARCH}"/share/man/man1/* /usr/local/share/man/man1; \
    cd -; \
    rm -rf "${TEMP_DIR}"

# Download and install ripgrep depending on the architecture.
# See release page for details https://github.com/BurntSushi/ripgrep/releases/tag/13.0.0
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    RG_VERSION="13.0.0"; \
    if [ "$TARGETARCH" = "arm64" ]; then \
        RG_ARCH="arm-unknown-linux-gnueabihf"; \
    else \
        RG_ARCH="x86_64-unknown-linux-musl"; \
    fi; \
    RG_TGZ="ripgrep-${RG_VERSION}-${RG_ARCH}.tar.gz"; \
    RG_TGZ_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/${RG_TGZ}"; \
    curl -sSLO "${RG_TGZ_URL}"; \
    tar -zxv --no-same-owner -f "${RG_TGZ}"; \
    mv "ripgrep-${RG_VERSION}-${RG_ARCH}"/rg /usr/local/bin/; \
    mv "ripgrep-${RG_VERSION}-${RG_ARCH}"/doc/rg.1 /usr/local/share/man/man1; \
    cd -; \
    rm -rf "${TEMP_DIR}"

# Download and install bat depending on the architecture.
# See release page for details https://github.com/sharkdp/bat/releases/tag/v0.18.3
RUN \
    TEMP_DIR="$(mktemp -d)"; \
    cd "${TEMP_DIR}"; \
    BAT_VERSION="0.18.3"; \
    if [ "$TARGETARCH" = "arm64" ]; then \
        BAT_ARCH="aarch64-unknown-linux-gnu"; \
    else \
        BAT_ARCH="x86_64-unknown-linux-musl"; \
    fi; \
    BAT_TGZ="bat-v${BAT_VERSION}-${BAT_ARCH}.tar.gz"; \
    BAT_TGZ_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${BAT_TGZ}"; \
    curl -sSLO "${BAT_TGZ_URL}"; \
    tar -zxv --no-same-owner -f "${BAT_TGZ}"; \
    mv "bat-v${BAT_VERSION}-${BAT_ARCH}"/bat /usr/local/bin/; \
    mv "bat-v${BAT_VERSION}-${BAT_ARCH}"/bat.1 /usr/local/share/man/man1; \
    cd -; \
    rm -rf "${TEMP_DIR}"

# Download and install fd depending on the architecture.
# See release page for details https://github.com/sharkdp/fd/releases/tag/v8.7.0
RUN \
    TEMP_DIR="$(mktemp -d)" && \
    cd "${TEMP_DIR}" && \
    FD_VERSION="8.7.0" && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        FD_ARCH="aarch64-unknown-linux-gnu"; \
    else \
        FD_ARCH="x86_64-unknown-linux-musl"; \
    fi && \
    FD_TGZ="fd-v${FD_VERSION}-${FD_ARCH}.tar.gz" && \
    FD_TGZ_URL="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/${FD_TGZ}" && \
    curl -sSLO "${FD_TGZ_URL}" && \
    tar -xv --no-same-owner -f "${FD_TGZ}" && \
    mv "fd-v${FD_VERSION}-${FD_ARCH}"/fd /usr/local/bin && \
    mv "fd-v${FD_VERSION}-${FD_ARCH}"/fd.1 /usr/local/share/man/man1 && \
    cd - && \
    rm -rf "${TEMP_DIR}"

# Define user directory for binaries
ENV PATH="/home/user/.local/bin:$PATH"

# Set up environment variables to note that this is
# not starting with usernamespace and default to
# isolate the filesystem with chroot.
ENV _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot

# Tweaks to make rootless buildah work
RUN touch /etc/subgid /etc/subuid  && \
    chmod g=u /etc/subgid /etc/subuid /etc/passwd  && \
    echo user:10000:65536 > /etc/subuid  && \
    echo user:10000:65536 > /etc/subgid

# Adjust storage.conf to enable Fuse storage.
RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /usr/share/containers/storage.conf
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; \
    touch /var/lib/shared/overlay-images/images.lock; \
    touch /var/lib/shared/overlay-layers/layers.lock

# Add kubedock
# See release page for details https://github.com/joyrex2001/kubedock/releases/tag/0.18.1
ENV KUBEDOCK_VERSION 0.18.1
ENV KUBECONFIG=/home/user/.kube/config
RUN KUBEDOCK_ARCH="linux_amd64" && \
    curl -L https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/kubedock_${KUBEDOCK_VERSION}_${KUBEDOCK_ARCH}.tar.gz | tar -C /usr/local/bin -xz --no-same-owner \
    && chmod +x /usr/local/bin/kubedock
COPY --chown=0:0 kubedock_setup.sh /usr/local/bin/kubedock_setup

# Configure Podman wrapper
ENV PODMAN_WRAPPER_PATH=/usr/bin/podman.wrapper
ENV ORIGINAL_PODMAN_PATH=/usr/bin/podman.orig
COPY --chown=0:0 podman-wrapper.sh "${PODMAN_WRAPPER_PATH}"
RUN mv /usr/bin/podman "${ORIGINAL_PODMAN_PATH}"

COPY --chown=0:0 entrypoint.sh /
COPY --chown=0:0 .stow-local-ignore /home/tooling/
COPY --chown=0:0 .copy-files /home/tooling/
RUN \
    # add user and configure it
    useradd -u 10001 -G wheel,root -d /home/user --shell /bin/bash -m user && \
    # Setup $PS1 for a consistent and reasonable prompt
    touch /etc/profile.d/udi_prompt.sh && \
    chown 10001 /etc/profile.d/udi_prompt.sh && \
    echo "export PS1='\W \`git branch --show-current 2>/dev/null | sed -r -e \"s@^(.+)@\(\1\) @\"\`$ '" >> /etc/profile.d/udi_prompt.sh && \
    # Copy the global git configuration to user config as global /etc/gitconfig
    # file may be overwritten by a mounted file at runtime
    cp /etc/gitconfig ${HOME}/.gitconfig && \
    chown 10001 ${HOME}/ ${HOME}/.viminfo ${HOME}/.gitconfig ${HOME}/.stow-local-ignore ${HOME}/.copy-files && \
    # Set permissions on /etc/passwd and /home to allow arbitrary users to write
    chgrp -R 0 /home && \
    chmod -R g=u /etc/passwd /etc/group /home && \
    chmod +x /entrypoint.sh && \
    # Create symbolic links from /home/tooling/ -> /home/user/
    stow . -t /home/user/ -d /home/tooling/ && \
    # .viminfo cannot be a symbolic link for security reasons, so copy it to /home/user/
    cp /home/tooling/.viminfo /home/user/.viminfo && \
    # Bash-related files are backed up to /home/tooling/ incase they are deleted when persistUserHome is enabled.
    cp /home/user/.bashrc /home/tooling/.bashrc && \
    cp /home/user/.bash_profile /home/tooling/.bash_profile && \
    chown 10001 /home/tooling/.bashrc /home/tooling/.bash_profile

USER 10001
ENV HOME=/home/user
WORKDIR /projects
# /usr/libexec/podman/catatonit is used to reap zombie processes
ENTRYPOINT ["/usr/libexec/podman/catatonit","--","/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
