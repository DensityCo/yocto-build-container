# Build environment for LineageOS

FROM ubuntu:16.04
MAINTAINER Michael Stucki <michael@stucki.io>

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
      gawk \
      git-core \
      diffstat \
      unzip \
      texinfo 
      gcc-multilib \
      chrpath \
      socat \
      libsdl1.2-dev \
      xterm \
      sed \
      cvs \
      subversion \
      coreutils \
      texi2html \
      docbook-utils \
      python-pysqlite2 \
      help2man \
      make \
      gcc \
      g++ \
      desktop-file-utils \
      libgl1-mesa-dev \
      libglu1-mesa-dev \
      mercurial \
      autoconf \
      automake \
      groff \
      curl \
      lzop \
      asciidoc \
      u-boot-tools \
      ant \
      phablet-tools \
      bison \
      build-essential \
      curl \
      flex \
      git \
      gnupg \
      gperf \
      libesd0-dev \
      liblz4-tool \
      libncurses5-dev \
      libsdl1.2-dev \
      libwxgtk3.0-dev \
      libxml2 \
      libxml2-utils \
      lzop \
      maven \
      openjdk-8-jdk \
      pngcrush \
      schedtool \
      squashfs-tools \
      xsltproc \
      zip \
      zlib1g-dev \
# For 64-bit systems
      g++-multilib \
      lib32ncurses5-dev \
      lib32readline6-dev \
      lib32z1-dev \
# Install additional packages which are useful for building Android
      bash-completion \
      bc \
      bsdmainutils \
      ccache \
      file \
      imagemagick \
      nano \
      rsync \
      screen \
      sudo \
      tig \
      wget \
 && rm -rf /var/lib/apt/lists/*

ARG hostuid=1000
ARG hostgid=1000

RUN \
    groupadd --gid $hostgid --force build && \
    useradd --gid $hostgid --uid $hostuid --non-unique build && \
    rsync -a /etc/skel/ /home/build/

RUN mkdir /home/build/bin
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /home/build/bin/repo
RUN chmod a+x /home/build/bin/repo

# Add sudo permission
RUN echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build

ADD startup.sh /home/build/startup.sh
RUN chmod a+x /home/build/startup.sh

# Fix ownership
RUN chown -R build:build /home/build

# Set global variables
ADD android-env-vars.sh /etc/android-env-vars.sh
RUN echo "source /etc/android-env-vars.sh" >> /etc/bash.bashrc

VOLUME /home/build/yocto
VOLUME /srv/ccache

CMD /home/build/startup.sh

USER build
WORKDIR /home/build/yocto
