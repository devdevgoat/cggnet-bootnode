#!/bin/bash
# apt-get update
# apt-get upgrade
# add-apt-repository -y ppa:ethereum/ethereum
# apt-get install -y ethereum
# apt-get install jq
# curl https://getcroc.schollz.com | bash


mkdir data
date +%s | sha256sum | base64 | head -c 32 > password.txt
geth --datadir=data --password ./password.txt account new > account1.txt 
addr=$(grep -o "0x.*" account1.txt)
#add address to alloc
jq '.alloc = {"'${addr}'": { "balance": "9999" }}' tmp_genesis.json > tmp.json
jq '.extradata = "0x0000000000000000000000000000000000000000000000000000000000000000'${addr}'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"' tmp.json > genesis.json


croc send account1.txt password.txt genesis.json

geth init --datadir data genesis.json

wanip=$(dig +short myip.opendns.com @resolver1.opendns.com)
./start-cggnet.sh $wanip