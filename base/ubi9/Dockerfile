# syntax=docker/dockerfile:1.3-labs

# https://catalog.redhat.com/en/software/containers/ubi9/ubi/
FROM registry.access.redhat.com/ubi9/ubi:9.7-1764794285

ARG TARGETARCH
LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="devfile-base-container"
LABEL name="devfile/base-developer-image"
LABEL version="ubi9"

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

## add epel repos so that p7zip p7zip-plugins stow can be found
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf install -y bat diffutils fd-find git git-lfs iproute jq less lsof man \
        nano procps p7zip p7zip-plugins perl-Digest-SHA net-tools \
        openssh-clients ripgrep rsync socat sudo time vim wget zip stow && \
    dnf update -y && \
    dnf clean all

## podman buildah skopeo
RUN dnf -y reinstall shadow-utils && \
    dnf -y install podman buildah skopeo fuse-overlayfs && \
    dnf clean all

# Download and install gh-cli depending on the architecture.
# See release page for details https://github.com/cli/cli/releases/tag/v2.83.2
RUN \
    TEMP_DIR="$(mktemp -d)" && cd "${TEMP_DIR}" && \
    GH_VERSION="2.83.2" && \
    case "$TARGETARCH" in \
        amd64) GH_ARCH="linux_amd64" ;; \
        arm64) GH_ARCH="linux_arm64" ;; \
        ppc64le) GH_ARCH="linux_ppc64le" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 0 ;; \
    esac && \
    GH_TGZ="gh_${GH_VERSION}_${GH_ARCH}.tar.gz" && \
    GH_TGZ_URL="https://github.com/cli/cli/releases/download/v${GH_VERSION}/${GH_TGZ}" && \
    echo "Downloading ${GH_TGZ_URL}..." && \
    if curl -fsSL "${GH_TGZ_URL}" -o "${GH_TGZ}"; then \
        if file "${GH_TGZ}" | grep -q 'gzip compressed'; then \
            tar -zxv --no-same-owner -f "${GH_TGZ}" && \
            mv "gh_${GH_VERSION}_${GH_ARCH}"/bin/gh /usr/local/bin/ && \
            mv "gh_${GH_VERSION}_${GH_ARCH}"/share/man/man1/* /usr/local/share/man/man1; \
        else \
            echo "Downloaded gh archive invalid — skipping."; \
        fi; \
    else \
        echo "gh binary not found for ${TARGETARCH}, skipping installation."; \
    fi && \
    cd - && rm -rf "${TEMP_DIR}"

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
RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; \
    touch /var/lib/shared/overlay-images/images.lock; \
    touch /var/lib/shared/overlay-layers/layers.lock

# Add kubedock
# See release page for details https://github.com/joyrex2001/kubedock/releases/tag/0.19.0
ENV KUBEDOCK_VERSION=0.19.0
ENV KUBECONFIG=/home/user/.kube/config
RUN set -e; \
    case "$TARGETARCH" in \
        ppc64le) \
            echo "Skipping kubedock installation for ppc64le as binary not available"; \
            exit 0 ;; \
        amd64) \
            KUBEDOCK_ARCH="linux_amd64" ;; \
        arm64) \
            KUBEDOCK_ARCH="linux_arm64" ;; \
        *) \
            echo "Unsupported architecture for kubedock: $TARGETARCH"; \
            exit 0 ;; \
    esac; \
    KUBEDOCK_TGZ="kubedock_${KUBEDOCK_VERSION}_${KUBEDOCK_ARCH}.tar.gz"; \
    KUBEDOCK_URL="https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/${KUBEDOCK_TGZ}"; \
    echo "Downloading ${KUBEDOCK_URL} ..."; \
    if curl -fsSL "${KUBEDOCK_URL}" -o /tmp/kubedock.tar.gz; then \
        if file /tmp/kubedock.tar.gz | grep -q 'gzip compressed'; then \
            tar -C /usr/local/bin -xzf /tmp/kubedock.tar.gz --no-same-owner; \
            chmod 0755 /usr/local/bin/kubedock; \
            echo "kubedock installed successfully."; \
        else \
            echo "Downloaded kubedock file invalid — skipping extraction."; \
        fi; \
    else \
        echo "kubedock binary not found for ${TARGETARCH}, skipping installation."; \
    fi; \
    rm -f /tmp/kubedock.tar.gz
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
