# syntax=docker/dockerfile:1.3-labs

# updateBaseImages.sh can't operate on SHA-based tags as they're not date-based or semver-sequential, and therefore cannot be ordered
FROM quay.io/devfile/base-developer-image:ubi9-latest

ARG TARGETARCH
LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="devfile-universal-container"
LABEL name="devfile/universal-developer-image"
LABEL version="ubi9"

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="devfile universal developer image"
LABEL description="Image with developers tools. Languages SDK and runtimes included."
LABEL io.k8s.display-name="devfile-developer-universal"
LABEL io.openshift.expose-services=""

USER 0

# $PROFILE_EXT contains all additions made to the bash environment
ENV PROFILE_EXT=/etc/profile.d/udi_environment.sh
RUN touch ${PROFILE_EXT} && chown 10001 ${PROFILE_EXT}

USER 10001

# We install everything to /home/tooling/ as /home/user/ may get overriden, see github.com/eclipse/che/issues/22412
ENV HOME=/home/tooling

# Java
RUN if [ "$TARGETARCH" = "ppc64le" ]; then \
      echo "Skipping Java installation: tem Java not available for ppc64le"; \
    else \
      curl -fsSL "https://get.sdkman.io/?rcupdate=false" | bash \
      && bash -c ". /home/tooling/.sdkman/bin/sdkman-init.sh \
             && sed -i 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' /home/tooling/.sdkman/etc/config \
             && sed -i 's/sdkman_auto_env=false/sdkman_auto_env=true/g' /home/tooling/.sdkman/etc/config \
             && sdk install java 8.0.432-tem \
             && sdk install java 11.0.25-tem \
             && sdk install java 17.0.13-tem \
             && sdk install java 21.0.5-tem \
             && sdk install java 23.1.5.r21-mandrel \
             && sdk default java 17.0.13-tem \
             && sdk install gradle \
             && sdk install maven \
             && sdk install jbang \
             && sdk flush archives \
             && sdk flush temp"; \
      chgrp -R 0 /home/tooling && chmod -R g=u /home/tooling; \
    fi
# sdk home java <version>
ENV JAVA_HOME_8=/home/tooling/.sdkman/candidates/java/8.0.432-tem
ENV JAVA_HOME_11=/home/tooling/.sdkman/candidates/java/11.0.25-tem
ENV JAVA_HOME_17=/home/tooling/.sdkman/candidates/java/17.0.13-tem
ENV JAVA_HOME_21=/home/tooling/.sdkman/candidates/java/21.0.5-tem

# Java-related environment variables are described and set by ${PROFILE_EXT}, which will be loaded by ~/.bashrc
# To make Java working for dash and other shells, it needs to initialize them in the Dockerfile.
ENV SDKMAN_CANDIDATES_API="https://api.sdkman.io/2"
ENV SDKMAN_CANDIDATES_DIR="/home/tooling/.sdkman/candidates"
ENV SDKMAN_DIR="/home/tooling/.sdkman"
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        export SDKMAN_PLATFORM="linuxarm64"; \
    else \
        export SDKMAN_PLATFORM="linuxx64"; \
    fi
ENV SDKMAN_PLATFORM=${SDKMAN_PLATFORM}
ENV SDKMAN_VERSION="5.18.2"

ENV GRADLE_HOME="/home/tooling/.sdkman/candidates/gradle/current"
ENV JAVA_HOME="/home/tooling/.sdkman/candidates/java/current"
ENV MAVEN_HOME="/home/tooling/.sdkman/candidates/maven/current"

ENV GRAALVM_HOME=/home/tooling/.sdkman/candidates/java/23.1.5.r21-mandrel

ENV PATH="/home/tooling/.krew/bin:$PATH"
ENV PATH="/home/tooling/.sdkman/candidates/maven/current/bin:$PATH"
ENV PATH="/home/tooling/.sdkman/candidates/java/current/bin:$PATH"
ENV PATH="/home/tooling/.sdkman/candidates/gradle/current/bin:$PATH"
ENV PATH="/home/tooling/.local/share/coursier/bin:$PATH"

