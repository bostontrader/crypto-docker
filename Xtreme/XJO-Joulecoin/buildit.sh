#!/bin/sh

# Build the XJO-Joulecoin executables from source code dated 2018-09.

# 1. alpine 3.4.  Later versions yield compile errors because of the boost libraries.  Why?
docker build -t cd/0 -f ../Dockerfile.0 ..

# 2. Add the tools to pass autogen
docker build -t cd/00 -f ../Dockerfile.00 ..

# 3. Add a suitable version of boost
docker build -t cd/000 -f ../Dockerfile.000 ..

# 4. Add the tools to pass configure
docker build -t cd/0000 -f ../Dockerfile.0000 ..

# 5. Add the packages for QT, DB, and X11
docker build -t cd/00000 -f ../Dockerfile.00000 ..

# 6. Get the source code
docker build -t cd/xjo-joulecoin:base -f Dockerfile.base . \
  --build-arg SOURCE_ORIGIN=https://github.com/joulecoin/joulecoin \
  --build-arg SOURCE_LOCAL_ROOT=/joulecoin \
  --build-arg COMMIT=867336


