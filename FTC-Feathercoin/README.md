# Getting Started

The container built by this Dockerfile contains feathercoind and feathercoin-cli only.  No QT GUI, testing, benchmarks, etc.
The feathercoin tests will be run during the build, but in order to control bloat, the final image will not have any testing in it.

In addition to the container we also create a DATADIR on the host filesystem.  We later connect the DATADIR to the container as a data volume in such a way as to avoid damaging file permissions of the files on the host.

## Build the container

```sh
git clone https://github.com/bostontrader/crypto-docker
cd crypto-docker/FTC-Feathercoin
docker build -t crypto-docker-ftc --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```
This build command feeds the present user id and group id into the docker build process.  The Dockerfile will
create user ftcuser with the given user id and a group for this user in the container.  The purpose of these maneuvers
is to enable us to mount a directory from the host system in the running container as a data volume without damaging 
their file permissions.  (This assumes that the USER_ID and GROUP_ID used when we build the image is the same
that we use when we run the container.)


## Using the container

Execute the following, on the host system, in order to start the container.

```sh
export DATADIR=/path/to/.feathercoin
docker run -it --rm --mount type=bind,source=$DATADIR,destination=/home/ftcuser/.feathercoin crypto-docker-ftc
```
This command will give you a shell into the container where you can then execute the ordinary feathercoind and feathercoin-cli commands.
When doing so you will be logged in as user=ftcuser and the datadir in the container is /home/ftcuser/.feathercoin.

Some example commands:

```sh
feathercoind -printtoconsole -rpcuser=exampleUser -rpcpassword=examplePassword
feathercoind -rpcuser=exampleUser -rpcpassword=examplePassword -daemon
feathercoin-cli -rpcuser=exampleUser -rpcpassword=examplePassword help
```

