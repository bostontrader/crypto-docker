#!/bin/sh

# Build the BCH-BitcoinCash executables from source code dated 2019-01

# 1. alpine and git
docker build -t cd/0 -f ../Dockerfile.0 ..

# 2. Add the tools to pass autogen
docker build -t cd/00 -f ../Dockerfile.00 ..

# 3. Add a suitable version of boost
docker build -t cd/000 -f ../Dockerfile.000 ..

# 4. Add the tools to pass configure
docker build -t cd/0001 -f ../Dockerfile.0001 ..

# 5. Add the packages for QT, DB, and X11
docker build -t cd/00010 -f ../Dockerfile.00010 ..

# 6. Get the source code dated 2019-01
docker build -t cd/bch-bitcoin-cash-abc:base -f Dockerfile.base . \
  --build-arg SOURCE_ORIGIN=https://github.com/Bitcoin-ABC/bitcoin-abc \
  --build-arg SOURCE_LOCAL_ROOT=/bitcoin-abc \
  --build-arg COMMIT=1da1dd 




