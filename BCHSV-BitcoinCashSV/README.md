# Getting Started

The container built by this Dockerfile contains the command-line executables built by the BitcoinSV source code.  BitcoinSV doesn't have any GUI.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.  

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/BCHSV-BitcoinCashSV
docker build -t crypto-docker-bchsv . 
```

## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.bitcoin
docker run -it --rm -p 5900:5900 -e UID=$(id -u) -e GID=$(id -g) --mount type=bind,source=$DATADIR,destination=/.bitcoin crypto-docker-bchsv
```

This command will give you a bash shell into the container.  It will also expose port 5900 of the container, to port 5900 on the host, which is how we will use an external viewer to view the GUI, if any, from this container.  It will also pass the present user's UID and GID to the container, which we need to do in order to not fubar the file permissions of the DATADIR.

Next, we need to add the user and group to be used to run the software, to the container.  Jump through various hoops to make it useable and then su to that user.

From the container command line:
```sh
export USERNAME=bitcoin
export GROUPNAME=bitcoin
export DATADIR=/.bitcoin
groupadd --gid $GID $GROUPNAME
useradd --uid $UID --gid $GID $USERNAME
chown $USERNAME:$GROUPNAME $DATADIR
su $USERNAME
```

These gyrations setup a user and group in the container, that match the host, lest we fubar the file permissions of the DATADIR. Recall that the file permissions only care about the numeric user and group ids.  Nevertheless, we have to name this user and group _something_.


### bitcoind

If you want to use bitcoind, from the container command line:
```sh
bitcoind     -datadir=$DATADIR -rpcuser=exampleUser -rpcpassword=examplePassword &
bitcoin-cli  -datadir=$DATADIR -rpcuser=exampleUser -rpcpassword=examplePassword whatever-command
```


### bitcoin-qt

There is no GUI, so the instructions here are rather simple.

bchsv: 


