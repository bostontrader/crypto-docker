# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker
$ cd crypto-docker/BTX-Bitcore
$ docker build -t crypto-docker-btx . 
$ mkdir /home/batman/.bitcore
$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.bitcore,destination=/root/.bitcore crypto-docker-btx
$ docker run -it --rm -p 5900 crypto-docker-btx
```
Note: Unless your username really is batman, you may want to tweak these examples

The prior step creates and runs a container and gives you a command prompt on it.  From that prompt:

```sh
$ . /entrypoint.sh
$ bbccoin-qt &
$ x11vnc -display :1 -usepw
```
entrypoint.sh sets a machine id and then sets up Xvfp so that bbccoin-qt can use it.
Next, execute bbccoin-qt in demonic mode (see the trailing &)
Finally, execute x11vnc so that we can see Litecoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.

Next, 
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypt-docker-bqc** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.  Recall that you'll need the password you set for x11vnc earlier.

# Tip Jar
bqc: bNPKqpFwZTcQUchFRUPdaYVLfThJheY5WV


