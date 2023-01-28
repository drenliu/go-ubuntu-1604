FROM ubuntu:16.04

RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
RUN apt-get update -y -q &&apt-get upgrade -y -q


RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -q wget openjdk-8-jdk libasound2-dev alsa-utils curl build-essential ca-certificates libusb-1.0 libusb-1.0-0-dev pkg-config git unzip gcc openssh-client

RUN curl -s https://storage.googleapis.com/golang/go1.17.4.linux-amd64.tar.gz| tar -v -C /usr/local -xz


ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 7.3.3

RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Adding gradle user and group" \
    && groupadd --system --gid 1009 gradle \
    && useradd --system --gid gradle --uid 1009 --shell /bin/bash --create-home gradle \
    && mkdir /home/gradle/.gradle \
    && chown --recursive gradle:gradle /home/gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln -s /home/gradle/.gradle /root/.gradle
