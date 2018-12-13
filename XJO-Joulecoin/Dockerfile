# Build the XJO-Joulecoin executables from source code dated 2018-09, located at https://github.com/joulecoin/joulecoin/commit/867336c403a55e57d8dda00a26d84f030ccdf9c5

FROM ubuntu:16.04

ENV SOURCE_ORIGIN https://github.com/joulecoin/joulecoin
ENV COMMIT 867336c403a55e57d8dda00a26d84f030ccdf9c5
ENV SOURCE_LOCAL_ROOT /joulecoin

# Build and cleanup according to whether or not --build-arg debug=true is set or not when building this.  The test actually looks for the existence, or not, of debug.  It doesn't care about the actual value.
ARG debug

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

    # 3. Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
    && apt-get install -y --no-install-recommends \
       x11vnc \
       xvfb \

    # 4. We don't need all of the boost libraries, only selectively install a handful of them
    && apt-get install -y --no-install-recommends \
       libboost-chrono-dev \
       libboost-filesystem-dev \
       libboost-program-options-dev \
       libboost-system-dev \
       libboost-test-dev \
       libboost-thread-dev \

    # 5. Use a modern version (v 5.3) of the Berkeley DB instead of 4.8.
    && apt-get install -y --no-install-recommends libdb-dev libdb++-dev \

    # 6. Install QT4
    && apt-get install -y --no-install-recommends \
       libqt4-dev \
       libprotobuf-dev \
       protobuf-compiler \

    # For some reason this doesn't work.  Get's the ole "Compile your code with -fPIC (-fPIE is not enough)." error
    # 6. Install QT5
    # && apt-get install -y --no-install-recommends \
    #   libprotobuf-dev \
    #   libqt5core5a \
    #   libqt5dbus5 \
    #   libqt5gui5 \
    #   qttools5-dev \
    #   qttools5-dev-tools \
    #   protobuf-compiler \
    #   qtbase5-dev \

    # 7. Need these for autogen.sh
    && apt-get install -y --no-install-recommends \
       autoconf \
       automake \
       libtool \

    # 8. Need these for configure
    # dh-autoreconf gives us hexdump, and hexdump is needed for testing
    && apt-get install -y --no-install-recommends \
       dh-autoreconf \
       g++ \
       libssl-dev \
       pkg-config \

    # 9. Establish a datadir.
    && mkdir /.joulecoin \

    # 10. Build and cleanup according to whether or not --build-arg debug=true is set or not.  This test actually looks for the existence, or not, of debug.  It doesn't care about the actual value.

    && ./autogen.sh \

    && if [ "x$debug" = "x" ] ; then \

        echo Building for production \

        # 10.1 Build for production.
        # No debug symbols, decent optimization, no warnings, a few safety features.
        && ./configure --with-incompatible-bdb CXXFLAGS='-O2 -fstack-protector-all -fPIE' \

        # Default build.
        # Debug symbols + optimization, lots of warnings, a few safety features.
        # && ./configure --with-incompatible-bdb

        && make V=1 && make install \

        && cd / \
        && rm -rf $SOURCE_LOCAL_ROOT ; \
    else \

        echo Building for debug \
        
        # 10.2 Turn on debug symbols, no warnings, no optimization, no other safety features.
        && ./configure --with-incompatible-bdb CXXFLAGS='-g' \

        && make V=1 && make install \

        # 10.2.1 We want some other software to enable us to use gdb inside the container, from the host.
        && apt-get install -y --no-install-recommends \
           gdb \
           python3 \
           python3-pip \
           python3-setuptools \

        && pip3 install gdbgui ; \
    fi \


    # 11. Now delete some stuff to reduce container size.

    # 11.1 Don't need the development tools anymore.
    && apt-get purge -y --auto-remove \
       autoconf \
       automake \
       dh-autoreconf \
       g++ \
       libssl-dev \
       libtool \
       pkg-config \

    # 11.2 Can we prune any of this? Do we care?
    && apt-get purge -y --auto-remove \ 
       # libboost-chrono-dev \
       # libboost-filesystem-dev \
       # libboost-program-options-dev \
       # libboost-system-dev \
       libboost-test-dev \
       # libboost-thread-dev \

    # 11.3 Don't need git any more.
    && apt-get purge -y --auto-remove \
        git \

    && rm -rf /var/lib/apt/lists/*

