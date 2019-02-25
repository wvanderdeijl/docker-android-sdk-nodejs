
# wvanderdeijl/docker-android-sdk-nodejs

# see https://github.com/nodejs/docker-node
# see https://hub.docker.com/_/node/
FROM node:10

# get openjdk on older debian version used by node container
# see https://xmoexdev.com/wordpress/installing-openjdk-8-debian-jessie/

RUN echo deb http://http.debian.net/debian jessie-backports main >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y -t jessie-backports openjdk-8-jdk && \
  apt-get clean

# now add Android SDK
# see https://github.com/mindrunner/docker-android-sdk
# see https://hub.docker.com/r/runmymind/docker-android-sdk

# FROM ubuntu:18.04

# LABEL de.mindrunner.android-docker.flavour="ubuntu-standalone"

ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK /opt/android-sdk-linux

ENV DEBIAN_FRONTEND noninteractive

# Install required tools
# Dependencies to execute Android builds

RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  make \
  libc6:i386 \
  libgcc1:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  zlib1g:i386 \
  openjdk-8-jdk \
  wget \
  unzip \
  vim \
  openssh-client \
  locales \
  && apt-get clean

RUN  rm -rf /var/lib/apt/lists/* && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8

# RUN groupadd android && useradd -d /opt/android-sdk-linux -g android -u 1000 android
RUN groupadd android && useradd -d /opt/android-sdk-linux -g android -u 1001 android

# COPY tools /opt/tools
COPY docker-android-sdk/tools /opt/tools

# COPY licenses /opt/licenses
COPY docker-android-sdk/licenses /opt/licenses

WORKDIR /opt/android-sdk-linux

RUN /opt/tools/entrypoint.sh built-in

CMD /opt/tools/entrypoint.sh built-in


# add gradle
ENV GRADLE_VERSION 5.2.1
RUN mkdir /opt/gradle && \
  curl https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -L -o /tmp/gradle.zip && \
  unzip -d /opt/gradle /tmp/gradle.zip && \
  rm -f /tmp/gradle.zip
ENV PATH="/opt/gradle/gradle-${GRADLE_VERSION}/bin:${PATH}"
