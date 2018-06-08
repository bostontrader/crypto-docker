 
# Build Europecoin-V3 from the source code at
# https://github.com/LIMXTEC/Europecoin-V3


FROM ubuntu:16.04
# FROM armhf/ubuntu 
# move the "#" to build either for ARMHF or for PC

# Although it's customary to lump all the apt-get instructions into one layer, I will instead separate them
# into a small number of layers each containing some related packages. I think you'll find understanding their purposes
# to be easier.

# We need to do this first in order to see any packages at all
RUN apt-get update

# This is a dependency of add-apt-repository.
RUN apt-get install  -y --no-install-recommends software-properties-common

# We need this because we want to get v4.8 of the wallet db
RUN add-apt-repository ppa:bitcoin/bitcoin

# And now we need to update this again
RUN apt-get update

# The basic foundation of build tools, as per the docs.
RUN apt-get install -y --no-install-recommends \
    automake \
    autotools-dev \
    bsdmainutils \
    build-essential \
    libevent-dev \
    libssl-dev \
    libtool \
    pkg-config

# As per the docs, we only need to selectively install a handful of the boost libraries
RUN apt-get install -y --no-install-recommends \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev

# If you want a wallet, you'll need a db.  Since this is a new coin, we probably don't care about jumping through
# hoops to get the 4.8 version of the db.  So let's just use what's readily on tap instead.
RUN apt-get install -y --no-install-recommends \
    libdb-dev \
    libdb++-dev

# If you want the QT 5 GUI, you'll need these packages:
RUN apt-get install -y --no-install-recommends \
    libprotobuf-dev \
    libqt5core5a \
    libqt5dbus5 \
    libqt5gui5 \
    protobuf-compiler \
    qttools5-dev \
    qttools5-dev-tools 

# You will also need 11vnc xvfb in order to view the QT GUI using a VNC viewer.  Which you need to do
# if you want to run the QT GUI inside a docker container.
RUN apt-get install -y --no-install-recommends \
    x11vnc xvfb

# Need these for git clone
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    git

RUN rm -rf /var/lib/apt/lists/*

RUN  git clone https://github.com/LIMXTEC/Europecoin-V3
                                                           
WORKDIR /Europecoin

# I happen to know that this particular commit works.
# RUN git checkout 4bcc737

RUN \
./autogen.sh && \
./configure --with-incompatible-bdb --without-miniupnpc  && \
make && \
strip src/europecoind && strip && strip src/qt/europecoin-qt  && \
make install && make clean

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
