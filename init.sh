#!/bin/bash
apt-get update
apt-get upgrade
add-apt-repository -y ppa:ethereum/ethereum
apt-get install -y ethereum
curl https://getcroc.schollz.com | bash


mkdir data
$(date +%s | sha256sum | base64 | head -c 32) > password.txt
geth --datadir=data --password ./password.txt account new > account1.txt 
geth init --datadir data genesis.json

wanip=$(dig +short myip.opendns.com @resolver1.opendns.com)
./start-cggnet.sh $wanip