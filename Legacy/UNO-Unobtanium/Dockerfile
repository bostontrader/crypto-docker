# Build the unobtanium executables from the source code dated 2018-02, located at https://github.com/unobtanium-official/Unobtanium/commit/316146b04faaa690f5f092b5c4f071307bf33cf7

# If we try to build this using ubuntu:18.04 we get errors related to libsec256.
# Some clues: autogen for 16.04 says "bitcoin-config.h" is unchanged, whereas 18.04 does not.  configure for 18.04 also includes:
# configure.ac:15: installing 'build-aux/config.guess'
# configure.ac:15: installing 'build-aux/config.sub'
# configure.ac:25: installing 'build-aux/install-sh'
# whereas 16.04 does not

FROM ubuntu:16.04

ENV SOURCE_ORIGIN https://github.com/unobtanium-official/Unobtanium
ENV COMMIT 316146b04faaa690f5f092b5c4f071307bf33cf7
ENV SOURCE_LOCAL_ROOT /Unobtanium

# 1. We need to do this first in order to see any packages at all
RUN apt-get update \

    # 2. Install the basic foundation of build tools.
    && apt-get install -y --no-install-recommends \
       autoconf \
       automake \
       autotools-dev \
       bsdmainutils \
       build-essential \
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

    # 4. Decide which wallet format to use.  If you have an old wallet that you need to support then you probably want to use v4.8 of the db. 

    # 4.1 Use v4.8

    # This is a dependency of add-apt-repository.
    && apt-get install  -y --no-install-recommends software-properties-common \

    # We need this because we want to get v4.8 of the wallet db
    && add-apt-repository ppa:bitcoin/bitcoin \

    # And now we need to update this again
    && apt-get update \

    # Now get v4.8 of the wallet db
    && apt-get install  -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \

    # 5. Decide which QT to use.  v4 or v5.

    # 5.1 QT v4
    && apt-get install -y --no-install-recommends \
       libqt4-dev libprotobuf-dev protobuf-compiler \

    # 5.2 QT v5.  
    # This doesn't work.  Produces:
    #  "Compile your code with -fPIC (-fPIE is not enough).", despite using:
    # --disable-shared --with-pic CXXFLAGS="-fPIC" CPPFLAGS="-fPIC"
    #RUN apt-get install -y --no-install-recommends \
    #    libprotobuf-dev \
    #    libqt5core5a \
    #    libqt5dbus5 \
    #    libqt5gui5 \
    #    protobuf-compiler \
    #    qttools5-dev \
    #    qttools5-dev-tools \


    # 6. Install these packages in order to view the QT GUI using an external VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.  We need the DEBIAN_FRONTEND bit to avoid some UI interaction during install.
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       x11vnc \
       xvfb \

    # 7. Clone the source code.
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    && git clone $SOURCE_ORIGIN \
       
    && cd $SOURCE_LOCAL_ROOT \

    # We happen to know that this particular commit works.
    && git checkout $COMMIT \

    && ./autogen.sh \

    # && ./configure --without-miniupnpc --disable-shared --with-pic CXXFLAGS="-fPIC" CPPFLAGS="-fPIC"
    && ./configure --without-miniupnpc > /configure_autotools.log \

    # Fix this error.  See https://bitcointalk.org/index.php?topic=1312757.0
    && sed -i 's/<const CScriptID&>/<CScriptID>/g' src/rpcrawtransaction.cpp \

    && make > make_autotools.log \

    && strip src/unobtaniumd \
    && strip src/unobtanium-tx \
    && strip src/unobtanium-cli \
    && strip src/test/test_bitcoin \
    && strip src/qt/unobtanium-qt \
    && strip src/qt/test/test_unobtanium-qt \

    && make install > make_install_autotools.log \

    # 8. Establish a datadir.
    && mkdir /.unobtanium \

    # 9. Now delete as much stuff as we can find to shrink the image.  Unfortunately, this is easier said than done.  When we delete _any_ of these packages, which packages do we still depend upon get removed? Also, how much do the development packages _really_ bloat the image size?

    && cd / \
    && rm -rf $SOURCE_LOCAL_ROOT \

    # 9.1 Don't need the development tools anymore.
    && apt-get purge -y --auto-remove \
       autoconf \
       automake \
       autotools-dev \
       bsdmainutils \
       build-essential \
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

    # 9.3 Don't need git any more.
    && apt-get purge -y --auto-remove \
        git \

    && rm -rf /var/lib/apt/lists/*

