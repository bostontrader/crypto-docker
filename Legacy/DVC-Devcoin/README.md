# Getting Started

The container built by this Dockerfile contains the executables built by the Devcoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/DVC-Devcoin
docker build -t crypto-docker-dvc . 
```

## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.devcoin
docker run -it --rm -p 5900:5900 -e UID=$(id -u) -e GID=$(id -g) --mount type=bind,source=$DATADIR,destination=/.devcoin crypto-docker-dvc
```
This command will give you a shell into the container.  It will also expose port 5900 of the container, to port 5900 on the host, which is how we will use an external viewer to view the GUI, if any, from this container.  It will also pass the present user's UID and GID to the container, which we need to do in order to not fubar the file permissions of the DATADIR.

Next, we need to add the user and group to be used to run the software.

From the container command line:
```sh
export USERNAME=devcoin
export GROUPNAME=devcoin
export DATADIR=/.devcoin
groupadd --gid $GID $GROUPNAME
useradd --uid $UID --gid $GID $USERNAME
mkdir /home/$USERNAME
chown $USERNAME:$GROUPNAME /home/$USERNAME
chown $USERNAME:$GROUPNAME $DATADIR
su $USERNAME
```

These gyrations setup a user and group in the container, that match the host, lest we fubar the file permissions of the DATADIR. Recall that the file permissions only care about the numeric user and group ids.  Nevertheless, we have to name this user and group _something_.  We care about the home directory because x11vnc will otherwise complain.  Let's placate it.  Be reasonable.  Do it x11vnc's way.


### devcoind

If you want to use devcoind, from the container command line:
```sh
devcoind -printtoconsole -datadir=$DATADIR -rpcuser=exampleUser -rpcpassword=examplePassword
```


### devcoin-qt

And if you want to use the GUI, from the container command line:
```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
devcoin-qt -datadir=$DATADIR &
x11vnc -display :1 -usepw
```

This sets things up so that devcoin-qt thinks it has a display that it can work with.
Then we execute devcoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see devcoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.  Then connect to 127.0.0.1:5900.  Recall that you'll need the password you set for x11vnc earlier.

These things will probably emit spurious warnings.  Ignore them.  For extra credit, feel free to figure out how to get rid of these warnings.

# Tip Jar

dvc: 1Jf3K4Zm8Jork2EvwrvCyCCmew2tcpM1jv
