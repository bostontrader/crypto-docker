# Build terracoind, terracoin-cli, terracoin-qt, and terracoin-tx from the code at
# https://github.com/terracoin/terracoin/commit/c4844c5b1cbef099594c65eb8548e9810d6ef778

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. We need to do this first in order to see any packages at all
RUN apt-get update && \


# 2. Install these basic packages because the build will fail without them.
apt-get install -y --no-install-recommends \

# needed by autogen
autotools-dev \
autoconf \

# always have to have this
build-essential \

# need this to clone the source code
ca-certificates \

# hexdump needed for tests
dh-autoreconf \

# you know why we need git!
git \

# boost 1.58
libboost-chrono-dev \
libboost-filesystem-dev \
libboost-program-options-dev \
libboost-system-dev \
libboost-test-dev \
libboost-thread-dev \

libevent-dev \

libssl-dev \

# need it
libtool \ 

# config wants this
pkg-config \

# Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
x11vnc \
xvfb \


# 3. Use v4.8 of the db.
&& apt-get install -y --no-install-recommends \

# Needed by add-apt-repository.
software-properties-common && \

# We need this because we want to get v4.8 of the wallet db
add-apt-repository ppa:bitcoin/bitcoin && \

# 3.3 And now we need to update this again
apt-get update && \

# Now get v4.8 of the wallet db
apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \


# 4. Install QT4
# && apt-get install -y --no-install-recommends \

# libqt4-dev \
# libprotobuf-dev \
# protobuf-compiler \

# This doesn't work some problem re compling with fPIE vs fPIC
# 4. Install QT5
&& apt-get install -y --no-install-recommends \

 libprotobuf-dev \
 libqt5core5a \
 libqt5dbus5 \
 libqt5gui5 \
 qttools5-dev \
 qttools5-dev-tools \
 protobuf-compiler \
 qtbase5-dev \

&& apt-get clean


# 5. Clone the source code.

RUN git clone https://github.com/terracoin/terracoin                        
WORKDIR /terracoin

# I happen to know that this particular commit works.
RUN git checkout c4844c


# 6. Make and strip the debug symbols
RUN ./autogen.sh && ./configure && make \
&& strip src/terracoind && strip src/terracoin-cli && strip src/terracoin-tx && strip src/qt/terracoin-qt \
&& make install && make clean

# Wrap it up
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

