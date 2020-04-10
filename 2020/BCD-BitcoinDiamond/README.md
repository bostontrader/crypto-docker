The software for this coin is based on Alpine 3.11.

Anything we can do with this coin can be done using bgoldd and bgold-cli.  It's much easier to just figure these out than it is to deal with building the GUI and trying to get its X video out of the docker container securely.  Hence, no GUI edition here.

## 1. Build cd/bcd-bitcoin-diamond:base

From a shell window on the host in a suitable directory:

```sh
git clone https://github.com/bostontrader/crypto-docker.git
cd crypto-docker/2020/BCD-BitcoinDiamond
docker build -t cd/bcd-bitcoin-diamond:base -f Dockerfile.base \
  --build-arg SOURCE_ORIGIN=https://github.com/eveybcd/BitcoinDiamond \
  --build-arg SOURCE_LOCAL_ROOT=/BitcoinDiamond \
  --build-arg COMMIT=18d4f7 \
  .
```

This will build the base image for this coin, based on a specific commit that is known to be useable, dated October 2018.


## 2. Build cd/bcd-bitcoin-diamond:cli

```sh
docker build -t cd/bcd-bitcoin-diamond:cli -f Dockerfile.cli .
```
This will build cd/bcd-bitcoin-diamond:cli which contains only bitcoindiamondd and bitcoindiamond-cli, optimized and devoid of debug symbols. Nothing else.

Next, run the cd/bcd-bitcoin-diamond:cli image.

From a shell window on the host...

```sh
export DATADIR=/some/path/to/.bitcoindiamond
docker run -it --rm -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.bitcoindiamond cd/bcd-bitcoin-diamond:cli
```

This will run the cd/bcd-bitcoin-diamond:cli container and mount the given directory from the host filesystem into the container, for use as the DATADIR.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.bitcoindiamond must already exist, docker won't create it for you.

Once inside the container...

```sh
bitcoindiamondd -printtoconsole -rpcuser=user -rpcpassword=password -daemon
bitcoindiamond-cli -rpcuser=user -rpcpassword=password <some cli command>
```

This turns on bitcoindiamondd in daemon mode which then allows us to invoke bitcoindiamond-cli in order to control it.


# Thanks Tom!

If you find this useful please consider contributing to our tip jar

bcd: 3NVrTafEDw3jdpXun4g1QtSD1mdMYfZfYb
