# Build peercoin-qt only from the code at
# https://github.com/peercoin/peercoin/commit/91c8c8df0ff36d29ef28d82cd02789b52f6bcf26

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. Install the basic foundation of build tools, as per the docs.
RUN apt-get install -y --no-install-recommends \
    build-essential \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libqt4-dev \
    libssl-dev \
    qt4-qmake

# 3. Decide which wallet format to use.  If you have an old wallet that you need to support then you probably want to use v4.8 of the db. If so then keep this section

# 3.1 This is a dependency of add-apt-repository.
RUN apt-get install -y --no-install-recommends software-properties-common

# 3.2 We need this because we want to get v4.8 of the wallet db
RUN add-apt-repository ppa:bitcoin/bitcoin

# 3.3 And now we need to update this again
RUN apt-get update

# 3.4 Now get v4.8 of the wallet db
RUN apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev

# 4. Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
RUN apt-get install -y --no-install-recommends x11vnc xvfb

# 5. Clone the source code.

RUN apt-get install -y --no-install-recommends git

RUN git clone https://github.com/peercoin/peercoin                                   

WORKDIR /peercoin

# I happen to know that this particular commit works.
RUN git checkout 91c8c8

# 6. Now build it!
RUN qmake USE_UPNP=-
RUN make V=1

