# 18.04 is the most recent LTS version that provides db4.8
FROM ubuntu:18.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build devcoind only from this commit dated 2020-Dec that is known to work.
# No devcoin-cli, QT UI, testing, or anything else.
ENV SOURCE_ORIGIN https://github.com/devcoin/core
ENV COMMIT fb0d7d0063ef612bb0e43006551c823a901d3fb6
ENV SOURCE_LOCAL_ROOT core

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. We need git to git the source code.
RUN apt install -y --no-install-recommends ca-certificates git 

# 3. Install the basic foundation of build tools.
RUN apt install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libtool \
    openssl \
    pkg-config

# 4. We don't need all of the boost libraries (v1.65), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev

# 5. Need these to download the receiver files.
RUN apt install -y --no-install-recommends curl libz-dev

# 6. Do all this so that we can get granddad's version 4.8 of db

# We need this for add-apt-repository.  Part of this is tzdata and it wants interactive input.  Suppress that 
# and accept UTC as the default TZ
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y --no-install-recommends software-properties-common

# We need this because we want to get v4.8 of the wallet db
RUN add-apt-repository ppa:bitcoin/bitcoin

# And now we need to update this again because of the prior added repository
RUN apt update

# Finally... now get v4.8 of db
RUN apt install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev

# 7. Now clone the source code.
RUN git clone $SOURCE_ORIGIN
WORKDIR $SOURCE_LOCAL_ROOT
RUN git checkout $COMMIT

# 8. Now build devcoind only.  There's no other devcoin-cli or any of that.
WORKDIR src
RUN make -f makefile.unix USE_UPNP=- 
RUN strip devcoind

FROM ubuntu:18.04

COPY --from=0 /core/src/devcoind /usr/local/bin

# At this point devcoind still needs access to shared libraries.  Use ldd devcoind to find out which 
# shared libraries it uses.  Some of them are already here, but the following must be copied from stage 0.

# 1. Copy the boost shared libraries.  These also need symlinks to work.
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.65.1 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.65.1 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_system.so.1.65.1 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.65.1 /usr/lib/x86_64-linux-gnu/

RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.65.1 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.65.1 /usr/lib/x86_64-linux-gnu/libboost_program_options.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_system.so.1.65.1 /usr/lib/x86_64-linux-gnu/libboost_system.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.65.1 /usr/lib/x86_64-linux-gnu/libboost_thread.so

# 2. Copy these others that don't need symlinks.
COPY --from=0 /usr/lib/libdb_cxx-4.8.so /usr/lib/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/

# 3. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID dvcuser
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID dvcuser
USER dvcuser

