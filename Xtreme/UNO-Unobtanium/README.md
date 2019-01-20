## Build cd/uno-unobtanium:base

From a shell window on the host...

```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker/Xtreme/UNO-Unobtanium
$ cd ./buildit.sh
```
This will build the hierarchy of images, if not already built, that support UNO, as well as the image that contains the UNO source code, which descends from the hierarchy.  

Note: buildit.sh assumes that docker executes _without_ using sudo.  If this is not true, either make it so, or modify buildit.sh.

Next...

## Build cd/uno-unobtanium:production

```sh
$ docker build -t cd/uno-unobtanium:production -f Dockerfile.production .
```
This will build cd/uno-unobtanium:production which contains only the desired executeables, optimized and devoid of debug symbols, as well as some plumbing for X11.  Nothing else.  This gives us a compact image.

From a shell window on the host...

```sh
$ export DATADIR=/some/path/to/.unobtanium
$ docker run -it --rm -p 5900:5900 -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.unobtanium cd/uno-unobtanium:production
```
This will run the uno-unobtanium:production container and mount the given directory to the container, for use as unobtanium's datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed.  Port 5900 in the container will be connected to port 5900 on the host, for use by X11 and the viewer.  The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.unobtanium must already exist, docker won't create it for you.

Once inside the container...

```sh
$ ./entrypoint.sh
```
This sets up everything so that unobtanium-qt thinks it has an X11 display to work with, executes unobtanium-qt, and connects it all to port 5900 (by default) so that it may be viewed by your VNC viewer of choice from outside the container.

So, from the host system, use your VNC viewer of choice and connect to localhost:5900.  There it is!

WARNING: This setup does not use a password for the VNC viewer.


## Build cd/uno-unobtanium:debug

```sh
$ docker build -t cd/uno-unobtanium:debug -f Dockerfile.debug .
```
This will build cd/uno-unobtanium:debug which contains the desired executeables with debug symbols and no optimization.  It will also install some tools of debuggery. This gives us a larger image.

In order to run the debug image, from a shell window on the host:

```sh
$ export DATADIR=/some/path/to/.unobtanium
$ docker run -it --rm --privileged -p 5000:5000 -p 5900:5900 --mount type=bind,source=/some/path/to/.unobtanium,destination=/.unobtanium cd/uno-unobtanium:debug
```
This will run the uno-unobtanium:debug image and mount the given "source" directory to the container, for use as unobtanium's datadir.  As with before, the source directory must exist because docker won't create it for you.

Note: Everything is also run as root and in doing so our datadir will get chowned to root so you might need to rechown it later.  This is a nasty "feature" that arises because of installing the software first as root, when we build the container, and then trying to run the container to use the current host's user.  Doing so does not compute.

Once inside the container...

```sh
$ gdbgui -r "src/unobtaniumd -printtoconsole -rpcuser=user -rpcpassword=password"
```

Or maybe...

```sh
$ gdbgui -r "src/qt/unobtanium-qt"
```

These commands enable gdbgui to invoke gdb which will load the specified executable and get it ready to run.  Gdugui will print a log message saying "View gdbgui at http://172.17.0.2:5000"  From a browser of choice on the host system, browse to there.  There it is!

To help you get started with debugging, go to the bottom of the browser where you see "enter gdb command".  Type **b main** This means to break at the entry of the main function.  Next, type **start**  this "starts" unobtaniumd.  I'll let you contemplate the subtleties of what that actually means.  Better type, type **s** (for step).  Then doit again and again.. Now you're walking through the code!

Look around the window and see what else you can do with this.

In the upper right corner, look for a button that is tooltipped "send interrupt signal (SIGINT)"  This is how you turn off the unobtanium executable.  Then CTRL-C in the container window to turn off gdbgui.  Then 'exit'.

[RTFM re: GDB](https://www.gnu.org/software/gdb/) and learn how to fly with the eagles.

# Thanks Tom!

If you find this useful please consider supporting us either via [Patreon](https://patreon.com/coinkit) or our tip jar

uno: uRZEAT1zAhoRkQPrYuQG6FXTo3Nz9KRXyT
