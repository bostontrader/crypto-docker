# Introduction

The purpose of **crypto-docker** is to provide a general tool-kit for obtaining the various elements of software for a handful of selected crypto coins. This is done primarily by creating appropriate docker images.  The newest images can be built very compactly by using Alpine Linux.


# Example Use Cases

As a general tool-kit, **crypto-docker** will give you a great deal of flexibility in deciding what software to build and how to use it.  The following examples are illustrative, not exhaustive:

Using **crypto-docker** you will be able to:

1. Build a docker image with binaries that are optimized by the compiler but devoid of debugging information.  Said images are relatively small.

2. Build an image with binaries that are not optimized and do include debugging information.  Said images are rather bloated.

3. Build an image that only supports the command line tools such as coind or coin-cli, but no GUI.

4. Build an image that supports coin-qt.  The running container will communicate with an external VNC viewer in order to see the GUI.

5. Build an image that contains gdb and gdbgui.  The running container will communicate with an external web browser to enable graphical debugging of the software.


# Comes in Two Flavors

## Legacy Edition

The project originated with the First Dockerfile. As with cats or children, soon there was a second one.  And so on and so on.  Without benefit of hindsight we did things in a certain way that we might cringe at today.  As time goes on we'll eventually revisit and update the Legacy Dockerfiles, but until then, they still exist and still need your love and understanding.

## Xtreme Edition

The Xtreme edition represents our present level of understanding.  Perhaps not quite on the level of divine inspiration, but there are some signifigant changes, hopefully for the better.


# TL;DR. Getting Started

1. From a shell window, clone the repo and enter the directory.

```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker
```

2. This directory contains several subdirectories, one for each supported coin, nested inside /Legacy or /Xtreme. Inside each directory is one or more Dockerfiles as well as any associated relevant documentation or extras.  Choose a particular coin of interest and RTFM.

3. For each particular coin of interest you should create a data directory on the host system.  Said data directory will get attached to the running container at runtime.

4. WARNING!  Be aware that you may or may not need to use sudo with the docker commands, depending the nature of your particular installation.  These instructions assume no sudo.

# Example 1. XJO-Joulecoin, QT 5

## Build cd/xjo-joulecoin:base

From a shell window on the host...

```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker/Xtreme/XJO-Joulecoin
$ cd ./buildit.sh
```
This will build the hierarchy of images, if not already built, that support XJO, as well as the image that contains the XJO source code, which descends from the hierarchy.  Next...

## Build cd/xjo-joulecoin:production

```sh
$ docker build -t cd/xjo-joulecoin:production -f Dockerfile.production .
```
This will build cd/xjo-joulecoin:production which contains only the desired executeables, optimized and devoid of debug symbols, as well as some plumbing for X11.  Nothing else.  This gives us a compact image.

The prior steps built the images and are only needed when you first clone the repo or make any changes to the Dockerfiles thereafter.  It is however harmless to run these again.  But after the images are built, it's time to run the xjo-joulecoin:production image.

From a shell window on the host...

```sh
$ export DATADIR=/some/path/to/.joulecoin
$ docker run -it --rm -p 5900:5900 -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.joulecoin cd/xjo-joulecoin:production
```
This will run the xjo-joulecoin:production container and mount the given directory to the container, for use as Joulecoin's datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed.  Port 5900 in the container will be connected to port 5900 on the host, for use of X11 and the viewer.  The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.joulecoin must already exist, docker won't create it for you.

Once inside the container...

```sh
$ ./entrypoint.sh
```
This sets up everything so that joulecoin-qt thinks it has an X11 display to work with, executes joulecoin-qt, and connects it all to port 5900 (by default) so that it may be viewed by your VNC viewer of choice from outside the container.

So, from the host system, use your VNC viewer of choice and connect to localhost:5900.  There it is!

WARNING: This setup does not use a password for the VNC viewer.


# Example 2. XJO-Joulecoin, debug joulecoind

## Build cd/xjo-joulecoin:base

See the instructions for this in the prior example.

## Build cd/xjo-joulecoin:debug

```sh
$ docker build -t cd/xjo-joulecoin:debug -f Dockerfile.debug .
```
This will build cd/xjo-joulecoin:debug which contains the desired executeables with debug symbols and no optimization.  It will also install some tools of debuggery but will not install any of the plumbing for X11.  We leave this as an exercise for the reader.  This gives us a larger image.

