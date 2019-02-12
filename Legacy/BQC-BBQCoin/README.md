# Getting Started

The container built by this Dockerfile contains the executables built by the BQC-BBQCoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/Legacy/BQC-BBQCoin
docker build -t crypto-docker-bqc . 
```

## Using the container

There are two basic method of usage: 1) shell commands, 2) GUI.

All of the bbqcoin executables _except_ for bbqcoin-qt are command-line things that can be run from a shell.  Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/.bbqcoin
docker run -it --rm -p 5900:5900 -e UID=$(id -u) -e GID=$(id -g) --mount type=bind,source=$DATADIR,destination=/.bbqcoin crypto-docker-bqc
```
This command will give us a shell into the container. It will also expose port 5900 of the container, to port 5900 on the host, which is how we will use an external viewer to view the GUI, if any, from this container. It will also pass the present host system's user's UID and GID to the container, which we need to do in order to not fubar the file permissions of the DATADIR.

Note: /somepath/to/.bbqcoin must already exist, docker won't create it for you.

Once inside the container...

```sh
export USERNAME=bbqcoin
export GROUPNAME=bbqcoin
export DATADIR=/.bbqcoin
groupadd --gid $GID $GROUPNAME
useradd --uid $UID --gid $GID $USERNAME
mkdir /home/$USERNAME
chown $USERNAME:$GROUPNAME /home/$USERNAME
chown $USERNAME:$GROUPNAME $DATADIR
su $USERNAME
```
When the image was run, using the earlier command, it received the numeric UID and GID of the host system's presently logged in user.  The newly started container starts as root.  Given root's permissions, it may then create a new user and group with the same numeric ids.  We also assign an arbitrary USERNAME and GROUPNAME for use by this new user and group.

We need the numeric IDs so that we can avoid harming the file permissions of the data volume, from the POV of the host system.

We need the user and group names because the chown command needs them.  Finally, we need a home directory because the x11vnc program needs it in order to store configuration information.


At this point we have a shell prompt in the container and are running as a user with the same uid and gid as the host system's user that ran the image.  You may now run wild.  Perhaps ...

```sh
BBQCoin/src/bbqcoind -datadir=$DATADIR -printtoconsole
```

...would be a good starting exercise.

If you would like the GUI:

From the container command line:

```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
BBQCoin/bbqcoin-qt -datadir=$DATADIR &
x11vnc -display :1 -usepw
```
You may see some info messages and warnings from Xvfb. Ignore them.
bbqcoint-qt may complain "No systemtrayicon available". Ignore it.
This sets things up so that bbqcoin-qt thinks it has a display that it can work with.
Then we execute bbqcoin-qt, pointing to the correct DATADIR, in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see bbqcoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.


Finally, run your VNC viewer of choice and connect to localhost:5900. Recall that you'll need the password you set for x11vnc earlier.

# Tip Jar
bqc: bNPKqpFwZTcQUchFRUPdaYVLfThJheY5WV


