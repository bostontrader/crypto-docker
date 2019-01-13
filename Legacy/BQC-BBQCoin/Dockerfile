# Build bbqcoind and bbqcoin-qt from the code at https://github.com/overware/BBQCoin/commit/b1e803d09e4be4c50d43b6fa115c0cabc09d4976 (2014-Feb)

FROM ubuntu:16.04

# Try 18.04 and you get:
# bignum.h: In function 'bool operator>=(const CBigNum&, const CBigNum&)':
# bignum.h:551:83: error: cannot convert 'const CBigNum*' to 'const BIGNUM* {aka const bignum_st*}' for argument '1' to 'int BN_cmp(const # BIGNUM*, const BIGNUM*)'
# inline bool operator>=(const CBigNum& a, const CBigNum& b) { return (BN_cmp(&a, &b) >= 0); }

# 1. Install the minimal requirements to clone the source code.
RUN apt-get update \

    && apt-get install -y --no-install-recommends \
       ca-certificates \
       git \

    && git clone https://github.com/overware/BBQCoin \                   
    && cd BBQCoin \
    && git checkout b1e803 \

    # 2. Use v4.8 of the db.
    && apt-get install -y --no-install-recommends \

       # Needed by add-apt-repository.
       software-properties-common \

    # We need this because we want to get v4.8 of the wallet db
    && add-apt-repository ppa:bitcoin/bitcoin \

    # And now we need to update this again
    && apt-get update \

    # Now get v4.8 of the wallet db
    && apt-get install -y --no-install-recommends libdb4.8-dev libdb4.8++-dev \

    # 3. Need qt4
    && apt-get install -y --no-install-recommends libqt4-dev qt4-qmake \

    # 4. Need some development tools.
    && apt-get install -y --no-install-recommends \
        build-essential \
        libboost-all-dev \
        libgmp3-dev \
        libmpfr-dev \
        libssl-dev \
        libtool \
        openssl \
        pkg-config \

    # 5. Install these packages in order to view the QT GUI using a VNC viewer.  Which you need to do if you want to run the QT GUI inside a docker container.
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       x11vnc \
       xvfb \

    && apt-get clean

# 6. Now build it all
WORKDIR /BBQCoin/src

RUN make -f makefile.unix USE_UPNP=-

# At this point, bbqcoind should be useable.

WORKDIR /BBQCoin
RUN qmake USE_UPNP=-
RUN make
WORKDIR /