# NodeJS
RUN mkdir -p /home/tooling/.nvm/
ENV NVM_DIR="/home/tooling/.nvm"
ENV NODEJS_20_VERSION=20.18.1
ENV NODEJS_18_VERSION=18.20.5
ENV NODEJS_DEFAULT_VERSION=${NODEJS_18_VERSION}
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE=/dev/null bash
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ${PROFILE_EXT} \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ${PROFILE_EXT}
RUN source /home/user/.bashrc && \
    nvm install v${NODEJS_20_VERSION} && \
    nvm install v${NODEJS_18_VERSION} && \
    nvm alias default v${NODEJS_DEFAULT_VERSION} && nvm use v${NODEJS_DEFAULT_VERSION} && \
    npm install --global yarn@v1.22.22 &&\
    chgrp -R 0 /home/tooling && chmod -R g=u /home/tooling
ENV PATH=$NVM_DIR/versions/node/v${NODEJS_DEFAULT_VERSION}/bin:$PATH
ENV NODEJS_HOME_20=$NVM_DIR/versions/node/v${NODEJS_20_VERSION}
ENV NODEJS_HOME_18=$NVM_DIR/versions/node/v${NODEJS_18_VERSION}

# kube
ENV KUBECONFIG=/home/user/.kube/config

USER 0

# Required packages for AWT
RUN dnf install -y libXext libXrender libXtst libXi

# Lombok
ENV LOMBOK_VERSION=1.18.18
RUN wget -O /usr/local/lib/lombok.jar https://projectlombok.org/downloads/lombok-${LOMBOK_VERSION}.jar

# Scala
RUN curl -fLo cs https://git.io/coursier-cli && \
    chmod +x cs && \
    mv cs /usr/local/bin/
RUN curl -fLo sbt https://raw.githubusercontent.com/dwijnand/sbt-extras/master/sbt && \
    chmod +x sbt && \
    mv sbt /usr/local/bin/
RUN curl -fLo mill https://raw.githubusercontent.com/lefou/millw/main/millw && \
    chmod +x mill && \
    mv mill /usr/local/bin/

# C/CPP
RUN dnf -y install llvm-toolset gcc gcc-c++ clang clang-libs clang-tools-extra gdb

# Go 1.22+    - installed to /usr/bin/go
# gopls 0.16.2+ - installed to /home/tooling/go/bin/gopls and /home/tooling/go/pkg/mod/
USER 0

ENV GOBIN=/home/tooling/go/bin
ENV PATH=$GOBIN:/usr/local/go/bin:$PATH

ARG TARGETARCH

RUN mkdir -p $GOBIN \
    && case "$TARGETARCH" in \
        amd64) GO_ARCH="amd64" ;; \
        arm64) GO_ARCH="arm64" ;; \
        ppc64le) GO_ARCH="ppc64le" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac \
    && GO_VERSION="1.22.5" \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm -rf /tmp/go.tar.gz \
    && go version \
    && GO111MODULE=on go install golang.org/x/tools/gopls@v0.16.2 \
    && chgrp -R 0 /home/tooling \
    && chmod -R g=u /home/tooling

# Python
RUN dnf -y install python3.11 python3.11-devel python3.11-setuptools python3.11-pip nss_wrapper

RUN cd /usr/bin \
    && if [ ! -L python ]; then ln -s python3.11 python; fi \
    && if [ ! -L pydoc ]; then ln -s pydoc3.11 pydoc; fi \
    && if [ ! -L python-config ]; then ln -s python3.11-config python-config; fi \
    && if [ ! -L pip ]; then ln -s pip-3.11 pip; fi

RUN pip install pylint yq

# PHP
ENV PHP_VERSION=8.2
RUN dnf -y module enable php:$PHP_VERSION && \
    dnf install -y --setopt=tsflags=nodocs php php-mysqlnd php-pgsql php-bcmath \
                php-gd php-intl php-json php-ldap php-mbstring php-pdo \
                php-pear php-zlib php-mysqli php-curl php-xml php-devel\
                php-process php-soap php-opcache php-fpm ca-certificates \
                php-gmp php-pecl-xdebug php-pecl-zip mod_ssl hostname && \
    wget https://getcomposer.org/installer -O /tmp/composer-installer.php && \
    php /tmp/composer-installer.php --filename=composer --install-dir=/usr/local/bin

ENV PHP_DEFAULT_INCLUDE_PATH=/usr/share/pear \
    PHP_SYSCONF_PATH=/etc \
    PHP_HTTPD_CONF_FILE=php.conf \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_MODULES_CONF_D_PATH=/etc/httpd/conf.modules.d \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/var/www \
    HTTPD_VAR_PATH=/var

# .NET
ENV DOTNET_RPM_VERSION=8.0
RUN dnf install -y dotnet-hostfxr-${DOTNET_RPM_VERSION} dotnet-runtime-${DOTNET_RPM_VERSION} dotnet-sdk-${DOTNET_RPM_VERSION}

