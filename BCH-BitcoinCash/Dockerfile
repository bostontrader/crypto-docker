# Build the bitcoin-abc executables from source code dated 2018-11-21, located at https://github.com/Bitcoin-ABC/bitcoin-abc/commit/d1d091ba73f574ae5eb189fe7655c67bf5d338cf

# Forked from BTC block 478558 2017-08-01

# Node won't sync after late upgrade (May 15th hardfork)
# https://github.com/Bitcoin-ABC/bitcoin-abc/issues/209

# BitcoinABC stuck at block #530361 after upgrade 0.16.2 to 0.17.1
# https://github.com/Bitcoin-ABC/bitcoin-abc/issues/213

FROM ubuntu:16.04

ENV SOURCE_ORIGIN https://github.com/Bitcoin-ABC/bitcoin-abc
ENV COMMIT d1d091ba73f574ae5eb189fe7655c67bf5d338cf
ENV SOURCE_LOCAL_ROOT /bitcoin-abc

# 1. We need to do this first in order to see any packages at all
RUN apt-get update \

    # 2. Install the basic foundation of build tools.
    && apt-get install -y --no-install-recommends \
       automake \
       autotools-dev \
       build-essential \
       dh-autoreconf \
       libevent-dev \
       libssl-dev \
       libtool \ 
       pkg-config \

    # 3. We don't need all of the boost libraries, only selectively install a handful of them
    && apt-get install -y --no-install-recommends \
       libboost-chrono-dev \
       libboost-filesystem-dev \
       libboost-program-options-dev \
       libboost-system-dev \
       libboost-test-dev \
       libboost-thread-dev \

    # 4. Use a modern version (v 5.3) of the Berkeley DB instead of 4.8.
    && apt-get install -y --no-install-recommends libdb-dev libdb++-dev \

    # 5. Let's use QT5
    && apt-get install -y --no-install-recommends \
       libprotobuf-dev \
       libqt5core5a \
       libqt5gui5 \
       protobuf-compiler \
       qttools5-dev-tools \
       qtbase5-dev \

    # 6. Install these packages in order to view the QT GUI using an external VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.  We need the DEBIAN_FRONTEND bit to avoid some UI interaction during install.
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       x11vnc \
       xvfb\

    # 7. Clone the source code.
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    && git clone $SOURCE_ORIGIN \
    && cd $SOURCE_LOCAL_ROOT \

    # We happen to know that this particular commit works.
    && git checkout $COMMIT \

    # 8. Build it!  The default CXXFLAGS have been modified to remove -g (produce debugging symbols) in order to reduce the image size.
    && ./autogen.sh \
    && ./configure --with-incompatible-bdb CXXFLAGS='-O2 -Wall -Wextra -Wvla -Wshadow' \
    && make V=1 && make install \

    # 9. Establish a datadir.
    && mkdir /.bitcoin \

    # 10. Now delete as much stuff as we can find to shrink the image.  Unfortunately, this is easier said than done.  When we delete _any_ of these packages, which packages do we still depend upon get removed? Also, how much do the development packages _really_ bloat the image size?

    && cd / \
    && rm -rf $SOURCE_LOCAL_ROOT \

    # 10.1 Don't need the development tools anymore.
    && apt-get purge -y --auto-remove \
       autoconf \
       automake \
       autotools-dev \
       bsdmainutils \
       build-essential \
       libssl-dev \
       libtool \
       pkg-config \

    # 10.2 Can we prune any of this? Do we care?
    && apt-get purge -y --auto-remove \ 
    # libboost-chrono-dev \
    # libboost-filesystem-dev \
    # libboost-program-options-dev \
    # libboost-system-dev \
      libboost-test-dev \
    # libboost-thread-dev \

    # 10.3 Don't need git any more.
    && apt-get purge -y --auto-remove \
        git \

    && rm -rf /var/lib/apt/lists/*

