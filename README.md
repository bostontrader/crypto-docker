# Introduction
For those of you who have ever attempted to build a wallet/GUI for any of the crypto coins, I make this humble offering.

If you already know your way around the Unix build process, it's occasionally not so bad to just RTFM and build a wallet.  [But...](https://www.youtube.com/watch?v=FaVFuX8z26c),

```sh
if {
  (you are a n00b && this process is challenging) ||
  (you are trying to build/maintain wallets for several coins && you begin to notice incompatibilities between dependencies) ||
  (your ever advancing *nix version is causing earlier built executables, or their build processes, to fail)
}
```
Then perhaps these dockerfiles may earn their keep.


# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker
```
This directory contains several subdirectories, one for each supported coin. Inside each directory is a Dockerfile and associated any relevant documentation or extras.

As an example, let's build an image for the GUI for Unobtanium and name the image 'crypto-docker-uno' 
```sh
$ cd Unobtanium
$ docker build -t crypto-docker-uno .   <- notice the ending dot. 
```
When building the docker image be aware that you may need to use sudo.

# Digging Deeper

These Dockerfiles build images that support the basic QT GUI.  They don't support upnp or zmq notifications simply because I never use these things and haven't bothered to put them in here.  But they'd be easy enough to add. In dealing with these images, there are a few important issues to consider.

1. Run as Root
2. wallet.dat
3. How to see the GUI.

## 1. Run as Root

The software will build and run as root.  If you intend to use this for serious money then I suggest you take a closer look at this.

## 2. wallet.dat

Where is wallet.dat?  To make a long story short, I'll simply suggest that you find a place on your host system where you want the wallet to be and then link to that when you run the container.

For example:
**--mount type=bind,source=/home/batman/.unobtanium,destination=/root/.unobtanium**
If you use this option when you run the container, reference to the directory /root/.unobtanium, inside the container, will get connected to /home/batman/.unobtanium on the host system.

# 3. How to see the GUI

The GUI uses X11 and we need to do some contortions to get X11 out of the container.  One way to do that is to use a VNC viewer on your host system to connect to the X11 output port from the container.  By default VNC uses port 5900 and we need to use the option -p 5900 in order to expose this port, from inside the container. We then must use some methods of choice to determine which random port Docker uses on the host.
docker ps is a good choice because it shows this information.


# All Together Now

Given [all this new learning...](https://www.youtube.com/watch?v=KrD16CBEJRs)
```sh
$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.unobtanium,destination=/root/.unobtanium crypto-docker-uno
```
This will run the example image **crypt-docker-uno** and make its X11 available via port 5900.
```sh
$ docker ps
```
This will give you a display of all your running containers.  Hopefully you'll see **crypt-docker-uno** and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost.  For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768.

The viewer will demand a password and that password is hardwired into the original Dockerfile.
# Tip Jar
ETH: 0x17054e20B4498d4861A628DD0054FfA1F7006029
bitcore: 197uE6hykxaow7jbGiEv41wmcHV5TCjV9R
