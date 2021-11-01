#!/bin/bash
apt-get update
apt-get upgrade
add-apt-repository -y ppa:ethereum/ethereum
apt-get install -y ethereum
apt-get install jq

geth init --datadir data genesis.json
#used for aws ip lookup
wanip=$(dig +short myip.opendns.com @resolver1.opendns.com)
#runcmd='geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique --nat extip:'${wanip}' console'
runcmd='geth --datadir data --networkid 201601988 --http --http 0.0.0.0 --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique --nat extip:'${wanip}'  --nodekey bootnode.key console'
#saved to rerun on reboot
echo ${runcmd}>restart-master-node.sh
chmod +x restart-master-node.sh
$runcmd
