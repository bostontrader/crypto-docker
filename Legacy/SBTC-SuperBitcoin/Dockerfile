# Build sbtcd, sbtc-cli, bitcoin-qt (this is correct), and sbtc-tx from the code at
# https://github.com/superbitcoin/SuperBitcoin/commit/560d4d697a7fccfb589fff1e1f294e4bfceac790

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. We need to do this first in order to see any packages at all
RUN apt-get update && \


# 2. Install these basic packages because the build will fail without them.
apt-get install -y --no-install-recommends \

# needed by autogen
automake \
autotools-dev \

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


# 4. Install QT5
&& apt-get install -y --no-install-recommends \

libqt5core5a \
libqt5gui5 \
qttools5-dev-tools \
protobuf-compiler \
qtbase5-dev \

&& apt-get clean


# 5. Clone the source code.

RUN git clone https://github.com/superbitcoin/SuperBitcoin                                     
WORKDIR /SuperBitcoin

# I happen to know that this particular commit works.
RUN git checkout 560d4d


# 6. Make and strip the debug symbols
RUN ./autogen.sh && ./configure && make

#&& strip src/bitcoindiamondd && strip src/bitcoindiamond-cli && strip src/bitcoindiamond-tx && strip src/qt/bitcoindiamond-qt \
#&& make install && make clean

# Wrap it up
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

