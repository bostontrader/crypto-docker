The software for this coin is based on Alpine 3.11.

Anything we can do with this coin can be done using bgoldd and bgold-cli.  It's much easier to just figure these out than it is to deal with building the GUI and trying to get its X video out of the docker container securely.  Hence, no GUI edition here.

## 1. Build cd/btg-bitcoin-gold:base

From a shell window on the host in a suitable directory:

```sh
git clone https://github.com/bostontrader/crypto-docker.git
cd crypto-docker/2020/BTG-BitcoinGold
docker build -t cd/btg-bitcoin-gold:base -f Dockerfile.base \
  --build-arg SOURCE_ORIGIN=https://github.com/BTCGPU/BTCGPU \
  --build-arg SOURCE_LOCAL_ROOT=/BTCGPU \
  --build-arg COMMIT=e14dde \
  .
```

This will build the base image for this coin, based on a specific commit that is known to be useable, dated October 2018.


## 2. Build cd/btg-bitcoin-gold:cli

```sh
docker build -t cd/btg-bitcoin-gold:cli -f Dockerfile.cli .
```
This will build cd/btg-bitcoin-gold:cli which contains only bgoldd and bgold-cli, optimized and devoid of debug symbols. Nothing else.

Next, run the cd/btg-bitcoin-gold:cli image.

From a shell window on the host...

```sh
export DATADIR=/some/path/to/.bitcoingold
docker run -it --rm -u $(id -u ${USER}):$(id -g ${USER}) --mount type=bind,source=$DATADIR,destination=/.bitcoingold cd/btg-bitcoin-gold:cli
```

This will run the cd/btg-bitcoin-gold:cli container and mount the given directory from the host filesystem into the container, for use as the DATADIR.  When we run this we will obtain a shell into the container, and when stopped, the container will be removed. The present user id and group id of the host will be passed to the container, which will use this info to avoid chowning the files of DATADIR to root.

Note: /somepath/to/.bitcoingold must already exist, docker won't create it for you.

Once inside the container...

```sh
bgoldd -printtoconsole -rpcuser=user -rpcpassword=password -daemon
bgold-cli -rpcuser=user -rpcpassword=password <some cli command>
```

This turns on bgoldd in daemon mode which then allows us to invoke bgold-cli in order to control it.


# Thanks Tom!

If you find this useful please consider contributing to our tip jar

btg: GakaVrHCgyyUcoBjGrQg1wyharq1UbbPGV
