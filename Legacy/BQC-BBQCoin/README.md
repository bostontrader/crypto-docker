# Getting Started

The container built by this Dockerfile contains the executables built by the BBQCoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/Legacy/BQC-BBQCoin
docker build -t crypto-docker-bqc --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```
This build command feeds the present user id and group id into the docker build process.  The Dockerfile will
create user bcquser with the given user id and a group for this user in the container.  The purpose of these maneuvers
is to enable us to mount a directory from the host system in the running container as a data volume without damaging 
their file permissions.


## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/.bbqcoin
docker run -it --rm --mount type=bind,source=$DATADIR,destination=/home/bcquser/.bbqcoin crypto-docker-bqc
```
This command will give you a shell into the container where you can then execute the ordinary bbqcoind commands.
When doing so you will be logged in as user=bqcuser and the datadir in the container is /home/bqcuser/.bbqcoin.


### bbqcoind

If you want to use bbqcoind, from the container command line:
```sh
bbqcoind -printtoconsole -rpcuser=exampleUser -rpcpassword=examplePassword -rpcallowip=0.0.0.0
```

You'll probably need to the rpcallowip flag to avoid a tedious port binding issue.

# Tip Jar

My palatial retirement home in the mountains needs a few more coins to implement.  Please help me realize my dream:

bqc: bNPKqpFwZTcQUchFRUPdaYVLfThJheY5WV
