This coin is somewhat different from the rest in that it doesn't support an GUI.  Either QT4 or QT5. Therefore we omit a lot of material that has to do with dealing with GUI.

## Build cd/bsv-bitcoin-sv:base

From a shell window on the host...

```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker/Xtreme/BSV-BitcoinSV
$ cd ./buildit.sh
```
This will build the hierarchy of images, if not already built, that support BSV, as well as the image that contains the BSV source code, which descends from the hierarchy.  Next...

## Build cd/bsv-bitcoin-sv:production

```sh
$ docker build -t cd/bsv-bitcoin-sv:production -f Dockerfile.production .
```
This will build cd/bsv-bitcoin-sv:production which contains only the desired executeables, optimized and devoid of debug symbols. Nothing else.  This gives us a compact image. Unlike most of the other coins, this one does not have any GUI and therefore does not have any of the customary X11 plumbing.

The prior steps built the images and are only needed when you first clone the repo or make any changes to the Dockerfiles thereafter.  It is however harmless to run these again.  But after the images are built, it's time to run the bsv-bitcoin-sv:production image.

From a shell window on the host...

```sh
$ export DATADIR=/some/path/to/.bitcoin
$ docker run -it --rm --mount type=bind,source=$DATADIR,destination=/.bitcoin cd/bsv-bitcoin-sv:production
```
This will run the bsv-bitcoin-sv:production container and mount the given directory to the container, for use as BitcoinSV's datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.bitcoin must already exist, docker won't create it for you.

Once inside the container...

```sh
$ src/bitcoind -printtoconsole -rpcuser=user -rpcpassword=password -daemon
$ src/bitcoin-cli -rpcuser=user -rpcpassword=password <some cli command>
```

This turns on bitcoind in daemon mode which then allows us to invoke bitcoin-cli in order to control it.

# Debugging

## Build cd/bsv-bitcoin-sv:base

See the instructions for this in the prior example.

## Build cd/bsv-bitcoin-sv:debug

```sh
$ docker build -t cd/bsv-bitcoin-sv:debug -f Dockerfile.debug .
```
This will build cd/bsv-bitcoin-sv:debug which contains the desired executeables with debug symbols and no optimization.  It will also install some tools of debuggery. This gives us a larger image.

The prior steps built the images and are only needed when you first clone the repo or make any changes to the Dockerfiles thereafter.  It is however harmless to run these again.  But after the images are built, it's time to run the bsv-bitcoin-sv:debug image.

From a shell window on the host there are basically two choices for running the container:

Choice A:
```sh
$ docker run -it --rm --privileged cd/bsv-bitcoin-sv:debug
```
This will run the bsv-bitcoin-sv:debug container but will not mount any data directory from the host.  Instead, the container will create its own ephemeral datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. We need the --privileged flag to make the debugger work. Everything in the container will run as root.

This is a good choice if we're not working on real data and we just want to look at the operation of the program.


Choice B:
```sh
$ export DATADIR=/some/path/to/.bitcoin
$ docker run -it --rm --privileged --mount type=bind,source=$DATADIR,destination=/.bitcoin cd/bsv-bitcoin-sv:debug
```
This will run the bsv-bitcoin-sv:debug container and mount the given directory to the container, for use as BitcoinSV's datadir. Everything is also run as root and in doing so our datadir will get chowned to root and you'll need to rechown it later.  This is a nasty "feature" that arises because of installing the software first as root, when we build the container, and then trying to run the container to use the current host's user.  Doing so does not compute.

For either choice, once inside the container...

```sh
$ gdbgui -r "src/bitcoind -printtoconsole -rpcuser=user -rpcpassword=password"
```
The enables gdbgui to invoke gdb which will load src/bitcoind and get it ready to run.  Gdugui will print a log message saying "View gdbgui at http://nn.nn.nn.nn:5000"  From your browser of choice on the host system, browse to that address.  There it is!

To help you get started with debugging, go to the bottom of the browser where you see "enter gdb command".  Type **b main** This means to break at the entry of the main function.  Next, type **start**  this "starts" bitcoind.  I'll let you contemplate the subtleties of what that actually means.  Better type, type **s** (for step).  Then doit again and again.. Now you're walking through the code!

Look around the window and see what else you can do with this.

In the upper right corner, look for a button that is tooltipped "send interrupt signal (SIGINT)"  This is how you turn off the bitcoind program.  Then CTRL-C in the container window to turn off gdbgui.  Then 'exit'.

[RTFM re: GDB](https://www.gnu.org/software/gdb/) and learn how to fly with the eagles.

# Thanks Tom!

If you find this useful please consider supporting us either via [Patreon](https://patreon.com/coinkit) or our tip jar

bsv:qqcm23jjtsf84gwn6t3f7u4te9llvr76tq46ga9u2c
