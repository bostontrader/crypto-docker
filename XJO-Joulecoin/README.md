# Getting Started

The container built by this Dockerfile contains the executables built by the Joulecoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

For ordinary production use, to produce a container of minimum size:

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/XJO-Joulecoin
docker build -t crypto-docker-xjo .
```

If you would like to be able to connect to software inside this container, using gdb and gdbgui, from the host system, change the above build command to:

```sh
docker build -t crypto-docker-xjo-debug . --build-arg debug=true
```

## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.joulecoin
docker run -it --rm -p 5900:5900 -e UID=$(id -u) -e GID=$(id -g) --mount type=bind,source=$DATADIR,destination=/.joulecoin crypto-docker-xjo
```
The prior command will give us a shell into the container.  It will also expose port 5900 of the container, to port 5900 on the host, which is how we will use an external viewer to view the GUI, if any, from this container.  It will also pass the present host system's user's UID and GID to the container, which we need to do in order to not fubar the file permissions of the DATADIR.

### Container prep

Once inside the container, we need to add the user and group to be used to run the software, to the container, jump through various hoops to make it useable and then su to that user.

From the container command line:
```sh
export USERNAME=joulecoin
export GROUPNAME=joulecoin
export DATADIR=/.joulecoin
groupadd --gid $GID $GROUPNAME
useradd --uid $UID --gid $GID $USERNAME
mkdir /home/$USERNAME
chown $USERNAME:$GROUPNAME /home/$USERNAME
chown $USERNAME:$GROUPNAME $DATADIR
su $USERNAME
```

These gyrations setup a user and group in the container, that match the host, lest we fubar the file permissions of the DATADIR. Recall that the file permissions only care about the numeric user and group ids.  Nevertheless, we have to name this user and group _something_.  We care about the home directory because x11vnc will otherwise complain.  Let's appease it.  Be reasonable.  Do it x11vnc's way.


### joulecoind

If you want to use joulecoind, from the container command line:
```sh
joulecoind -printtoconsole -datadir=$DATADIR -rpcuser=exampleUser -rpcpassword=examplePassword
```


### joulecoin-qt

If you want to use the QT GUI, from the container command line:
```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
joulecoin-qt -datadir=$DATADIR &
x11vnc -display :1 -usepw
```

This sets things up so that joulecoin-qt thinks it has a display that it can work with.
Then we execute joulecoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see joulecoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.  Then, from the VNC viewer on the host, connect to 127.0.0.1:5900.  Recall that you'll need the password you set for x11vnc earlier.

These things will probably emit spurious warnings.  Ignore them.  For extra credit, feel free to figure out how to get rid of these warnings.


### gdbgui

You can execute this software under the control of gdb using a handy tool called [gdbgui.](https://gdbgui.com/)  As an example for debugging the operation of joulecoind:

1. Build the docker file in debug mode.

2. Execute the following, on the host system, in order to start the debug container.

```sh
export DATADIR=/path/to/datadir/.joulecoin
docker run -it --rm -p 5000:5000 -p 5900:5900 -e UID=$(id -u) -e GID=$(id -g) --mount type=bind,source=$DATADIR,destination=/.joulecoin crypto-docker-xjo
```

Notice addition of port 5000.  This is the default port for gdbgui and it's how we'll see it from outside the container.

3. Once inside the debug container, execute the commands from "Container prep" infra.

4. Instead of executing joulecoind directly:

```sh
gdbgui -r "joulecoind -printtoconsole -datadir=$DATADIR -rpcuser=exampleUser -rpcpassword=examplePassword"
```

5. Crank up your browser of choice on the host system and go to http://localhost:5000


# Tip Jar

xjo: JhkSyR8HVxMANB6PLAKuQeutQqfWRXBYeY
