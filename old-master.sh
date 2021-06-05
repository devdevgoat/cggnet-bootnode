
# curl https://getcroc.schollz.com | bash # was using this to send dynamic files 
#dynamic account and genesis file creation, requires renaming genesis.json to tmp_genesis.json
# date +%s | sha256sum | base64 | head -c 32 > password.txt
# geth --datadir=data --password ./password.txt account new > account1.txt 
# addr=$(grep -o "0x.*" account1.txt| cut -f2- -dx)
#add address to alloc
# jq '.alloc = {"0x'${addr}'": { "balance": "9999" }}' tmp_genesis.json > tmp.json
# jq '.extradata = "0x0000000000000000000000000000000000000000000000000000000000000000'${addr}'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"' tmp.json > genesis.json
# croc send account1.txt password.txt genesis.json