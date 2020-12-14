FROM ubuntu:16.04
# Try 18.04 and you get:
# bignum.h: In function 'bool operator>=(const CBigNum&, const CBigNum&)':
# bignum.h:551:83: error: cannot convert 'const CBigNum*' to 'const BIGNUM* {aka const bignum_st*}' for argument '1' to 'int BN_cmp(const # BIGNUM*, const BIGNUM*)'
# inline bool operator>=(const CBigNum& a, const CBigNum& b) { return (BN_cmp(&a, &b) >= 0); }

LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build bbqcoind only from this commit dated 2014-Feb that is known to work.
# No bbqcoin-cli, QT UI, testing, or anything else.
ENV SOURCE_ORIGIN https://github.com/overware/BBQCoin
ENV COMMIT b1e803d09e4be4c50d43b6fa115c0cabc09d4976
ENV SOURCE_LOCAL_ROOT BBQCoin

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. We need git to git the source code.
RUN apt install -y --no-install-recommends ca-certificates git 

# 3. Install the basic foundation of build tools.
RUN apt install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libtool \
    pkg-config

# 4. We don't need all of the boost libraries (v1.58), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-thread-dev

# 5. Do all this so that we can get granddad's version 4.8 of db

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

# 6. Need this for upnp
RUN apt install -y --no-install-recommends libminiupnpc-dev

# 7. Now clone the source code.
RUN git clone $SOURCE_ORIGIN
WORKDIR $SOURCE_LOCAL_ROOT
RUN git checkout $COMMIT

# 8. Now build bbqcoind only.  There's no other bbqcoin-cli or any of that.
WORKDIR src
RUN make -f makefile.unix
RUN strip bbqcoind

FROM ubuntu:18.04

COPY --from=0 /BBQCoin/src/bbqcoind /usr/local/bin

# At this point bbqcoind still needs access to shared libraries.  Use ldd bbqcoind to find out which 
# shared libraries it uses.  Some of them are already here, but the following must be copied from stage 0.

# 1. Copy the boost shared libraries.  These also need symlinks to work.
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_system.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.58.0 /usr/lib/x86_64-linux-gnu/

RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.58.0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.58.0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_system.so.1.58.0 /usr/lib/x86_64-linux-gnu/libboost_system.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.58.0 /usr/lib/x86_64-linux-gnu/libboost_thread.so

# 2. Copy these others that don't need symlinks.
COPY --from=0 /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu/
COPY --from=0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/libdb_cxx-4.8.so /usr/lib/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libminiupnpc.so.10 /usr/lib/x86_64-linux-gnu/

# 3. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID bcquser
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID bcquser
USER bcquser

