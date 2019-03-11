# Getting Started

The container built by this Dockerfile contains the executables built by the litecoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/LTC-Litecoin
docker build -t crypto-docker-ltc . 
```

## Using the container

There are two basic method of usage: 1) shell commands, 2) GUI.

All of the litecoin executables _except_ for litecoin-qt are command-line things that can be run from a shell.  Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.litecoin
docker run -it --rm -p 5900:5900 --mount type=bind,source=$DATADIR,destination=/.litecoin crypto-docker-ltc
```
 
You now have a shell prompt in the container and you may thence run wild.  Perhaps ...

```sh
litecoind -printtoconsole -datadir=/.litecoin
```
...would be a good starting exercise. This will start litcoind and log to the console and it will use the attached data volume.

If you would like the GUI:

From thecontainer command line:

```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
litecoin-qt -datadir=/.litecoin &
x11vnc -display :1 -usepw
```

This sets things up so that litecoin-qt thinks it has a display that it can work with.
Then we execute litecoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see litecoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.

Finally, run your VNC viewer of choice and connect to 127.0.0.1:5900. Recall that you'll need the password you set for x11vnc earlier.

# Berkeley db

Many crypto-coin clients use the Berkeley dbv4.8 library for their wallets. This is an ancient version of the software and requires ridiculous contortions to use. Therefore this software abandons this dependency in favor of a more modern version of the db (5.3).


# Tip Jar
ltc: Lcr21SUsqCu4u2CzzuwjTsrDbwGEeC7exX

