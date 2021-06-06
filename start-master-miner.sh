#!/bin/bash
apt-get update
apt-get upgrade
add-apt-repository -y ppa:ethereum/ethereum
apt-get install -y ethereum
apt-get install jq

cp -r data minerdata
geth init --datadir minerdata genesis.json
#dynamic account and genesis file creation, requires renaming genesis.json to tmp_genesis.json
date +%s | sha256sum | base64 | head -c 32 > password.txt
geth --datadir minerdata --password ./password.txt account new > account.txt 
addr=$(grep -o "0x.*" account.txt| cut -f2- -dx)
echo "Created account:"${addr}

#used for aws ip lookup
wanip=$(dig +short myip.opendns.com @resolver1.opendns.com)
runcmd='geth --datadir minerdata --networkid 201601988 --nodiscover --verbosity 6 --unlock "'${addr}'" --password ./password.txt --bootnodes "enode://f29b759ca8c6d65b57fdce8180c0ac226b1802a23ed6aaf7273b39ecd135192574e2754211c5e1a390df53d7d0f229d3cdb23c4a61cc9a29d1a15923f0b05eb6@35.173.216.249:30303?discport=0"'
#saved to rerun on reboot
echo ${runcmd}>restart-master-miner.sh
chmod +x restart-master-miner.sh
$runcmd
