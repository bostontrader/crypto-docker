#!/bin/sh

# Build the FRC-Freicoin executables from source code dated 2018-10.

# 1. alpine and git
docker build -t cd/0 -f ../Dockerfile.0 ..

# 2. Add the tools to pass autogen
docker build -t cd/00 -f ../Dockerfile.00 ..

# 3. Add a suitable version of boost
docker build -t cd/000 -f ../Dockerfile.000 ..

# 4. Add the tools to pass configure
docker build -t cd/0000 -f ../Dockerfile.0000 ..

# 5. Add the packages for QT, DB, and X11
docker build -t cd/00000 -f ../Dockerfile.00000 ..

# 6. Get the source code dated 2018-10
docker build -t cd/frc-freicoin:base -f Dockerfile.base . \
  --build-arg SOURCE_ORIGIN=https://github.com/freicoin/freicoin \
  --build-arg SOURCE_LOCAL_ROOT=/freicoin \
  --build-arg COMMIT=eec192

