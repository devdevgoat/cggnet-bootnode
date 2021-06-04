#!/bin/bash
apt-get update
apt-get upgrade

apt-get install ethereum
mkdir data
geth init --datadir data genesis.json
./start-cggnet.sh