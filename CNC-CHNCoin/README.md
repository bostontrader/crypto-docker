# Introduction

CHNCoin aka CNC died and was brought back to life by [RoadTrain](https://github.com/RoadTrain/CHNCoin) The docker image built by this Dockerfile uses that source code.  If you try to build from the original source code, you will probably be unable to sync.  There is a [discussion thread](https://bitcointalk.org/index.php?topic=322488.0) about the resurection.  You can [find the nodes](https://chainz.cryptoid.info/cnc/#!network) that you will need to get started with the sync. (click the 'node list') button.


# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker
$ cd crypto-docker/CNC-CHNCoin
$ docker build -t crypto-docker-cnc . 
$ mkdir /home/batman/.chncoin
$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.chncoin,destination=/root/.chncoin crypto-docker-cnc
```
Note: Unless your username really is batman, you may want to tweak this example.  And recall that the mount option wants absolute paths.

The prior step creates and runs a container and gives you a command prompt on it.  From that prompt:

```sh
$ . /entrypoint.sh
$ ./chncoin-qt -addnode=217.175.119.125 -addnode=157.161.128.62 -addnode=178.238.224.213 -addnode=192.0.244.116 &
$ x11vnc -display :1 -usepw
```
entrypoint.sh sets a machine id and then sets up Xvfp so that CHNCoin-qt can use it. Notice the leading '.' Doing this will execute the entrypoint.sh in the context of the calling shell.  We need to do this because the script will set the DISPLAY enviornment variable and we want it to stay set.

Next, execute chncoin-qt in demonic mode (see the trailing &)  This example contains initial nodes that worked for me at the time of writing. You may need to find other nodes by the time you read this.

Finally, execute x11vnc so that you can see CHNCoin-qt from a VNC viewer on the host.  When this first runs, it will ask for a password.  You'll need this password in your VNC viewer.

Next, in a 2nd shell...
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypt-docker-cnc** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.  Recall that you'll need the password you set for x11vnc earlier.

# Tip Jar

CNC: CLFSf9WBHcFRaQ74P4AM647kjvdEFancmi
