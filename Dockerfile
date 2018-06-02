# Run TraceLogJournalWriterTests in a container

FROM ubuntu:xenial
MAINTAINER "Tony Stone <http://github.com/tonystone>"

# Install Dependencies
RUN apt-get update && apt-get install -y  \
        clang-3.8 \
        lldb-3.8 \
        libcurl3 \
        libicu-dev \
        libxml2 \
        libpython2.7-dev \
        libsystemd-dev \
        systemd \
        curl \
        git

# Fix clang links on Ubuntu 16.04
RUN ln -s /usr/bin/clang-3.8 /usr/bin/clang && ln -s /usr/bin/clang++-3.8 /usr/bin/clang++

# Install Swift
RUN curl -O https://swift.org/builds/swift-4.1-release/ubuntu1604/swift-4.1-RELEASE/swift-4.1-RELEASE-ubuntu16.04.tar.gz \
    && curl -O https://swift.org/builds/swift-4.1-release/ubuntu1604/swift-4.1-RELEASE/swift-4.1-RELEASE-ubuntu16.04.tar.gz \
    && tar xzvf swift-4.1-RELEASE-ubuntu16.04.tar.gz

ENV PATH /swift-4.1-RELEASE-ubuntu16.04/usr/bin:$PATH
ENV C_INCLUDE_PATH /swift-4.1-RELEASE-ubuntu16.04/usr/lib/swift/clang/include/
ENV CPLUS_INCLUDE_PATH $C_INCLUDE_PATH