# rust
ENV CARGO_HOME=/home/tooling/.cargo \
    RUSTUP_HOME=/home/tooling/.rustup \
    PATH=/home/tooling/.cargo/bin:${PATH}
RUN curl --proto '=https' --tlsv1.2 -sSfo rustup https://sh.rustup.rs && \
    chmod +x rustup && \
    mv rustup /usr/bin/ && \
    rustup -y --no-modify-path --profile minimal -c rust-src -c rust-analysis -c rls && \
    chgrp -R 0 /home/tooling && chmod -R g=u /home/tooling

# camel-k 
ARG TARGETARCH
ENV KAMEL_VERSION 2.2.0
RUN if [ "$TARGETARCH" != "ppc64le" ]; then \
    curl -sSLf https://github.com/apache/camel-k/releases/download/v${KAMEL_VERSION}/camel-k-client-${KAMEL_VERSION}-linux-${TARGETARCH}.tar.gz \
    | tar -C /usr/local/bin -xz --no-same-owner \
    && chmod +x /usr/local/bin/kamel; \
    else \
    echo "Skipping Camel K install for ppc64le — not supported"; \
    fi
# Config directories
RUN mkdir -p /home/tooling/.m2 && \
    mkdir -p /home/tooling/.gradle && \
    mkdir -p /home/tooling/.config/pip && \
    mkdir -p /home/tooling/.sbt/1.0 && \
    mkdir -p /home/tooling/.cargo && \
    mkdir -p /home/tooling/certs && \
    mkdir -p /home/tooling/.composer && \
    mkdir -p /home/tooling/.nuget && \
    chgrp -R 0 /home/tooling && chmod -R g=u /home/tooling

# Cloud

# oc client
ENV OC_VERSION=4.15

RUN case "$TARGETARCH" in \
        arm64)   ARCH_PATH="arm64" ;; \
        amd64)   ARCH_PATH="x86_64" ;; \
        ppc64le) ARCH_PATH="ppc64le" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    curl -L "https://mirror.openshift.com/pub/openshift-v4/${ARCH_PATH}/clients/ocp/stable-${OC_VERSION}/openshift-client-linux.tar.gz" \
    | tar -C /usr/local/bin -xz --no-same-owner && \
    chmod +x /usr/local/bin/oc

# OS Pipelines CLI (tkn)
ENV TKN_VERSION=1.14.0
RUN curl -L https://mirror.openshift.com/pub/openshift-v4/clients/pipelines/${TKN_VERSION}/tkn-linux-${TARGETARCH}.tar.gz | tar -C /usr/local/bin -xz --no-same-owner \
    && chmod +x /usr/local/bin/tkn /usr/local/bin/opc /usr/local/bin/tkn-pac

RUN echo 'alias docker=podman' >> ${PROFILE_EXT}

# Configure container engine
COPY --chown=0:0 containers.conf /etc/containers/containers.conf

##kubectl
ARG TARGETARCH
ENV KUBECTL_VERSION=1.30.1
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/kubectl

## shellcheck
RUN <<EOF
dnf install -y xz
set -euf -o pipefail

if [ "$TARGETARCH" = "ppc64le" ]; then
    echo "ShellCheck installation is skipped for ppc64le: unsupported architecture"
    exit 0
fi

TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"

SHELL_CHECK_VERSION="0.8.0"

if [ "$TARGETARCH" = "arm64" ]; then
    SHELL_CHECK_ARCH="aarch64"
else
    SHELL_CHECK_ARCH="x86_64"
fi

SHELL_CHECK_TGZ="shellcheck-v${SHELL_CHECK_VERSION}.linux.${SHELL_CHECK_ARCH}.tar.xz"
SHELL_CHECK_TGZ_URL="https://github.com/koalaman/shellcheck/releases/download/v${SHELL_CHECK_VERSION}/${SHELL_CHECK_TGZ}"

curl -sSLO "${SHELL_CHECK_TGZ_URL}"
tar -xv --no-same-owner -f "${SHELL_CHECK_TGZ}"
mv "${TEMP_DIR}"/shellcheck-v${SHELL_CHECK_VERSION}/shellcheck /bin/shellcheck

cd -
rm -rf "${TEMP_DIR}"
EOF

