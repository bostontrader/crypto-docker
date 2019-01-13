# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker
$ cd crypto-docker/TRC-Terracoin
$ docker build -t crypto-docker-trc . 
$ mkdir /home/batman/.terracoincore
$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.terracoincore,destination=/root/.terracoincore crypto-docker-trc
```
Note: Unless your username really is batman, you may want to tweak this example.  And recall that the mount option wants absolute paths.

The prior step creates and runs a container and gives you a command prompt on it.  From that prompt:

```sh
$ . /entrypoint.sh    <- notice the leading dot and space!
$ terracoin-qt &
$ x11vnc -display :1 -usepw
```
Notice the leading '. ' for entrypoint.  Doing this will execute the entrypoint.sh in the context of the calling shell.  We need to do this because the script will set the DISPLAY enviornment variable and we want it to stay set.

Next, execute terracoin-qt in demonic mode (see the trailing &)


Finally, execute x11vnc so that you can see terracoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  Invent any password you like.  You'll need this password in your VNC viewer.


Next, in a 2nd shell...
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypt-docker-trc** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.  Recall that you'll need the password you set for x11vnc earlier.

# Tip Jar

trc: 1G4jBa9aFccRHgtPkM7VgsFXxfSW51JJ3K
