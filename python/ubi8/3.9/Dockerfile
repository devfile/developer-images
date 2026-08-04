# syntax=docker/dockerfile:1.3-labs
ARG IMAGE_NAME=ghcr.io/redhat-na-ssa/udi-cuda:11.8.0-cudnn8-devel-ubi8
FROM ${IMAGE_NAME}

# cherry picked from below
# https://github.com/devfile/developer-images/blob/main/base/ubi8/Dockerfile

# labels for container catalog
LABEL summary="Python 3.9 devfile base developer image"
LABEL description="Python 3.9 image with base developers tools"
LABEL io.k8s.display-name="python-3.9-devfile-developer-base"
LABEL io.openshift.expose-services=""

USER 0

# install: python
RUN yum install -y python39 && \
    alternatives --set python /usr/bin/python3.9 && \
    ln -sf /usr/bin/pip3.9 /usr/bin/pip && \
    yum clean all && \
    rm -rf /var/cache/yum/*

USER 1001
