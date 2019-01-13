# Build devcoind and devcoin-qt from the source code dated October 2018, located at:

FROM ubuntu:16.04

ENV SOURCE_ORIGIN https://github.com/devcoin/core
ENV COMMIT 453b245d82940653011b384b1710a24b71c20a5a
ENV SOURCE_LOCAL_ROOT /core

# 1. We need to do this first in order to see any packages at all
RUN apt-get update \

    # 2. Install the basic foundation of build tools.
    && apt-get install -y --no-install-recommends \
       build-essential \
       libssl-dev \
       libtool \
       openssl \
       pkg-config \

    # 3. We don't need all of the boost libraries, only selectively install a handful of them
    && apt-get install -y --no-install-recommends \
       libboost-chrono-dev \
       libboost-filesystem-dev \
       libboost-program-options-dev \
       libboost-system-dev \
       libboost-test-dev \
       libboost-thread-dev \

    # 4. Let's build this with QT4
    && apt-get install -y --no-install-recommends libqt4-dev qt4-qmake \

    # 5. Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
    && apt-get install -y --no-install-recommends x11vnc xvfb \

    # 6. Need curl to download the receiver files.
    && apt-get -y install curl \

    # 7. Use v4.8 of the db.
    # 7.1 This is a dependency of add-apt-repository.
    && apt-get install -y --no-install-recommends software-properties-common \

    # 7.2 We need this because we want to get v4.8 of the wallet db
    && add-apt-repository ppa:bitcoin/bitcoin \

    # 7.3 And now we need to update this again
    && apt-get update \

    # 7.4 Now get v4.8 of the wallet db
    && apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \

    # 8. Now clone the source code.
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    && git clone $SOURCE_ORIGIN \
    && cd $SOURCE_LOCAL_ROOT \

    # We happen to know that this particular commit works.
    && git checkout $COMMIT \

    # 9. Now build devcoind
    && cd $SOURCE_LOCAL_ROOT/src \
    #RUN chmod 755 leveldb/build_detect_platform
    && make -f makefile.unix USE_UPNP=- \

    # At this point, devcoind should be useable.
    # ./devcoind -printtoconsole -rpcuser=user -rpcpassword=password
    # Next, build the GUI

    # 10. Now build the QT4 GUI
    && cd $SOURCE_LOCAL_ROOT \
    && qmake USE_UPNP=- \
    && make \

    # 11. There doesn't appear to be any 'make install' feature, so let's do it ourselves...
    && strip $SOURCE_LOCAL_ROOT/devcoin-qt \
    && strip $SOURCE_LOCAL_ROOT/src/devcoind \
    && cp $SOURCE_LOCAL_ROOT/devcoin-qt /usr/local/bin \
    && cp $SOURCE_LOCAL_ROOT/src/devcoind /usr/local/bin \

    # 12. Establish a datadir.
    && mkdir /.devcoin \

    # 13. Now delete as much stuff as we can find to shrink the image.  Unfortunately, this is easier said than done.  When we delete _any_ of these packages, which packages do we still depend upon get removed? Also, how much do the development packages _really_ bloat the image size?

    && cd / \
    && rm -rf $SOURCE_LOCAL_ROOT \

    ## 13.1 Don't need the development tools anymore.
    #&& apt-get purge -y --auto-remove \
    #   build-essential \
    #   libssl-dev \
    #   libtool \
    # Don't remove this. x11vnc depends on this and will be removed with this.
    # openssl \
    #   pkg-config

    # 13.2 Can we prune any of this? Do we care?
    #&& apt-get purge -y --auto-remove \ 
    # libboost-chrono-dev \
    # libboost-filesystem-dev \
    # libboost-program-options-dev \
    # libboost-system-dev \
    # libboost-test-dev \
    # libboost-thread-dev \

    # 13.3 Don't need git any more.
    && apt-get purge -y --auto-remove \
       git \

    && rm -rf /var/lib/apt/lists/*

