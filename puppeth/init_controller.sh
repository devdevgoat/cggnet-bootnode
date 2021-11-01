#!/bin/sh
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    ethereum \
    docker.io \
    docker-compose

sudo usermod -a -G docker $USER

# generate a password for this signer
tr -dc A-Za-z0-9 </dev/urandom | head -c 13  > ~/passfile
# generate account
sudo mkdir ~/accts
for ((n=0;n<10;n++)); do sudo geth --datadir ~/accts account new --password ~/passfile >> account_log.txt; done

# note to user to copy acct
echo -e '\a Copy the addresses from account_log.txt or above to a seperate file and lable them signer0, signer1, and faucet. You will need these to answer future prompts. Pause here and do the next step in read me after "run init_controller.sh"'


