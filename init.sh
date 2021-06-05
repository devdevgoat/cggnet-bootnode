#!/bin/bash
# apt-get update
# apt-get upgrade
# add-apt-repository -y ppa:ethereum/ethereum
# apt-get install -y ethereum
# apt-get install jq
# curl https://getcroc.schollz.com | bash

#dynamic account and genesis file creation, requires renaming genesis.json to tmp_genesis.json
# date +%s | sha256sum | base64 | head -c 32 > password.txt
# geth --datadir=data --password ./password.txt account new > account1.txt 
# addr=$(grep -o "0x.*" account1.txt| cut -f2- -dx)
#add address to alloc
# jq '.alloc = {"0x'${addr}'": { "balance": "9999" }}' tmp_genesis.json > tmp.json
# jq '.extradata = "0x0000000000000000000000000000000000000000000000000000000000000000'${addr}'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"' tmp.json > genesis.json
# croc send account1.txt password.txt genesis.json

geth init --datadir data genesis.json

wanip=$(dig +short myip.opendns.com @resolver1.opendns.com)
runcmd='geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique --nat extip:'${wanip}' console'

echo ${runcmd}>restart.sh
chmod +x restart.sh
# ./restart.sh

$runcmd & 
geth attach http://localhost:6437 | admin.peerInfo.enr
