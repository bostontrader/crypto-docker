# Ubuntu 16.04 is the most recent version that will build.  Above this we get compiler errors with BIGNUM
# and qt4-qmake becomes unavailable.
FROM ubuntu:16.04
LABEL maintainer Thomas Radloff <bostontrader@gmail.com>

# Build chncoin-qt from this commit dated 2013-Nov that is known to work.
# No command line tools, testing, or anything else are readily available.
ENV SOURCE_ORIGIN https://github.com/RoadTrain/CHNCoin
ENV COMMIT df376be
ENV SOURCE_LOCAL_ROOT CHNCoin

# 1. We need to do this first in order to see any packages at all
RUN apt-get update

# 2. We need git to git the source code.
RUN apt install -y --no-install-recommends ca-certificates git 

# 3. Clone the source code.
RUN git clone --progress $SOURCE_ORIGIN
WORKDIR $SOURCE_LOCAL_ROOT
RUN git checkout $COMMIT

# 4. Install the basic foundation of build tools.
RUN apt-get install -y --no-install-recommends \
    build-essential \
    libqt4-dev \
    libssl-dev \
    qt4-qmake

# 5. Berzerkly db 5.3.  Don't waste our time with the 4.8 version.
RUN apt install -y --no-install-recommends libdb-dev libdb++-dev

# 6. We don't need all of the boost libraries (v1.58), only selectively install a handful of them
RUN apt install -y --no-install-recommends \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-thread-dev

# 7. We need these packages in order to view the QT GUI using a VNC viewer, which we need to do if we want to run 
# the QT GUI inside a docker container, which we need to do here because this build only builds the GUI edition 
# but none of the command line tools.
RUN apt-get install -y --no-install-recommends x11vnc xvfb

# 8. Now build it!
RUN qmake USE_UPNP=-
RUN make V=1

# Now we have everything built, but we have a lot of extra bloat because of the build tools.
# At this point we might stage this and grab only what we need.  However this is a rotten little coin
# and doing this is too much trouble.  Skip...

# 9. Finally, do some gyrations with users and groups so that we don't mess up the file permissions of the linked
# volume on the host system. https://vsupalov.com/docker-shared-permissions/
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID chnuser
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID chnuser
USER chnuser

