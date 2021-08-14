FROM ubuntu:20.04 AS compile

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  clang \
  make \
  file \
  curl \
  ca-certificates \
  git \
  texinfo \
  xz-utils \
  wget \
  pkg-config

COPY freebsd-toolchain.sh /tmp/

# The FreeBSD version to target for cross-compilation.
ARG FBSD_VERSION=11.4
ARG TARGET_ARCH=x86_64

RUN /tmp/freebsd-toolchain.sh ${TARGET_ARCH} ${FBSD_VERSION}


FROM ubuntu:20.04 AS deploy

RUN apt-get update && apt-get install -y --no-install-recommends \
  clang \
  make \
  file \
  curl \
  ca-certificates \
  wget \
  openjdk-8-jdk

COPY --from=compile \
  /usr/local/ \
  /usr/local/

WORKDIR /workdir

