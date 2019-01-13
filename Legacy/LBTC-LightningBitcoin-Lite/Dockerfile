# Build the LBTC Lite Wallet (Electrum Clone) from the code at
# https://github.com/lbtcio/lbtc-lightwallet-client/commit/4e88e8a51632e00bfc93a57e2e6f33fc7bbdebb2

FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>


# 1. We need to do this first in order to see any packages at all
RUN apt-get update


# 2. Install these basic packages because the build will fail without them.
RUN apt-get install -y --no-install-recommends \

# need this to clone the source code
ca-certificates \

# you know why we need git!
git \

# cuz the wallet uses python to build
protobuf-compiler python3 python3-setuptools pyqt5-dev-tools \

# Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
x11vnc \
xvfb

# 3. Clone the source code.

RUN git clone https://github.com/lbtcio/lbtc-lightwallet-client                                     
WORKDIR /lbtc-lightwallet-client

# I happen to know that this particular commit works.
RUN git checkout 4e88e8

RUN python3 setup.py install
#sudo apt-get install pyqt5-dev-tools
RUN pyrcc5 icons.qrc -o gui/qt/icons_rc.py


# 4. Wrap it up
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

