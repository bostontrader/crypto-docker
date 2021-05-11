# Getting Started

The container built by this Dockerfile contains clamd and clam-cli only.  No QT GUI, testing, benchmarks, etc.
The clam tests sould be run during the build, but said tests don't work so we don't run them.

In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume in such a way as to avoid damaging file permissions of the files on the host.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/CLAM-Clamcoin
docker build -t crypto-docker-clam --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```
This build command feeds the present user id and group id into the docker build process.  The Dockerfile will
create user clamuser with the given user id and a group for this user in the container.  The purpose of these maneuvers
is to enable us to mount a directory from the host system in the running container as a data volume without damaging 
their file permissions.  (This assumes that the USER_ID and GROUP_ID used when we build the image is the same
that we use when we run the container.)


## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/.clam
docker run -it --rm --mount type=bind,source=$DATADIR,destination=/home/clamuser/.clam crypto-docker-clam
```
This command will give you a shell into the container where you can then execute the ordinary clamd and clam-cli commands.
When doing so you will be logged in as user=clamuser and the datadir in the container is /home/clamuser/.clam.

Some example commands:

```sh
clamd -printtoconsole -rpcuser=exampleUser -rpcpassword=examplePassword
clamd -rpcuser=exampleUser -rpcpassword=examplePassword -daemon
clam-cli -rpcuser=exampleUser -rpcpassword=examplePassword help
```

