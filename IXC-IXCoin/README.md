# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker
$ cd crypto-docker/IXC-IXCoin
$ docker build -t crypto-docker-ixc . 
$ mkdir /home/batman/.ixcoin
$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.ixcoin,destination=/root/.ixcoin crypto-docker-ixc

```
Note: Unless your username really is batman, you may want to tweak these examples

The prior step creates and runs a container and gives you a command prompt on it.  From that prompt:

```sh
$ . /entrypoint.sh
$ ixcoin-qt &
$ x11vnc -display :1 -usepw
```
entrypoint.sh sets a machine id and then sets up Xvfp so that ixcoin-qt can use it.
Next, execute ixcoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see ixcoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.

Next, 
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypt-docker-ixc** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.  Recall that you'll need the password you set for x11vnc earlier.

# Tip Jar
ixq: xezhfifgcbuzUWWai36PUvVCz1iFkRM4kU