The prior steps built the images and are only needed when you first clone the repo or make any changes to the Dockerfiles thereafter.  It is however harmless to run these again.  But after the images are built, it's time to run the xjo-joulecoin:debug image.

From a shell window on the host there are basically two choices for running the container:

Choice A:
```sh
$ docker run -it --rm --privileged -p 5000:5000 cd/xjo-joulecoin:debug
```
This will run the xjo-joulecoin:debug container but will not mount any data directory from the host.  Instead, the container will create its own ephemeral datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. We need the --privileged flag to make the debugger work. Port 5000 in the container will be connected to port 5000 on the host, for use by the debugger.  Everything in the container will run as root.

This is a good choice if we're not working on real data and we just want to look at the operation of the program.


Choice B:
```sh
$ export DATADIR=/some/path/to/.joulecoin
$ docker run -it --rm --privileged -p 5000:5000 --mount type=bind,source=$DATADIR,destination=/.joulecoin cd/xjo-joulecoin:debug
```
This will run the xjo-joulecoin:debug container and mount the given directory to the container, for use as Joulecoin's datadir. Everything is also run as root and in doing so our datadir will get chowned to root and you'll need to rechown it later.  This is a nasty "feature" that arises because of installing the software first as root, when we build the container, and then trying to run the container to use the current host's user.  Doing so does not compute.

For either choice, once inside the container...

```sh
$ gdbgui -r "src/joulecoind -printtoconsole -rpcuser=user -rpcpassword=password"
```
The enables gdbgui to invoke gdb which will load src/bitcoind and get it ready to run.  Gdugui will print a log message saying "View gdbgui at http://172.17.0.2:5000"  Pay no attention that IP address.  That's docker networking and we won't worry about it now.  Instead, from your browser of choice on the host system, browse to localhost:5000.  There it is!

To help you get started with debugging, go to the bottom of the browser where you see "enter gdb command".  Type **b main** This means to break at the entry of the main function.  Next, type **start**  this "starts" joulecoind.  I'll let you contemplate the subtleties of what that actually means.  Better type, type **s** (for step).  Then doit again and again.. Now you're walking through the code!

Look around the window and see what else you can do with this.

In the upper right corner, look for a button that is tooltipped "send interrupt signal (SIGINT)"  This is how you turn off the joulecoind program.  Then CTRL-C in the container window to turn off gdbgui.  Then 'exit'.

