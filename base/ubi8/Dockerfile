FROM registry.access.redhat.com/ubi8/ubi

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

RUN dnf update -y && \
    dnf install -y bash curl diffutils git iproute jq less lsof man nano net-tools time vim wget zip && \
    dnf clean all

RUN dnf config-manager \
        --add-repo https://dl.fedoraproject.org/pub/archive//fedora/linux/releases/29/Everything/x86_64/os/media.repo && \
    dnf config-manager --save \
        --setopt=*.baseurl=https://dl.fedoraproject.org/pub/archive//fedora/linux/releases/29/Everything/x86_64/os/ \
        InstallMedia && \
    dnf update -y --nobest && \
    dnf install -y --nobest emacs fish htop ripgrep zsh && \
    dnf clean all

# not found:
    # ssl-cert 

CMD /bin/bash
