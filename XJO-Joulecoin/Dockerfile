# Any version > ubuntu 16.04 gives us trouble with openssl.  A few clues...
# Latest OpenSSL 1.1.0e incorrectly detected as LibreSSL during build
# configure: error: Detected LibreSSL: This is NOT supported, and may break consensus compatibility!
# --with-libressl will pass configure but will fail during make.

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build joulecoind and joulecoin-cli from this commit dated 2021-Apr that is known to work.
# No QT UI, testing, or anything else.
ENV SOURCE_ORIGIN https://github.com/joulecoin/joulecoin
ENV COMMIT 640f1f2
ENV SOURCE_LOCAL_ROOT joulecoin

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. We need git to git the source code.
RUN apt install -y --no-install-recommends ca-certificates git 

# 3. Clone the source code.
RUN git clone --progress $SOURCE_ORIGIN
WORKDIR $SOURCE_LOCAL_ROOT
RUN git checkout $COMMIT

# 4. Berzerkly db 5.3.  Don't waste our time with the 4.8 version.
RUN apt install -y --no-install-recommends libdb-dev libdb++-dev

# 5. Install the basic foundation of build tools.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    dh-autoreconf \
#    libevent-dev \
    libssl-dev \
    libtool \
    pkg-config



# 6. We don't need all of the boost libraries (v1.58), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-filesystem-dev \
    libboost-test-dev \
    libboost-program-options-dev \
    libboost-thread-dev


# 7. Build
RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb
RUN make

# The tests do not pass
#RUN src/test/test_joulecoin

RUN strip src/joulecoind && cp src/joulecoind /usr/local/bin
RUN strip src/joulecoin-cli && cp src/joulecoin-cli /usr/local/bin

# Now we have everything built, but we have a lot of extra bloat because of the build tools.
# Stage this and grab only what we need.
FROM ubuntu:16.04

# 1. joulecoind and joulecoin-cli
COPY --from=0 /usr/local/bin /usr/local/bin

# 2. Get a few required shared libraries.  Use ldd /usr/local/bin/joulecoind to 
# find out which shared libraries it uses.  Some of them are already here, but the following must be copied from stage 0.

COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_system.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.58.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libdb_cxx-5.3.so /usr/lib/x86_64-linux-gnu

COPY --from=0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu
COPY --from=0 /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu

# 3. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID xjouser
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID xjouser
USER xjouser