[RTFM re: GDB](https://www.gnu.org/software/gdb/) and learn how to fly with the eagles.



# Digging Deeper

Given the variety of ages of the Dockerfiles in this project, the principles enumerated herein are not necessarily present in all cases.

## 1. Files, permissions, users, and groups.

These containers are ephemeral.  You start them, use them, and discard them at your whim.  They won't save any state, such as wallets or blockchains, between executions.  Therefore said info for a particular coin ought to be stored somewhere in the file system of the host system and bound to the container at runtime.

Doing so is easier said than done because in addition to binding a host system directory to the container, we also have to figure out file permissions, users, and groups.

File and group permissions operate according to a numeric User ID and Group ID.  The actual names are not relevant.  By default, the processes inside an image will run as root, which is UID 0.  If you accept this default, then some of the bound files will get chowned to that user. In addition to being a security hazard, this practice will generally cause later nuisance.  The legacy Dockerfiles still do this.  But the new Dockerfiles do the following:

* Run the container passing a desired UID and GID on the command line.

* Upon startup, the container will create a user with said UID and GID and su to that user.  Subsequent file I/O will therefore not cause the aforementioned trouble.


# 2. How to see the GUI

The GUI uses X11 and we need to do some contortions to get X11 out of the container and visible on the host.  One way to do that is to use a VNC viewer on your host system to connect to Xvfb and x11vnc inside the container.  By default we use port 5900 and when running a container we need to use the option -p 5900:5900 in order to expose this port from the container as port the same for the host.


# 3. How to debug

As with the GUI, in order to debug an executable and implement a graphical debugger, we need an accomplice inside the container to communicate with a GUI on the outside.  In this case we use gdb and [gdbgui](https://gdbgui.com/).  This dynamic duo will communicate via the default port 5000 to a web browser on the host. 


# Omphaloskepsis re: Design Decisions

## Dealing with Build Variations

Suppose you want to make an image that contains the executables for a particular coin.  Do you build that with debugging symbols but no optimization?  How about no debugging symbols and lots of optimization?  Are you using QT4, QT5, or none of the above?  Are you using Berkley DB 4.8 or a more advanced version? Do you want [woofers and tweeters?](https://www.youtube.com/watch?v=OXDK3x5lAYI&t=118) These examples and many more confound our efforts.  How are we supposed to manage this?  Shall we hand-modify the Dockerfile each time we want to change these options?  Shall we feed parameters to the docker build command?  Given an image, what options does it support?  Shall we create a naming system that enables us to create any number of variations?  So many questions and more.

* Image Size

Shall we build the images FROM Alpine, Debian? Ubuntu? Something else?  Can we get rid of the build tools, source code, and other bloat after building in order to reduce the image size?  Should we control the inclusion of symbols with command line arguments or shall we strip the symbols from the resulting binaries?

* How can we attach a debugger, preferrably a graphical one, to the executables?

* How can we enable the QT/GUI executable to actually render a GUI?

* The various coins have a tremendous amount of similarity between them because their source code is all related.  How can we work this reality to better organize our images?

* Despite the similarities in the source code, there's also quite a lot of difference.  This affects which version of various dependencies can be used.

## Our Solution

The basic solution is to build a heirarchy of images that derive from common ancestors.  Similar to an OO inheritance tree.  A major problem with this strategy is to find a naming system.  It's not practical to build package names, versions, and/or functionality into the dockerfile and image names.  They would quickly become too long and unwieldy.

A reasonable, if somewhat tedious, solution is to use a numbering system for the names, agumented with an index.  For example:

Dockerfile.0102 produces an image named cd/0102.  The 4 digits, from left to right, represent layers 1 - 4 of the model, and each digit's value represents sequential variation within the given layer.


* Layer 1.

In this project we use Alpine.  Ideally we want to use the most recent version but sometimes we must use earlier versions.  These Dockerfiles also include git.

Presently we only use Alpine 3.4, identified as sequential variation 0.

Dockerfile.0 produces image cd/0


* Layer 2.

This layer adds the packages required to succussfully pass autogen.sh.  The source code will come in a later layer.

Presently we only have a single sequential variation 0, that decends from cd/0

Dockerfile.00 produces image cd/00


* Layer 3.

This layer adds the boost library packages.  Which version of boost do we want?  This is highly influenced by the choice in Layer 1.

Presently we only use boost 1.60, identified as sequential variation 0, that decends from cd/00

Dockerfile.000 produces image cd/000


* Layer 4.

This layer adds additional packages required to pass configure such as g++, make, and openssl.  It does _not_ add packages that depend upon specific build options such as QT4 or QT5 or the Berkeley DB.

Presently we only have a single sequential variation 0, that decends from cd/000

Dockerfile.0000 produces image cd/0000


* Layer 5.

This layer adds the packages for QT, The Berkeley db, and for the provision of X11.  Although there's quite a bit of combinatorial possibility here, presently we only use one variation of QT5, Berkeley db 5.3, and the X11 software.  This decends from cd/0000

Dockerfile.00000 produces image cd/00000



The prior 5 layers are a common heirarchy that all coins can share and can easily accomodate additional variation.  From this base:

Each coin has Dockerfile.base which starts from one of these layers and adds the source code.  It is built by feeding --build-arg as necessary. 

Each coin can have one or more build variations such as Dockerfile.debug and Dockerfile.production.  These descend from Dockerfile.base.

* Dockerfile.production is for ordinary production usage.  It executes autogen, configure, and make and is configured to eliminate debug symbols and to include optimization.    It uses two stages so that the final image only has what is required to execute, thus reducing its size.

* Dockerfile.debug produces a debug version. It executes autogen, configure, and make and is configured to include debug symbols but no optimization. It adds additional tools to support debugging.

# Thanks Tom!

If you find this useful please consider supporting us either via [Patreon](https://patreon.com/coinkit) or our tip jar

xjo: JhkSyR8HVxMANB6PLAKuQeutQqfWRXBYeY






