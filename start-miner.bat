@echo off
REM Change address to login with a different id
REM Known Admins:
REM 0x50FDf5ef99412268Cfa614fbd8039F786A36dE09: Culver
REM 0x24C9CC9F8e25dd0C34DdaA6569F545883c41dFA0: Twesh
REM 0xcF56De0c188a723063C8892979854Bd2c595dAaB: Russ
set addr=0xcF56De0c188a723063C8892979854Bd2c595dAaB
geth init --datadir data genesis.json
geth --datadir data --networkid 201601988 --nodiscover --unlock %addr% --mine console