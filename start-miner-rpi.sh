#!/bin/bash
# apt-get update
# apt-get upgrade
# add-apt-repository -y ppa:ethereum/ethereum
# apt-get install -y ethereum

 
geth init --datadir data genesis.json
PS3="Who dis? If you already have an account, start geth manually."
select address in Russ Culver Twesh CreateNew
do
case $address in 
    Russ)
        addr="0xcF56De0c188a723063C8892979854Bd2c595dAaB"
        ;;
    Culver)
        addr="0x50FDf5ef99412268Cfa614fbd8039F786A36dE09"
        ;;
    Twesh)
        addr="0x24C9CC9F8e25dd0C34DdaA6569F545883c41dFA0"
        ;;
    CreateNew)
        addr="0x0"
        ;;
    *)
        echo "Invalid Response"
        exit
        ;;
esac 

if [[ $addr -eq "0x0"]]
then 
    # need to create an account
    date +%s | sha256sum | base64 | head -c 32 > password.txt
    echo "Creating new account. Saved password to password.txt"
    cat password.txt
    echo "^^^^ Don't lose this. You can use the console (geth attach http://localhost:6437) to change this. Google it."
    geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique console
    geth --datadir=data --password ./password.txt account new > account.txt 
    echo "Account created. Saved this output to account.txt. You're account address:"
    addr=$(grep -o "0x.*" account1.txt| cut -f2- -dx)
    echo ${addr}
fi
done    
echo "Starting miner. You should be prompted for a password, if this is a new account, copy and paste the one above."
echo "geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique console --unlock ${addr} --mine" > miner-restart.sh
chmod +x miner-restart.sh 
geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique --unlock ${addr} --mine console
# geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique
# geth --datadir data --networkid 201601988 --nodiscover