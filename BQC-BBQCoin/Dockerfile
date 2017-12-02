# Build bbqcoind and bbqcoin-qt from the code at
# https://github.com/overware/BBQCoin/commit/28d5d95573afa1d90911dd2ba3b44450017d305b

FROM ubuntu:14.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. Install the minimal requirements to clone the source code.
RUN apt-get update \

&& apt-get install -y --no-install-recommends \
ca-certificates \
git \

&& git clone https://github.com/overware/BBQCoin \                   
&& cd BBQCoin \
&& git checkout 28d5d9 \
&& apt-get clean


# 2. Use v4.8 of the db.
RUN apt-get install -y --no-install-recommends \

# Needed by add-apt-repository.
software-properties-common \

# We need this because we want to get v4.8 of the wallet db
&& add-apt-repository ppa:bitcoin/bitcoin \

# And now we need to update this again
&& apt-get update \

# Now get v4.8 of the wallet db
&& apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \

&& apt-get clean


# 3. What else do we need to install to build all this?
RUN apt-get update \

&& apt-get install -y --no-install-recommends \
    build-essential \
    libboost-all-dev \
    libgmp3-dev \
    libmpfr-dev \
    libssl-dev \
    libtool \
    openssl \
    pkg-config \

# Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
    x11vnc \
    xvfb \

&& apt-get clean

# 4. This is boost 1.54. The instructions suggest this may not work.  But it does work.
RUN apt-get install -y --no-install-recommends libboost-all-dev


# 5.Now build it
WORKDIR /BBQCoin/src

RUN make -f makefile.unix USE_UPNP=-

# At this point, bbqcoind should be useable.
# ./bbqcoind -daemon -rpcuser=user -rpcpassword=password


# 6. Now install qt4 and build the gui
RUN apt-get install -y --no-install-recommends libqt4-dev qt4-qmake

WORKDIR /BBQCoin
RUN qmake USE_UPNP=-
RUN make

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh







