https://bitcointalk.org/index.php?topic=267545.3840

## Build cd/zet-zetacoin:base

From a shell window on the host...

```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker/Xtreme/ZET-Zetacoin	
$ cd ./buildit.sh
```
This will build the hierarchy of images, if not already built, that support ZET, as well as the image that contains the ZET source code, which descends from the hierarchy.

Note: buildit.sh assumes that docker executes _without_ using sudo.  If this is not true, either make it so, or modify buildit.sh.

Next...

## Build cd/zet-zetacoin:production

```sh
$ docker build -t cd/zet-zetacoin:production -f Dockerfile.production .
```
This will build cd/zet-zetacoin:production which contains only the desired executeables, optimized and devoid of debug symbols, as well as some plumbing for X11.  Nothing else.  This gives us a compact image.

From a shell window on the host...

```sh
$ export DATADIR=/some/path/to/.zetacoin
$ docker run -it --rm -p 5900:5900 -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.zetacoin cd/zet-zetacoin:production
```
This will run the cd/zet-zetacoin:production image and mount the given directory to the container, for use as Zetacoin's datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed.  Docker will connect port 5900 in the container to port 5900 on the host, for use by X11 and the viewer.  The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.zetacoin must already exist, docker won't create it for you.

Once inside the container...

```sh
$ ./entrypoint.sh
```
This sets up everything so that zetacoin-qt thinks it has an X11 display to work with, executes zetacoin-qt, and connects it all to port 5900 (by default) so that it may be viewed by your VNC viewer of choice from outside the container.

So, from the host system, use your VNC viewer of choice and connect to localhost:5900.  There it is!

WARNING: This setup does not use a password for the VNC viewer.


## Build cd/zet-zetacoin:debug

```sh
$ docker build -t cd/zet-zetacoin:debug -f Dockerfile.debug .
```
This will build cd/zet-zetacoin:debug which contains the desired executeables with debug symbols and no optimization.  It will also install some tools of debuggery. This gives us a larger image.

In order to run the debug image, from a shell window on the host:

```sh
$ export DATADIR=/some/path/to/.zetacoin
$ docker run -it --rm --privileged -p 5900:5900 --mount type=bind,source=/some/path/to/.zetacoin,destination=/.zetacoin cd/zet-zetacoin:debug
```
This will run the zet-zetacoin:debug image and mount the given "source" directory to the container, for use as Zetacoin's datadir.  As with before, the source directory must exist because docker won't create it for you.

We must use the --privileged option lest the debugger not actually stop on our breakpoints.

Note: In the debug container, everything is run as root and in doing so our datadir will get chowned to root so you might need to rechown it later.  This is a nasty "feature" that arises because of installing the software first as root when we build the image, and then trying to run the image to use the current host's user.  Doing so does not compute.

Once inside the container...

```sh
$ gdbgui -r "src/zetacoind -printtoconsole -rpcuser=user -rpcpassword=password"
```

Or maybe...

```sh
$ gdbgui -r "src/qt/zetacoin-qt"
```

These commands enable gdbgui to invoke gdb which will load the specified executable and get it ready to run.  Gdugui will print a log message saying "View gdbgui at (some ip address):5000"  From a browser of your choice on the host system, browse to there.  There it is!  Note: You may have to wait a few seconds for the debugger window to populate.

To help you get started with debugging, go to the bottom of the browser where you see "enter gdb command".  Type **start**  this "starts" the executable.  I'll let you contemplate the subtleties of what that actually means.  Next, type **s** (for step) to step into a function and/or **n** (for next) to step over the next line.  Then doit again and again.. Now you're walking through the code!

Look around the window and see what else you can do with this.

In the upper right corner, look for a button that is tooltipped "send interrupt signal (SIGINT)"  This is how you turn off the executable.  Then CTRL-C in the container window to turn off gdbgui.  Then 'exit'.

[RTFM re: GDB](https://www.gnu.org/software/gdb/) and learn how to fly with the eagles.

# Thanks Tom!

If you find this useful please consider supporting us either via [Patreon](https://patreon.com/coinkit) or our tip jar

zet: ZKSyDgv34i2gqNtMRNhuUE9Lqg5bjaJEqr
