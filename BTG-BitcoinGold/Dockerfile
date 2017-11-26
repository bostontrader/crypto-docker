# Build bgoldd, bgold-cli, bitcoin-tx, and bitcoin-qt from the code at
# https://github.com/bostontrader/bitcoin-gold/commit/1d3d85a74d1d16d1b12890c15fbb9f85cf8d597c

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. We need to do this first in order to see any packages at all
RUN apt-get update && \


# 2. Install these basic packages because the docs say so
apt-get install -y --no-install-recommends \

build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils  \
libboost-all-dev \

# need this to clone the source code
ca-certificates \

# you know why we need git!
git \

# need this to install libsodium later
wget \

# Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
x11vnc \
xvfb \
&& apt-get clean


# 3. Use v4.8 of the db.
RUN apt-get install -y --no-install-recommends \

# Needed by add-apt-repository.
software-properties-common && \

# We need this because we want to get v4.8 of the wallet db
add-apt-repository ppa:bitcoin/bitcoin && \

# 3.3 And now we need to update this again
apt-get update && \

# Now get v4.8 of the wallet db
apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \

&& apt-get clean


# 4. We need libsodium.  The ordinary apt-get install doesn't work for this.
RUN wget http://de.archive.ubuntu.com/ubuntu/pool/universe/libs/libsodium/libsodium-dev_1.0.13-1_amd64.deb \
&& wget http://de.archive.ubuntu.com/ubuntu/pool/universe/libs/libsodium/libsodium18_1.0.13-1_amd64.deb \
&& dpkg -i libsodium*deb

# 5. Install QT4
# && apt-get install -y --no-install-recommends \

# libqt4-dev \
# libprotobuf-dev \
# protobuf-compiler \


# 5. Install QT5
RUN apt-get install -y --no-install-recommends \
libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler \
&& apt-get clean


# 6. Clone the source code.

RUN git clone https://github.com/bostontrader/bitcoin-gold                     
WORKDIR /bitcoin-gold

# I happen to know that this particular commit works.
RUN git checkout 1d3d85


# 7. Make and strip the debug symbols
RUN ./autogen.sh && ./configure && make \
&& strip src/bgoldd && strip src/bgold-cli && strip src/bitcoin-tx && strip src/qt/bitcoin-qt \
&& make install && make clean


# Wrap it up
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

