 
Getting Started

$ git clone https://github.com/bostontrader/crypto-docker

$ cd crypto-docker/ERC-Europecoin

$ docker build -t crypto-docker-erc . 

$ mkdir /home/batman/.europecoin

$ docker run -it --rm -p 5900 --mount type=bind,source=/home/batman/.europecoin,destination=/root/.europecoin crypto-docker-erc


Note: 
Unless your username really is batman, you may want to tweak these examples

The prior step creates and runs a container and gives you a command prompt on it. From that prompt:

$ . /entrypoint.sh

$ europecoin-qt &

$ x11vnc -display :1 -usepw


entrypoint.sh sets a machine id and then sets up Xvfp so that europecoin-qt can use it. Next, execute europecoin-qt in demonic mode (see the trailing &) Finally, execute x11vnc so that we can see europecoin-qt from a VNC viewer on the host. When this first runs, it will ask for a password. You'll need this password in your VNC viewer.

Next,

$ docker ps

This will give you a display of all your running containers. Hopefully you'll see crypt-docker-btx and can determine which port on the local host it's using.

Finally, run your VNC viewer of choice and connect to that port on localhost. For example, if you see that port 5900 in the container has been mapped to port 32768 on the host, you would connect to 127.0.0.1:32768. Recall that you'll need the password you set for x11vnc earlier.

This container is derived by Matthias Klees (Europecoin Maintainer), from Bostonstrader's coincontainers inside of crypto-docker. All appreciation and my thanks for his great work, that made it possible for me, to learn from, belongs to him 


I made this container for the integration of EUROPCOIN FINANCECLOUD API and the FINANCECLOUD-DEVICE

INFO:
https://erclab.bitcoinsulting.eu.org/index.php/s/gwP5cjNzqwebMYa


TIP BOSTONTRADER 
for his great work:

ERC: 
