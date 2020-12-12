# Getting Started

The container built by this Dockerfile contains the executables built by the Devcoin source code.  In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/DVC-Devcoin
docker build -t crypto-docker-dvc --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```
This build command feeds the present user id and group id into the docker build process.  The Dockerfile will
create user dvcuser with the given user id and a group for this user in the container.  The purpose of these maneuvers
is to enable us to mount a directory from the host system in the running container as a data volume without damaging 
their file permissions.


## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/datadir/.devcoin
docker run -it --rm --mount type=bind,source=$DATADIR,destination=/home/dvcuser/.devcoin crypto-docker-dvc
```
This command will give you a shell into the container where you can then execute the ordinary devcoind commands.
When doing so you will be logged in as user=dvcuser and the datadir in the container is /home/dvcuser/.devcoin.



### devcoind

If you want to use devcoind, from the container command line:
```sh
devcoind -printtoconsole -rpcuser=exampleUser -rpcpassword=examplePassword
```

# Tip Jar

dvc: 1Jf3K4Zm8Jork2EvwrvCyCCmew2tcpM1jv