## krew
RUN <<EOF
set -euf -o pipefail
TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"
KREW_VERSION="0.4.5"
KREW_ARCH="linux_${TARGETARCH}"
KREW_TGZ="krew-${KREW_ARCH}.tar.gz"
KREW_TGZ_URL="https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/${KREW_TGZ}"
curl -sSLO "${KREW_TGZ_URL}"
curl -sSLO "${KREW_TGZ_URL}.sha256"

# File ${KREW_TGZ_URL}.sha256 has invalid format to be checked with sha256sum.
# It needs to create a valid one.
echo "$(cat ${KREW_TGZ}.sha256)  ${KREW_TGZ}" > "${KREW_TGZ}.sha256"

sha256sum -c "${KREW_TGZ}.sha256" 2>&1 | grep OK

tar -zxv --no-same-owner -f "${KREW_TGZ}"
./"krew-${KREW_ARCH}" install krew
echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ${PROFILE_EXT}
#export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export KREW_ROOT="/home/tooling/.krew"
export PATH="$KREW_ROOT/bin:$PATH"

# kubens and kubectx
kubectl krew install ns
kubectl krew install ctx
cd -
rm -rf "${TEMP_DIR}"
EOF

## helm
RUN <<EOF
set -euf -o pipefail
TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"
HELM_VERSION="3.14.3"
HELM_ARCH="linux-${TARGETARCH}"
HELM_TGZ="helm-v${HELM_VERSION}-${HELM_ARCH}.tar.gz"
HELM_TGZ_URL="https://get.helm.sh/${HELM_TGZ}"
curl -sSLO "${HELM_TGZ_URL}"
curl -sSLO "${HELM_TGZ_URL}.sha256sum"
sha256sum -c "${HELM_TGZ}.sha256sum" 2>&1 | grep OK
tar -zxv --no-same-owner -f "${HELM_TGZ}"
mv "${HELM_ARCH}"/helm /usr/local/bin/helm
cd -
rm -rf "${TEMP_DIR}"
EOF

## kustomize
RUN <<EOF
set -euf -o pipefail
TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"
KUSTOMIZE_VERSION="5.3.0"
KUSTOMIZE_ARCH="linux_${TARGETARCH}"
KUSTOMIZE_TGZ="kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCH}.tar.gz"
KUSTOMIZE_TGZ_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/${KUSTOMIZE_TGZ}"
KUSTOMIZE_CHEKSUMS_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/checksums.txt"
curl -sSLO "${KUSTOMIZE_TGZ_URL}"
curl -sSLO "${KUSTOMIZE_CHEKSUMS_URL}"
sha256sum --ignore-missing -c "checksums.txt" 2>&1 | grep OK
tar -zxv --no-same-owner -f "${KUSTOMIZE_TGZ}"
mv kustomize /usr/local/bin/
cd -
rm -rf "${TEMP_DIR}"
EOF

## tektoncd-cli
RUN <<'EOF'
set -euf -o pipefail

TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"

TKN_VERSION="0.20.0"

case "$TARGETARCH" in
    amd64)
        TKN_ARCH="Linux_x86_64"
        ;;
    arm64)
        TKN_ARCH="Linux_arm64"
        ;;
    ppc64le)
        TKN_ARCH="Linux_ppc64le"
        ;;
    *)
        echo "Unsupported architecture: $TARGETARCH"
        exit 1
        ;;
esac

TKN_TGZ="tkn_${TKN_VERSION}_${TKN_ARCH}.tar.gz"
TKN_TGZ_URL="https://github.com/tektoncd/cli/releases/download/v${TKN_VERSION}/${TKN_TGZ}"
TKN_CHECKSUMS_URL="https://github.com/tektoncd/cli/releases/download/v${TKN_VERSION}/checksums.txt"

curl -sSLO "${TKN_TGZ_URL}"
curl -sSLO "${TKN_CHECKSUMS_URL}"
sha256sum --ignore-missing -c checksums.txt | grep OK

tar -zx --no-same-owner -f "${TKN_TGZ}"
mv tkn /usr/local/bin/tkn

cd /
rm -rf "${TEMP_DIR}"
EOF

## knative-cli
RUN <<EOF
set -euf -o pipefail
TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"
KN_VERSION="1.13.0"
KN_ARCH="linux-${TARGETARCH}"
KN_BIN="kn-${KN_ARCH}"
KN_BIN_URL="https://github.com/knative/client/releases/download/knative-v${KN_VERSION}/${KN_BIN}"
KN_CHEKSUMS_URL="https://github.com/knative/client/releases/download/knative-v${KN_VERSION}/checksums.txt"
curl -sSLO "${KN_BIN_URL}"
curl -sSLO "${KN_CHEKSUMS_URL}"
sha256sum --ignore-missing -c "checksums.txt" 2>&1 | grep OK
mv "${KN_BIN}" kn
chmod +x kn
mv kn /usr/local/bin
cd -
rm -rf "${TEMP_DIR}"
EOF

