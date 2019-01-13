# Build the litecoin executables from the code at https://github.com/litecoin-project/litecoin/commit/69fce744115a7d2889ff1b90e89582b83de405ad (2018-Sep)

FROM ubuntu:16.04

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

    # 4. Install these packages in order to view the QT GUI using an external VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       x11vnc \
       xvfb \

    # 5. Use a modern version of the Berkeley DB instead of 4.8.
    && apt-get install -y --no-install-recommends libdb-dev libdb++-dev \

    # 6 . Clone the source code.  We can either clone the entire thing and checkout a specific commit, or we can clone one specific commit.  We will eventually delete the source code so this has no effect on the size of the image.  However, sometimes github is real slow so it's much faster to just grab one specific commit.
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    # 6A.  Full clone.
    #&& git clone https://github.com/litecoin-project/litecoin \
    #&& cd /litecoin \

    # We happen to know that this particular commit works.
    #&& git checkout 69fce7 \

    # 6B.  Get one specific commit.
    && mkdir litecoin \
    && cd litecoin \
    && git init \
    && git remote add origin https://github.com/litecoin-project/litecoin \
    && git fetch --depth 1 origin 69fce744115a7d2889ff1b90e89582b83de405ad \
    && git checkout FETCH_HEAD \

    # 7. Now build it!
    && ./autogen.sh \

    # Recall that by default we require the v4.8 version of the db.  We will use a more modern version (5.3) instead.
    && ./configure --without-miniupnpc --with-incompatible-bdb \

    && make \

    && strip src/bench/bench_litecoin \
    && strip src/litecoind \
    && strip src/litecoin-cli \
    && strip src/litecoin-tx \
    && strip src/qt/litecoin-qt \
    && strip src/qt/test/test_litecoin-qt \
    && strip src/test/test_litecoin \

    && make install \


# 8. Now delete as much stuff as we can find to shrink the image.  Unfortunately, this is easier said than done.  When we delete _any_ of these packages, which packages do we still depend upon get removed?Also, how much do the development packages _really_ bloat the image size?

    && cd / \
    && rm -rf /litecoin \

    ## 8.1 Don't need the development tools anymore.
    && apt-get purge -y --auto-remove \  
       automake \
       autotools-dev \ 
       bsdmainutils \
       build-essential \ 
       # Keep. Otherwise error while loading shared libraries: libevent_pthreads-2.1.so.6: cannot open shared object file: No such file or directory  
       # libevent-dev \
       libssl-dev \
       libtool \
       pkg-config \

    # 8.2 Can we trim this?
    && apt-get purge -y --auto-remove \ 
       # libboost-chrono-dev \
       # libboost-filesystem-dev \
       # libboost-program-options-dev \
       # libboost-system-dev \
       libboost-test-dev \
       # libboost-thread-dev \

    # 8.3 Can we trim this?
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

    # 8.4 Don't need git any more.
    && apt-get purge -y --auto-remove \
       git \

    && rm -rf /var/lib/apt/lists/*

