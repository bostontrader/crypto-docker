# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker
$ cd crypto-docker/Unobtanium
$ docker build -t crypto-docker-uno . 
$ mkdir /home/batman/.unobtanium
$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.unobtanium,destination=/root/.unobtanium crypto-docker-uno
```
Note: Unless your username really is batman, you may want to tweak these examples


```
This will run the example image **crypt-docker-uno** and make its X11 available via port 5900.
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypt-docker-uno** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.

The viewer will demand a password and that password is hardwired into the original Dockerfile

# Tip Jar

