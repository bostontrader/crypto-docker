#!/bin/sh

# Build the UNO-Unobtanium executables from source code dated 2018-08.

# 1. alpine and git
docker build -t cd/0 -f ../Dockerfile.0 ..

# 2. Add the tools to pass autogen
docker build -t cd/00 -f ../Dockerfile.00 ..

# 3. Add a suitable version of boost
docker build -t cd/000 -f ../Dockerfile.000 ..

# 4. Add the tools to pass configure
docker build -t cd/0000 -f ../Dockerfile.0000 ..

# 5. Add the packages for QT, DB, and X11
docker build -t cd/00000 -f ../Dockerfile.00000..

# 6. Get the source code dated 2018-08
docker build -t cd/uno-unobtanium:base -f Dockerfile.base . \
  --build-arg SOURCE_ORIGIN=https://github.com/unobtanium-official/Unobtanium \
  --build-arg SOURCE_LOCAL_ROOT=/Unobtanium \
  --build-arg COMMIT=398d50
