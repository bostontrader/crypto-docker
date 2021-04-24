# Getting Started

The container built by this Dockerfile contains peercoind and peercoin-cli only.  No QT GUI, testing, benchmarks, etc.
  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume in such a way as to avoid damaging file permissions of the files on the host.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/PPC-Peercoin
docker build -t crypto-docker-ppc --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```
This build command feeds the present user id and group id into the docker build process.  The Dockerfile will
create user ppcuser with the given user id and a group for this user in the container.  The purpose of these maneuvers
is to enable us to mount a directory from the host system in the running container as a data volume without damaging 
their file permissions.  (This assumes that the USER_ID and GROUP_ID used when we build the image is the same
that we use when we run the container.)


## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/.peercoin
docker run -it --rm --mount type=bind,source=$DATADIR,destination=/home/ppcuser/.peercoin crypto-docker-ppc
```
This command will give you a shell into the container where you can then execute the ordinary peercoind and peercoin-cli commands.
When doing so you will be logged in as user=ppcuser and the datadir in the container is /home/ppcuser/.peercoin.

Some example commands:

```sh
peercoind -printtoconsole -rpcuser=exampleUser -rpcpassword=examplePassword
peercoind -rpcuser=exampleUser -rpcpassword=examplePassword -daemon
peercoin-cli -rpcuser=exampleUser -rpcpassword=examplePassword help
```

