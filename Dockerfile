# Run TraceLogAdaptiveWriterTests in a container

FROM solita/ubuntu-systemd:xenial
LABEL maintainer="Tony Stone <http://github.com/tonystone>"

# Install Dependencies
RUN apt-get update && apt-get install -y  \
        clang-3.8 \
        lldb-3.8 \
        libcurl3 \
        libicu-dev \
        libxml2 \
        libpython2.7-dev \
        libsystemd-dev \
        curl \
        git

# Fix clang links on Ubuntu 16.04
RUN ln -s /usr/bin/clang-3.8 /usr/bin/clang && ln -s /usr/bin/clang++-3.8 /usr/bin/clang++

ENV WORKDIR /workdir
RUN mkdir ${WORKDIR}
WORKDIR ${WORKDIR}

# Install Swift
RUN curl -O https://swift.org/builds/swift-5.1-release/ubuntu1604/swift-5.1-RELEASE/swift-5.1-RELEASE-ubuntu16.04.tar.gz \
    && tar xzvf swift-5.1-RELEASE-ubuntu16.04.tar.gz

ENV PATH ${WORKDIR}/swift-5.1-RELEASE-ubuntu16.04/usr/bin:$PATH
ENV C_INCLUDE_PATH ${WORKDIR}/swift-5.1-RELEASE-ubuntu16.04/usr/lib/swift/clang/include/
ENV CPLUS_INCLUDE_PATH $C_INCLUDE_PATH

COPY Package.swift ${WORKDIR}/Package.swift
COPY Sources ${WORKDIR}/Sources
COPY Tests ${WORKDIR}/Tests
