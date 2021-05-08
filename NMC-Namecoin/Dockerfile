FROM ubuntu:20.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build namecoind and namecoin-cli from this commit dated 2021-May that is known to work.
# No QT UI, testing, or anything else.
ENV SOURCE_ORIGIN https://github.com/namecoin/namecoin-core
ENV COMMIT 1b05173
ENV SOURCE_LOCAL_ROOT namecoin-core

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
    libtool \
    pkg-config

# 5. Berzerkly db 5.3.  Don't waste our time with the 4.8 version.
RUN apt install -y --no-install-recommends libdb-dev libdb++-dev

# 6. We don't need all of the boost libraries (v1.71), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-filesystem-dev \
    libboost-system-dev \
    libboost-test-dev

# 7. Build
RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb # need this for db 5.3
RUN make
RUN src/test/test_namecoin

RUN strip src/namecoind && cp src/namecoind /usr/local/bin
RUN strip src/namecoin-cli && cp src/namecoin-cli /usr/local/bin

# Now we have everything built, but we have a lot of extra bloat because of the build tools.
# Stage this and grab only what we need.
FROM ubuntu:20.04

# 1. namecoind and namecoin-cli
COPY --from=0 /usr/local/bin /usr/local/bin

# 2. Get a few required shared libraries.  Use ldd /usr/local/bin/namecoind to 
# find out which shared libraries it uses.  Some of them are already here, but the following must be copied from stage 0.
# A few of the libraries also need symlinks.

COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.71.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libdb_cxx-5.3.so /usr/lib/x86_64-linux-gnu

COPY --from=0 /usr/lib/x86_64-linux-gnu/libevent_pthreads-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/
RUN ln -s /usr/lib/x86_64-linux-gnu/libevent_pthreads-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/libevent_pthreads-2.1.so.7

COPY --from=0 /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/
RUN ln -s /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7 

# 3. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID nmcuser
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID nmcuser
USER nmcuser

