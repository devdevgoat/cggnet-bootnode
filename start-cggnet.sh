geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique --nat extip:$1
echo 'geth --datadir data --networkid 201601988 --http --http.port 6437 --http.corsdomain "*" --nodiscover --http.api personal,eth,net,web3,admin,clique --nat extip:'$1 > restart.sh
chmod +x restart.sh