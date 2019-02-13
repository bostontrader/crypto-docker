# Build the Feathercoin daemon, cli, and QT5 GUI from the code at
# https://github.com/FeatherCoin/Feathercoin/commit/6621a975b556175964e132654baea448e7702479

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. We need to do this first in order to see any packages at all
RUN apt-get update && \


# 2. Install these basic packages because the build will fail without them.
apt-get install -y --no-install-recommends \

# needed by autogen
autoconf \
automake \

# always have to have this
build-essential \

# need this to clone the source code
ca-certificates \

# need this to build libxing
cmake \

# hexdump
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


# 4. Install QT5
&& apt-get install -y --no-install-recommends \

libqrencode-dev \
libqt5core5a \
libqt5gui5 \
qttools5-dev-tools \
protobuf-compiler \
qtbase5-dev


# 5. We apparently cannot disable libzxing so we must bite the bullet and just install the damn thing.
RUN echo "deb http://download.opensuse.org/repositories/home:/wellenreiter01/xUbuntu_16.04 ./" > /etc/apt/sources.list.d/opensuse.list
COPY zxingRelease.key /
RUN apt-key add /zxingRelease.key && \
apt-get update && \ 
apt-get install libzxing && \
apt-get clean


# 6. Clone the source code.
RUN git clone https://github.com/FeatherCoin/Feathercoin                                          
WORKDIR /Feathercoin

# I happen to know that this particular commit works.
RUN git checkout 6621a9


# 7. configure, make, install.
RUN ./autogen.sh && \

# This "works" but do I really need all this?
./configure --disable-shared --with-pic CXXFLAGS="-fPIC" CPPFLAGS="-fPIC" && \

make V=1 && \

# Apparently by default, building FTC does _not_ result in large binaries so it's not worth any effort to strip them of debug symbols.
# && strip src/feathercoind && strip src/feathercoin-cli && strip src/qt/feathercoin-qt \
make install && make clean


