# Build the CHNCoin daemon, cli, and GUI from the code at
# https://github.com/coinzen/devcoin/commit/ea4b51021ef98fd928320cbd1469460b93a0b33c

FROM ubuntu:14.04
MAINTAINER Thomas Radloff <bostontrader@gmail.com>

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. Install the basic foundation of build tools, as per the docs.
RUN apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libtool \
    openssl \
    pkg-config

# 3. The instructions suggest build-dep curl.  That doesn't work.  This does.
RUN apt-get -y install curl 

# 4. This is boost 1.54. The instructions suggest this may not work.  But it does work.
RUN apt-get install -y --no-install-recommends libboost-all-dev

# 5. Use v4.8 of the db.

# 5.1 This is a dependency of add-apt-repository.
RUN apt-get install -y --no-install-recommends software-properties-common

# 5.2 We need this because we want to get v4.8 of the wallet db
RUN add-apt-repository ppa:bitcoin/bitcoin

# 5.3 And now we need to update this again
RUN apt-get update

# 5.4 Now get v4.8 of the wallet db
RUN apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev

# 6. Clone the source code.

RUN apt-get install -y --no-install-recommends git

RUN git clone https://github.com/coinzen/devcoin.git                                             

WORKDIR /devcoin/src

# I happen to know that this particular commit works.
#RUN git checkout ea4b51

# 7. Now build devcoind.
RUN chmod 755 leveldb/build_detect_platform
RUN make -f makefile.unix USE_UPNP=-

# At this point, devcoind should be useable.
# ./devcoind -daemon -rpcuser=user -rpcpassword=password -addnode=104.168.155.119 -addnode=144.217.71.144

# Next, build the GUI

# 8. Now install qt4

RUN apt-get install -y --no-install-recommends libqt4-dev qt4-qmake

# 9. Now build it!
WORKDIR /devcoin
RUN qmake USE_UPNP=-
RUN make

#10. Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
RUN apt-get install -y --no-install-recommends x11vnc xvfb

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

