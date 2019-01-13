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

# Thanks Tom!

If you find this useful please consider supporting us either via [Patreon](https://patreon.com/coinkit) or our tip jar

xjo: JhkSyR8HVxMANB6PLAKuQeutQqfWRXBYeY
