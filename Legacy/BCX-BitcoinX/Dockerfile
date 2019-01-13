# ???Build bitcoinxd, bitcoin-cli, bitcoin-seeder, bitcoin-qt, and bitcoin-tx from the code at
# ???https://github.com/Bitcoin-ABC/bitcoin-abc/commit/d8eac91f8d16716eed0ad11ccac420122280bb13

FROM debian:9.3
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# We need to do this first in order to see any packages at all
RUN apt update

# You know why we need git!
RUN apt install -y git


RUN git clone https://github.com/bostontrader/bitcoinx
WORKDIR /bitcoinx

# I happen to know that this particular commit works.
#RUN git checkout d8eac9

RUN apt install -y autoconf g++ libtool pkg-config

RUN apt install -y \
  # boost 1.62
  libboost-chrono-dev \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-test-dev \
  libboost-thread-dev \
  libevent-dev \
  libssl-dev

# hexdump needed for tests
RUN apt install -y dh-autoreconf

# Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
RUN apt install -y x11vnc xvfb


# 3. Use v4.8 of the db.
#&& apt-get install -y --no-install-recommends \

# Needed by add-apt-repository.
#software-properties-common && \

# We need this because we want to get v4.8 of the wallet db
#add-apt-repository ppa:bitcoin/bitcoin && \

# 3.3 And now we need to update this again
#apt-get update && \

# Now get v4.8 of the wallet db
#apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \


# 4. Install QT5
#&& apt-get install -y --no-install-recommends \

#libqt5core5a \
#libqt5gui5 \
#qttools5-dev-tools \
#protobuf-compiler \
#qtbase5-dev \

#&& apt-get clean





# 6. Make and strip the debug symbols
RUN ./autogen.sh && ./configure --disable-wallet && make

# && \strip src/bitcoinx && strip src/bitcoin-cli && strip src/bitcoin-seeder && strip src/bitcoin-tx && strip src/qt/bitcoin-qt \
#&& make install && make clean

# Wrap it up
#COPY entrypoint.sh /
#RUN chmod 755 /entrypoint.sh

