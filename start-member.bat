@echo off
@REM winget install  Ethereum.geth
@REM if %ERRORLEVEL% EQU 0 Echo Geth installed successfully.
@REM Change address to login with a different id
@REM Known Admins:
@REM 0x50FDf5ef99412268Cfa614fbd8039F786A36dE09: Culver
@REM 0x24C9CC9F8e25dd0C34DdaA6569F545883c41dFA0: Twesh
@REM 0xcF56De0c188a723063C8892979854Bd2c595dAaB: Russ
set addr=0xcF56De0c188a723063C8892979854Bd2c595dAaB
geth init --datadir data genesis.json
echo "Starting the member node, you'll need to enter your password next. Run ./console.bat to connect to the node locally and access the JS console."
geth --datadir data --networkid 201601988 --nodiscover --http --http.port 6437 --http.api personal,eth,net,web3 --http.corsdomain "*" --bootnodes "enode://f29b759ca8c6d65b57fdce8180c0ac226b1802a23ed6aaf7273b39ecd135192574e2754211c5e1a390df53d7d0f229d3cdb23c4a61cc9a29d1a15923f0b05eb6@35.173.216.249:30303?discport=0"


@REM geth --identity "newEth" --rpc --rpcport 6438 --rpcaddr 0.0.0.0 --rpccorsdomain "*" --datadir "data2" --port 30304 --rpcapi "db,eth,net,web3" --networkid 201601988 --ipcdisable console