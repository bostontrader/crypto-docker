# Introduction
For those of you who have ever attempted to build a wallet/GUI for any of the crypto coins, I make this humble offering.

If you already know your way around the Unix build process, it's occasionally not so bad to just RTFM and build a wallet.  [But...](https://www.youtube.com/watch?v=FaVFuX8z26c),

```sh
if(
  (you are a n00b && this process is challenging) ||
  (you are trying to build/maintain wallets for several coins && you begin to notice incompatibilities between dependencies) ||
  (your ever advancing *nix version is causing earlier built executables, or their build processes, to fail)
)
```
Then perhaps these dockerfiles may earn their keep.


# Getting Started
```sh
$ git clone https://github.com/bostontrader/crypto-docker.git
$ cd crypto-docker
```
This directory contains several files that start with 'Dockerfile' and have some coin symbol or other identifier as a suffix.  If you find the Dockerfile that corresponds to the coin that you want a GUI for then build a docker image from that dockerfile.

As an example, let's build an image for the GUI for Unobtanium.  The dockerfile we want is DockerfileUNO and let's name the image 'crypto-docker-uno' 
```sh
$ docker build -t crypt-docker-uno - < DockerfileUNO 
```
When building the docker image be aware that you may need to use sudo.

# Digging Deeper

These Dockerfiles build images that support the basic QT GUI.  They don't support upnp or zmq notifications simply because I never use these things and haven't bothered to put them in here.  But they'd be easy enough to add. In dealing with this image, there are a few important issues to consider.

1. Run as Root
2. wallet.dat
3. How to see the GUI.

## Run as Root

The software will build and run as root.  If you intend to use this for serious money then I suggest you take a closer look at this.

## wallet.dat

Where is wallet.dat?  To make a long story short, I'll simply suggest that you find a place on your host system where you want the wallet to be and then link to that when you run the container.  

For example:
**--mount type=bind,source=/home/batman/.bitcore,destination=/root/.bitcore**
If you use this option when you run the container, reference to the directory /root/.bitcore, inside the container, will get connected to /home/batman/.bitcore on the host system.

# How to see the GUI

The GUI uses X11 and we need to do some contortions to get X11 out of the container.  One way to do that is to use a VNC viewer on your host system to connect to the X11 output port from the container.  By default VNC uses port 5900 and we need to use the option -p 5900 in order to expose this port, from inside the container. We then must use some methods of choice to determine which random port Docker uses on the host.
docker ps is a good choice because it shows this information.


# All Together Now

Given [all this new learning...](https://www.youtube.com/watch?v=KrD16CBEJRs)

docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.bitcore,destination=/root/.bitcore rad-docker-bitcore


# Tip Jar
bitcore: 197uE6hykxaow7jbGiEv41wmcHV5TCjV9R
