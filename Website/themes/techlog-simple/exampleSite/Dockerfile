FROM ubuntu:18.04@sha256:de774a3145f7ca4f0bd144c7d4ffb2931e06634f11529653b23eba85aef8e378
LABEL maintainer="docker@mazgi.com"

ENV DOCKERBUILD_HUGO_VERSION="0.57.0"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
  # Install packages
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y --no-install-recommends ca-certificates openssh-client curl git \
  # Download and install Hugo
  && curl -LO "https://github.com/gohugoio/hugo/releases/download/v${DOCKERBUILD_HUGO_VERSION}/hugo_${DOCKERBUILD_HUGO_VERSION}_Linux-64bit.deb" \
  && dpkg -i hugo_${DOCKERBUILD_HUGO_VERSION}_Linux-64bit.deb \
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
