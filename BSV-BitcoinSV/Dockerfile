FROM ubuntu:20.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build bitcoind and bitcoin-cli from this commit dated 2021-May that is known to work.
# The build is tested but the final image does not contain the QT UI, testing, or anything else.
ENV SOURCE_ORIGIN https://github.com/bitcoin-sv/bitcoin-sv
ENV COMMIT da5be64
ENV SOURCE_LOCAL_ROOT bitcoin-sv

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
    build-essential \
    dh-autoreconf \
    libevent-dev \
    libssl-dev \
    pkg-config \
    python3


# 6. We don't need all of the boost libraries (v1.71), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-thread-dev \
    libboost-test-dev \
    libboost-system-dev



# 7. Build
RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb
RUN make
#RUN make check # tests don't pass :-(

RUN strip src/bitcoind && cp src/bitcoind /usr/local/bin
RUN strip src/bitcoin-cli && cp src/bitcoin-cli /usr/local/bin

# Now we have everything built, but we now have > 6GB of extra bloat because of the build tools.
# Stage this and grab only what we need.
FROM ubuntu:20.04

# 1. bitcoind and bitcoin-cli
COPY --from=0 /usr/local/bin /usr/local/bin

# 2. Get a few required shared libraries.  Use ldd /usr/local/bin/bitcoind to 
# find out which shared libraries it uses.  Some of them are already here, but the following must be copied from stage 0.

COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_chrono.so.1.71.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.71.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.71.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.71.0 /usr/lib/x86_64-linux-gnu/
COPY --from=0 /usr/lib/x86_64-linux-gnu/libdb_cxx-5.3.so /usr/lib/x86_64-linux-gnu

COPY --from=0 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/

COPY --from=0 /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/
RUN ln -s /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/libevent-2.1.so.7 

COPY --from=0 /usr/lib/x86_64-linux-gnu/libevent_pthreads-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/
RUN ln -s /usr/lib/x86_64-linux-gnu/libevent_pthreads-2.1.so.7.0.0 /usr/lib/x86_64-linux-gnu/libevent_pthreads-2.1.so.7

# 3. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID bsvgroup
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID bsvuser
USER bsvuser

