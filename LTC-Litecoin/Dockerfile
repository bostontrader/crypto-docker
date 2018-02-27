# Build the Litecoin daemon, cli, and GUI from the code at
# https://github.com/litecoin-project/litecoin/commit/845fc69ab3e4f02d9b00628ce844321147991fa07a

FROM ubuntu:16.04

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. Install the basic foundation of build tools, as per the docs.
RUN apt-get install -y --no-install-recommends \
    automake \
    autotools-dev \ 
    bsdmainutils \
    build-essential \ 
    libevent-dev \
    libssl-dev \
    libtool \
    pkg-config  

# 3. As per the docs, we only need to selectively install a handful of the boost libraries
RUN apt-get install -y --no-install-recommends \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev

# 4. Decide which wallet format to use.  If you have an old wallet that you need to support then you probably want to use v4.8 of the db. If so then keep this section

# This is a dependency of add-apt-repository.
RUN apt-get install -y --no-install-recommends software-properties-common

# We need this because we want to get v4.8 of the wallet db
RUN add-apt-repository ppa:bitcoin/bitcoin

# And now we need to update this again
RUN apt-get update

# Now get v4.8 of the wallet db
RUN apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev


# 5. Let's try to build this with QT5

RUN apt-get install -y --no-install-recommends \
    libprotobuf-dev \
    libqt5core5a \
    libqt5dbus5 \
    libqt5gui5 \
    protobuf-compiler \
    qttools5-dev \
    qttools5-dev-tools

# 6. Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
RUN apt-get install -y --no-install-recommends \
    x11vnc \
    xvfb

# 7. Clone the source code.

# You'll need this for git clone
RUN apt-get install -y --no-install-recommends \
    git

RUN  git clone https://github.com/litecoin-project/litecoin
                                                       
WORKDIR /litecoin

# I happen to know that this particular commit works.
RUN git checkout 845fc6

# 8. Now build it!

RUN ./autogen.sh 

# Recall that by default we use the v4.8 version of the db
RUN ./configure --without-miniupnpc 

RUN make && \

strip src/litecoind && \
strip src/litecoin-cli && \
strip src/litecoin-tx && \
strip src/qt/litecoin-qt && \
strip src/qt/test/test_litecoin-qt && \
strip src/test/test_litecoin && \

make install && make clean 

LABEL author.name="Thomas Radloff"

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

