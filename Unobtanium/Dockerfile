# Build the Unobtanium daemon, cli, and GUI from the code at
# https://github.com/unobtanium-official/Unobtanium/commit/7ccdf8ff9d0ddda761afd9a4010f05e123dcd6e9

FROM ubuntu:16.04

# We need to do this first in order to see any packages at all
RUN apt-get update

# This is a dependency of add-apt-repository.
RUN apt-get install  -y --no-install-recommends software-properties-common

# We need this because we want to get v4.8 of the wallet db
RUN add-apt-repository ppa:bitcoin/bitcoin

# And now we need to update this again
RUN apt-get update

# Now get v4.8 of the wallet db
RUN apt-get install  -y --no-install-recommends libdb4.8-dev libdb4.8++-dev

# The basic foundation of build tools, as per the docs.
RUN apt-get install -y --no-install-recommends \
    autoconf \
    autotools-dev \
    build-essential \
    libssl-dev \
    libtool \
    pkg-config


# As per the docs, we need boost
RUN apt-get install -y --no-install-recommends \
    libboost-all-dev

# If you want the QT GUI, you'll need these packages:
#RUN apt-get install -y --no-install-recommends \
    #libprotobuf-dev \
    #libqt5core5a \
    #libqt5dbus5 \
    #libqt5gui5 \
    #protobuf-compiler \
    #qttools5-dev \
    #qttools5-dev-tools 

RUN apt-get install -y --no-install-recommends \
    libqt4-dev libprotobuf-dev protobuf-compiler

# You will also need 11vnc xvfb in order to view the QT GUI using a VNC viewer.  Which you need to do
# if you want to run the QT GUI inside a docker container.
RUN apt-get install -y --no-install-recommends \
    x11vnc xvfb

# Need these for git clone
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    git

RUN  git clone https://github.com/unobtanium-official/Unobtanium
                                                           
WORKDIR /Unobtanium

# I happen to know that this particular commit works.
RUN git checkout 7ccdf8

# The docs don't mention this, but you'll need it for autogen.sh
RUN apt-get install -y --no-install-recommends \
    automake
RUN ./autogen.sh 

# The docs don't mention this, but you'll need it for configure
RUN apt-get install -y --no-install-recommends \
    bsdmainutils
#RUN export CXXFLAGS=$CXXFLAGS' -fPIE'
#RUN ./configure --disable-wallet
#RUN ./configure --with-incompatible-bdb --without-miniupnpc  
RUN ./configure      --without-miniupnpc --enable-hardening

# Fix this error.  See https://bitcointalk.org/index.php?topic=1312757.0
#RUN "echo 'Almost solved this'| sed 's/Almost/We have/'"
RUN sed -i 's/<const CScriptID&>/<CScriptID>/g' src/rpcrawtransaction.cpp
#RUN "sed -i 's/<const CScriptID&>/<CScriptID>/g' ./src/rpcrawtransaction.cpp"

#usr/include/x86_64-linux-gnu/qt5/QtCore/qglobal.h:1067:4: error: #error "You must build your code with position independent code if Qt was #built with -reduce-relocations. " "Compile your code with -fPIC (-fPIE is not enough)."
 #  error "You must build your code with position independent code if Qt was built with -reduce-relocations. "\

#RUN make -f makefile.unix ... -e PIE=1
RUN make
#RUN make install
#RUN make clean

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

#strip unobtaniumd
# cp unobtaniumd ..
# Enter a running container
#sudo docker exec -it f3de1e4f9191 /bin/bash

# Run a container and enter it
# sudo docker run -it docker-study

# Run a container, execute command
# sudo docker run -it docker-study /entrypoint.sh

#du -h /var | grep '[0-9\.]\+M'
