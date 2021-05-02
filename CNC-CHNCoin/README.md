# Getting Started

The container built by this Dockerfile contains chncoin-qt only.  No command line tools, testing, etc.

In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume in such a way as to avoid damaging file permissions of the files on the host.

In order for this to work we use xvfb so that chncoin-qt has a simulated X11 to talk to and x11vnc to enable X11 to
communicate with an external VNC viewer.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/CNC-CHNCoin
docker build -t crypto-docker-cnc --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```
This build command feeds the present user id and group id into the docker build process.  The Dockerfile will
create user chnuser with the given user id and a group for this user in the container.  The purpose of these maneuvers
is to enable us to mount a directory from the host system in the running container as a data volume without damaging 
their file permissions.  (This assumes that the USER_ID and GROUP_ID used when we build the image is the same
that we use when we run the container.)


## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/.chncoin
docker run -it --rm -p 5900:5900 --mount type=bind,source=$DATADIR,destination=/home/chnuser/.chncoin crypto-docker-cnc
```
This command will give you a shell into the container where you can then execute chncoin-qt.  The ordinary coind and coin-cli commands are not available.
When doing so you will be logged in as user=chnuser and the datadir in the container is /home/chnuser/.chncoin.

It will also expose port 5900 of the container, to port 5900 on the host, which is how we will use an external VNC viewer to view the GUI from this container.

Note: /somepath/to/.chncoin must already exist, docker won't create it for you.

Once inside the container...

```sh
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x16 &
./chncoin-qt &
x11vnc -display :1 -usepw
```
You may see some info messages and warnings from Xvfb. Ignore them.
-qt may complain "No systemtrayicon available". Ignore it.
This sets things up so that chncoin-qt thinks it has a display that it can work with.
Then we execute chncoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see chncoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.


Finally, run your VNC viewer of choice and connect to localhost:5900. Recall that you'll need the password you set for x11vnc earlier.

