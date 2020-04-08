The software for this coin is based on Ubuntu 18.04.  If we try this with Alpine we get a segfault in secp256k1.

Even though we can successfully build and execute this software, the tests fail.

Anything we can do with this coin can be done using clamd and clam-cli.  It's much easier to just figure these out than it is to deal with building the GUI and trying to get its X video out of the docker container securely.  Hence, no GUI edition here.

## 1. Build cd/clam-clamcoin:base

From a shell window on the host in a suitable directory:

```sh
git clone https://github.com/bostontrader/crypto-docker.git
cd crypto-docker/2020/clam-clamcoin
docker build -t cd/clam-clamcoin:base -f Dockerfile.base \
  --build-arg SOURCE_ORIGIN=https://github.com/nochowderforyou/clams.git \
  --build-arg SOURCE_LOCAL_ROOT=/clams \
  --build-arg COMMIT=471782c \
  .
```

This will build the base image for this coin, based on a specific commit that is known to be useable, probably tagged with the 2.1.0 tag, and dated about Mar 12, 2020.


## 2. Build cd/clam-clamcoin:cli

```sh
docker build -t cd/clam-clamcoin:cli -f Dockerfile.cli .
```
This will build cd/clam-clamcoin:cli which contains only clamd and clam-cli, optimized and devoid of debug symbols. Nothing else.

Next, run the cd/clam-clamcoin:cli image.

From a shell window on the host...

```sh
export DATADIR=/some/path/to/.clam
docker run -it --rm -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.clam cd/clam-clamcoin:cli
```

This will run the cd/clam-clamcoin:cli container and mount the given directory from the host filesystem into the container, for use as Clam's datadir.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.clam must already exist, docker won't create it for you.

Once inside the container...

```sh
clamd -printtoconsole -rpcuser=user -rpcpassword=password -daemon
clam-cli -rpcuser=user -rpcpassword=password <some cli command>
```

This turns on clamd in daemon mode which then allows us to invoke clam-cli in order to control it.


# Thanks Tom!

If you find this useful please consider contributing to our tip jar

clam: xHHiaUP4VQE51ERpRorxVoKS3U83P3n1pw
