# Build bgoldd, bitcoin-qt, and their other friends from the source code date October 2018, located at:

FROM ubuntu:18.04

ENV SOURCE_ORIGIN https://github.com/BTCGPU/BTCGPU
ENV COMMIT e14dde4b7cff40b642504a107b5e4d53d895f767
ENV SOURCE_LOCAL_ROOT /BTCGPU

RUN apt-get update \

    # 1. Install the basic foundation of build tools.
    && apt-get install -y --no-install-recommends \
       automake \
       autotools-dev \
       bsdmainutils \
       build-essential \ 
       libevent-dev \
       libssl-dev \
       libtool \
       pkg-config \

    # 2. We don't need all of the boost libraries, only selectively install a handful of them
    && apt-get install -y --no-install-recommends \
       libboost-chrono-dev \
       libboost-filesystem-dev \
       libboost-program-options-dev \
       libboost-system-dev \
       libboost-test-dev \
       libboost-thread-dev \

    # 3. Let's build this with QT5
    && apt-get install -y --no-install-recommends \
       libprotobuf-dev \
       libqt5core5a \
       libqt5dbus5 \
       libqt5gui5 \
       protobuf-compiler \
       qttools5-dev \
       qttools5-dev-tools \

    # 4. Install these packages in order to view the QT GUI using an external VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.  We need the DEBIAN_FRONTEND bit to avoid some UI interaction during install.
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       x11vnc \
       xvfb \

    # 5. Use a modern version of the Berkeley DB instead of 4.8.
    && apt-get install -y --no-install-recommends libdb-dev libdb++-dev \

    # 6. We need the libsodium crypto library.  The ordinary apt-get install doesn't work for this.  Unfortunately, attempting to verify the integrity of the source code is easier said than done.  I leave this as an exercise for the reader.
    && apt-get install -y --no-install-recommends wget gpg ca-certificates \

    && mkdir /libsodium \
    && cd /libsodium \
    && wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz \

    # You might be able to verify using either of these two signatures.
    # Minisig has libsodium as a dependency.
    && wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz.minisig \
    && wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz.sig \

    # This won't work because you don't have a public key.  It's not in any keyserver that I know of.  You can find the key at https://libsodium.gitbook.io/doc/installation and copy and paste it somewhere and then use gpg --import key.txt if you like, but it's ultimately self-signed anyway.
    # && gpg --verify libsodium-1.0.16.tar.gz.sig \

    && tar -xvf libsodium-1.0.16.tar.gz \
    && cd libsodium-1.0.16 \
    && ./configure \
    && make \
    && make check \
    && make install \

    # 7. Clone the source code.  We can either clone the entire thing and checkout a specific commit, or we can clone one specific commit.  We will eventually delete the source code so this has no effect on the size of the image.  However, sometimes github and/or the connection to, is real slow so it's much faster to just grab one specific commit.

    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    # 7A.  Full clone.
    # && git clone $SOURCE_ORIGIN \
    # && cd $SOURCE_LOCAL_ROOT

    # We happen to know that this particular commit works.
    # && git checkout 69fce7 \

    # - or -

    # 7B.  Get one specific commit.
    && mkdir $SOURCE_LOCAL_ROOT \
    && cd $SOURCE_LOCAL_ROOT \
    && git init \
    && git remote add origin $SOURCE_ORIGIN \
    && git fetch --depth 1 origin $COMMIT \
    && git checkout FETCH_HEAD \


    # 8. Now build it!
    && cd $SOURCE_LOCAL_ROOT \
    && ./autogen.sh \

    # Recall that by default we require the v4.8 version of the db.  We will use a more modern version instead.
    && ./configure  --with-incompatible-bdb \

    && make \

    && strip src/bgoldd \
    && strip src/bgold-cli \
    && strip src/bitcoin-tx  \
    && strip src/bench/bench_bitcoin \
    && strip src/qt/bitcoin-qt \
    && strip src/qt/test/test_bitcoin-qt \
    && strip src/test/test_bitcoin \

    && make install \

    # 9. Now delete as much stuff as we can find to shrink the image.  Unfortunately, this is easier said than done.  When we delete _any_ of these packages, which packages do we still depend upon get removed? Also, how much do the development packages _really_ bloat the image size?

    && cd / \
    && rm -rf $SOURCE_LOCAL_ROOT \

    ## 9.1 Don't need the development tools anymore.
    && apt-get purge -y --auto-remove \  
       automake \
       autotools-dev \ 
       bsdmainutils \
       build-essential \ 
       # Don't delete this else... error while loading shared libraries: libevent_pthreads-2.1.so.6: cannot open shared object file: No such file or directory
       # libevent-dev \
       libssl-dev \
       libtool \
       pkg-config \

    # 9.2 Can we prune any of this? Do we care?
    && apt-get purge -y --auto-remove \ 
       # libboost-chrono-dev \
       # libboost-filesystem-dev \
       # libboost-program-options-dev \
       # libboost-system-dev \
       libboost-test-dev \
       # libboost-thread-dev \

    # 9.3 Can we prune any of this?
    && apt-get purge -y --auto-remove \ 
       libprotobuf-dev \
       # libqt5core5a \
       # libqt5dbus5 \
       # libqt5gui5 \

       # Keep.Otherwise error while loading shared libraries: libprotobuf.so.10:
       # protobuf-compiler \

       # qttools5-dev \
       # Keep.Otherwise error while loading shared libraries: libQt5Widgets.so.5
       # qttools5-dev-tools \

    # 9.4 Don't need git any more.
    && apt-get purge -y --auto-remove \
       git \

    && rm -rf /var/lib/apt/lists/*
