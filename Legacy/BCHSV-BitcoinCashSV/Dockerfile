# Build the bitcoin-sv command-line executables from source code dated 2018-10, located at https://github.com/bitcoin-sv/bitcoin-sv/commit/d9b12a23dbf0d2afc5f488fa077d762b302ba873
# Notice that bitcoin-sv doesn't have any GUI.

# Forked from BCH block 556767 2017-11-15

FROM ubuntu:16.04

ENV SOURCE_ORIGIN https://github.com/bitcoin-sv/bitcoin-sv
ENV COMMIT d9b12a23dbf0d2afc5f488fa077d762b302ba873
ENV SOURCE_LOCAL_ROOT /bitcoin-sv

# 1. We need to do this first in order to see any packages at all
RUN apt-get update \

    # 2. Clone the source code.
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    && git clone $SOURCE_ORIGIN \
    && cd $SOURCE_LOCAL_ROOT \

    # We happen to know that this particular commit works.
    && git checkout $COMMIT \

    # 3. Need these to get past ./autogen.sh
    && apt install -y --no-install-recommends \
       autoconf \
       automake \
       libtool \

    # 4. In order to get past ./configure we need many dependencies installed because ./configure looks for them.
    # 4.1 Of course we need g++
    # 4.2 We need some of the boost libraries
    # 4.3 We need berkely db (libdb), unless --disable-wallet
    # 4.4 We need dh-autoreconf because it has hexdump, which is needed for testing.
    # 4.5 We need openssl but if we just install that, configure still complains.  use libssl-dev instead.
    # 4.6 Also need pkg-config and libevent-dev lest configure complain
    && apt install -y --no-install-recommends \
       dh-autoreconf \
       g++ \
       libboost-chrono-dev \
       libboost-filesystem-dev \
       libboost-program-options-dev \
       libboost-system-dev \
       libboost-test-dev \
       libboost-thread-dev \
       libdb-dev libdb++-dev \
       libevent-dev \
       libssl-dev \
       pkg-config \

    # 4. Build it!  The default CXXFLAGS have been modified to remove -g (produce debugging symbols) in order to reduce the image size.
    && ./autogen.sh \
    && ./configure CXXFLAGS='-O2 -Wall -Wextra -Wvla -Wshadow' \
    && make V=1 && make install \

    # 5. Establish a datadir.
    && mkdir /.bitcoin \

    # 6. Now delete as much stuff as we can find to shrink the image.

    && cd / \
    && rm -rf $SOURCE_LOCAL_ROOT \

    # 6.1 Don't need the development tools anymore.
    && apt-get purge -y --auto-remove \
      autoconf \
      automake \
      libtool \

      dh-autoreconf \
      g++ \
      # libboost-chrono-dev \
      # libboost-filesystem-dev \
      # libboost-program-options-dev \
      # libboost-system-dev \
      libboost-test-dev \
      # libboost-thread-dev \
      # libdb-dev libdb++-dev \
      # libevent-dev \
      # libssl-dev \
      pkg-config \

    # 6.2 Don't need git any more.
    && apt-get purge -y --auto-remove \
        git \

    && rm -rf /var/lib/apt/lists/*

