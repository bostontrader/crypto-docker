# Build the Feathercoin daemon, cli, and QT5 GUI from the code at
# https://github.com/FeatherCoin/Feathercoin/commit/6621a975b556175964e132654baea448e7702479

# This is old code and if we try Ubuntu > 16.04 we run into issues with compatibility with OpenSSl 1.1.
# error: cannot convert 'const CBigNum*' to 'const BIGNUM*
# Please see https://github.com/FeatherCoin/Feathercoin/issues/177 for some insight into this
# and https://github.com/firoorg/firo/pull/111 for a rather tedious example fix to the source code.
FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build feathercoind and feathercoin-cli from this commit dated 2021-Apr that is known to work.
# No QT UI, testing, or anything else.
ENV SOURCE_ORIGIN https://github.com/freicoin/freicoin
ENV COMMIT eec192
ENV SOURCE_LOCAL_ROOT freicoin

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. We need git to git the source code.
RUN apt install -y --no-install-recommends ca-certificates git 

# 3. Clone the source code.
RUN git clone --progress $SOURCE_ORIGIN
WORKDIR $SOURCE_LOCAL_ROOT
RUN git checkout $COMMIT

# 4. Install the basic foundation of build tools.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    dh-autoreconf \
    libevent-dev \
    libssl-dev \
    libtool \
    pkg-config

# 5. Berzerkly db 5.3.  Don't waste our time with the 4.8 version.
RUN apt install -y --no-install-recommends libdb-dev libdb++-dev

# 6. We don't need all of the boost libraries (v1.71), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libboost-thread-dev


# 7. Build
RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb # need this for db 5.3
RUN make
RUN src/test/test_freicoin

RUN strip src/freicoind && cp src/freicoind /usr/local/bin
RUN strip src/freicoin-cli && cp src/freicoin-cli /usr/local/bin

# Now we have everything built, but we have a lot of extra bloat because of the build tools.
# Stage this and grab only what we need.
FROM ubuntu:16.04

# 1. freicoind and freicoin-cli
COPY --from=0 /usr/local/bin /usr/local/bin

# 2. Get a few required shared libraries.  Use ldd /usr/local/bin/feathercoind to 
# find out which shared libraries it uses.  Some of them are already here, but the following must be copied from stage 0.
# A few of the libraries also need symlinks.

COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_system.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libdb_cxx-5.3.so /usr/lib/x86_64-linux-gnu

COPY --from=0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/
COPY --from=0 /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu

# 3. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID frcuser
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID frcuser
USER frcuser

