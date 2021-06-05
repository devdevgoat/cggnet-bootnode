#!/bin/bash
# apt-get update
# apt-get upgrade
# add-apt-repository -y ppa:ethereum/ethereum
# apt-get install -y ethereum

 
geth init --datadir data genesis.json
PS3="Who dis? If you already have an account, start geth manually."
select name in Russ Culver Twesh CreateNew; do
case $REPLY in 
    1)
        addr="0xcF56De0c188a723063C8892979854Bd2c595dAaB"
        ;;
    2)
        addr="0x50FDf5ef99412268Cfa614fbd8039F786A36dE09"
        ;;
    3)
        addr="0x24C9CC9F8e25dd0C34DdaA6569F545883c41dFA0"
        ;;
    4)
        addr="0x0"
        ;;
    *)
        echo "Invalid Response"
        exit
        ;;
esac
 if [[ -n $addr ]]; then
        echo ADDRESS is $addr
        break
    fi
done 

if [[ $addr -eq "0x0" ]]
then 
    # need to create an account
    date +%s | sha256sum | base64 | head -c 32 > password.txt
    echo "Creating new account. Saved password to password.txt"
    echo $(cat password.txt)
    echo "^^^^ Don't lose this. You can use the console (geth attach http://localhost:6437) to change this. Google it."
    geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique console
    geth --datadir=data --password ./password.txt account new > account.txt 
    echo "Account created. Saved this output to account.txt. You're account address:"
    addr=$(grep -o "0x.*" account1.txt| cut -f2- -dx)
    echo ${addr}
fi 
echo "Starting miner. You should be prompted for a password, if this is a new account, copy and paste the one above."
echo "geth --datadir data --networkid 201601988 --nodiscover --unlock ${addr} --mine --miner.etherbase ${addr} console" > miner-restart.sh
chmod +x miner-restart.sh

geth init --datadir data genesis.json
# geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique
# this boot node should not change since we've stored the key for resuse in bootnode.key and is
#   laucnhed using that file, the public key should be generated everytime... I think?
geth --datadir data --networkid 201601988 --nodiscover --unlock ${addr} --mine --bootnodes "enode://f29b759ca8c6d65b57fdce8180c0ac226b1802a23ed6aaf7273b39ecd135192574e2754211c5e1a390df53d7d0f229d3cdb23c4a61cc9a29d1a15923f0b05eb6@35.173.216.249:30303?discport=0"