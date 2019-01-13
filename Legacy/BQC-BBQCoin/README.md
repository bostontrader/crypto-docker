# Getting Started

The container built by this Dockerfile contains the executables built by the bbqcoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/BQC-BBQCoin
docker build -t crypto-docker-bqc . 
```

## Using the container

There are two basic method of usage: 1) shell commands, 2) GUI.

All of the bbqcoin executables _except_ for bbqcoin-qt are command-line things that can be run from a shell.  Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.bbqcoin
docker run -it --rm -p 5900 --mount type=bind,source=$DATADIR,destination=/root/.bbqcoin crypto-docker-bqc
```

You now have a shell prompt in the container and you may thence run wild.  Perhaps ...

```sh
BBQCoin/src/bbqcoind -printtoconsole
```

...would be a good starting exercise.

If you would like the GUI:

From the container command line:

```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
BBQCoin/bbqcoin-qt &
x11vnc -display :1 -usepw
```
You may see some info messages and warnings from Xvfb. Ignore them.
bbqcoint-qt may complain "No systemtrayicon available". Ignore it.
This sets things up so that bbqcoin-qt thinks it has a display that it can work with.
Then we execute bbqcoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see bbqcoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.

Next, from a shell on the host: 
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypto-docker-bqc** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port at 127.0.0.1.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.  Recall that you'll need the password you set for x11vnc earlier.

# Tip Jar
bqc: bNPKqpFwZTcQUchFRUPdaYVLfThJheY5WV