## terraform-cli
ARG TARGETARCH
RUN if [ "$TARGETARCH" != "ppc64le" ]; then \
  set -euf -o pipefail; \
  TEMP_DIR="$(mktemp -d)"; \
  cd "${TEMP_DIR}"; \
  TF_VERSION="1.7.5"; \
  TF_ARCH="linux_${TARGETARCH}"; \
  TF_ZIP="terraform_${TF_VERSION}_${TF_ARCH}.zip"; \
  TF_ZIP_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_ZIP}"; \
  TF_CHECKSUMS_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_SHA256SUMS"; \
  curl -sSLO "${TF_ZIP_URL}"; \
  curl -sSLO "${TF_CHECKSUMS_URL}"; \
  sha256sum --ignore-missing -c "terraform_${TF_VERSION}_SHA256SUMS" 2>&1 | grep OK; \
  unzip ${TF_ZIP}; \
  chmod +x terraform; \
  mv terraform /usr/local/bin; \
  cd -; \
  rm -rf "${TEMP_DIR}"; \
else \
  echo "Skipping Terraform install for architecture: ${TARGETARCH}"; \
fi

## skaffold
RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-${TARGETARCH} && \
    install skaffold /usr/local/bin/

# e2fsprogs setup
# Since e2fsprogs-static package has removed RHEL 8 distribution, it is not possible to install from the repository
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/considerations_in_adopting_rhel_8/index#removed-packages_changes-to-packages
RUN <<EOF
set -euf -o pipefail

if [ "$TARGETARCH" = "ppc64le" ]; then
    echo "Skipping e2fsprogs build for ppc64le"
    exit 0
fi

TEMP_DIR="$(mktemp -d)"
cd "${TEMP_DIR}"

E2FSPROGS_VERSION="1.46.5"
E2FSPROGS_TGZ="e2fsprogs-${E2FSPROGS_VERSION}.tar.gz"
E2FSPROGS_TGZ_URL="https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${E2FSPROGS_VERSION}/${E2FSPROGS_TGZ}"
E2FSPROGS_CHEKSUMS_URL="https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${E2FSPROGS_VERSION}/sha256sums.asc"

curl -sSLO "${E2FSPROGS_TGZ_URL}"
curl -sSLO "${E2FSPROGS_CHEKSUMS_URL}"
sha256sum --ignore-missing -c "sha256sums.asc" 2>&1 | grep OK

tar -zxv --no-same-owner -f "${E2FSPROGS_TGZ}"
cd "e2fsprogs-${E2FSPROGS_VERSION}"

mkdir build
cd build

../configure --prefix=/usr --with-root-prefix="" --enable-elf-shlibs --disable-evms
make
make install
make install-libs

cd -
rm -rf "${TEMP_DIR}"
EOF

# Bash completions
RUN dnf -y install bash-completion \
    && dnf clean all \
    && rm -rf /var/cache/yum

RUN <<EOF
oc completion bash > /usr/share/bash-completion/completions/oc
tkn completion bash > /usr/share/bash-completion/completions/tkn
kubectl completion bash > /usr/share/bash-completion/completions/kubectl
cat ${NVM_DIR}/bash_completion > /usr/share/bash-completion/completions/nvm
EOF

## Add sdkman's init script launcher to the end of ${PROFILE_EXT} since we are not adding it on sdkman install
## NOTE: all modifications to ${PROFILE_EXT} must happen BEFORE this step in order for sdkman to function correctly
RUN echo 'export SDKMAN_DIR="/home/tooling/.sdkman"' >> ${PROFILE_EXT}
RUN echo '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"' >> ${PROFILE_EXT}


# Create symbolic links from /home/tooling/ -> /home/user/
RUN stow . -t /home/user/ -d /home/tooling/ --no-folding

# Set permissions on /etc/passwd, /etc/group, /etc/pki and /home to allow arbitrary users to write
RUN chgrp -R 0 /home && chmod -R g=u /etc/passwd /etc/group /home /etc/pki

# cleanup dnf cache
RUN dnf -y clean all --enablerepo='*'

USER 10001

ENV HOME=/home/user
