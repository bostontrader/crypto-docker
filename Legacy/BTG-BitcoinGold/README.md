# Getting Started

The container built by this Dockerfile contains the executables built by the BitcoinGold source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume. Recall that this coin is a fast-n-dirty clone from bitcoin so references to .bitcoin or bitcoin-qt in this document are not errors.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/BTG-BitcoinGold
docker build -t crypto-docker-btg . 
```

## Using the container

There are two basic method of usage: 1) shell commands, 2) GUI.

All of the BitCoinGold executables _except_ for bitcoin-qt are command-line things that can be run from a shell.  Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.bitcoingold
docker run -it --rm -p 5900 --mount type=bind,source=$DATADIR,destination=/root/.bitcoingold crypto-docker-btg
```
This command will give you a shell into the container.  It will also expose port 5900 to the outside world which is how we will use an external viewer to view the GUI, if any, from this container.


```sh
bgoldd -printtoconsole
```

...would be a good starting exercise.

If you would like the GUI:

From the container command line:

```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
bitcoin-qt &
x11vnc -display :1 -usepw
```

This sets things up so that bitcoin-qt thinks it has a display that it can work with.
Then we execute bitcoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see bitcoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.

Next, from a shell on the host: 
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypto-docker-btg** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port at 127.0.0.1.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.  Recall that you'll need the password you set for x11vnc earlier.

# Berkeley db

Many crypto-coin clients use the Berkeley dbv4.8 library for their wallets. This is an ancient version of the software and requires ridiculous contortions to use. Therefore this software abandons this dependency in favor of a more modern version of the db (5.3).

# Tip Jar

btg: GakaVrHCgyyUcoBjGrQg1wyharq1UbbPGV
