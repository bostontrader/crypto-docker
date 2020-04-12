The software for this coin is based on Alpine 3.11.

Anything we can do with this coin can be done using litecoind and litecoin-cli.  It's much easier to just figure these out than it is to deal with building the GUI and trying to get its X video out of the docker container securely.  Hence, no GUI edition here.

## 1. Build cd/ltc-litecoin:base

From a shell window on the host in a suitable directory:

```sh
git clone https://github.com/bostontrader/crypto-docker.git
cd crypto-docker/2020/LTC-Litecoin
docker build -t cd/ltc-litecoin:base -f Dockerfile.base \
  --build-arg SOURCE_ORIGIN=https://github.com/litecoin-project/litecoin \
  --build-arg SOURCE_LOCAL_ROOT=/litecoin \
  --build-arg COMMIT=8995c4 \
  .
```

This will build the base image for this coin, based on a specific commit that is known to be useable, dated April 2019.


## 2. Build cd/ltc-litecoin:cli

```sh
docker build -t cd/ltc-litecoin:cli -f Dockerfile.cli .
```
This will build cd/ltc-litecoin:cli which contains only litecoind and litecoin-cli, optimized and devoid of debug symbols. Nothing else.

Next, run the cd/ltc-litecoin:cli image.

From a shell window on the host...

```sh
export DATADIR=/some/path/to/.litecoin
docker run -it --rm -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.litecoin cd/ltc-litecoin:cli
```

This will run the cd/ltc-litecoin:cli container and mount the given directory from the host filesystem into the container, for use as the DATADIR.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.litecoin must already exist, docker won't create it for you.

Once inside the container...

```sh
litecoind -printtoconsole -rpcuser=user -rpcpassword=password -daemon
litecoin-cli -rpcuser=user -rpcpassword=password <some cli command>
```

This turns on litecoind in daemon mode which then allows us to invoke litecoin-cli in order to control it.


# Thanks Tom!

If you find this useful please consider contributing to our tip jar

ltc: Lcr21SUsqCu4u2CzzuwjTsrDbwGEeC7exX
