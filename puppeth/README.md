# How to setup:

Great walkthrough there: https://collincusce.medium.com/using-puppeth-to-manually-create-an-ethereum-proof-of-authority-clique-network-on-aws-ae0d7c906cce
## 1 Deploy EC2 instances
- Create 3 instances of ubuntu (link to template)
    - 1 micro, 10gb ebs, 2 vCPU, 4gb ram as controller
    - 3 mediums as nodes
- enable tcp on the following ports for all trafic:
    - 30000-30999
    - 4000-4010
    - 8000-8999
    - 80
    - 443
    - 22
- Note your controller's PUBLIC ip and your other nodes PRIVATE ip addresses 
- Note your .pem file for ssh

## 2 Setup controller
    - download and execute init_controller.sh file *on controller instance*
        ```#!bash
        curl -L https://raw.githubusercontent.com/devdevgoat/cggnet-bootnode/main/puppeth/init_controller.sh > init_controller.sh
        chmod +x init_controller.sh
        ./init_controller.sh
        ```
    - Setup cross-intance communication 
        - running the following from local machine:
            ```scp -i C:\Users\russe\.ssh\primaryPersonal.pem C:\Users\russe\.ssh\primaryPersonal.pem ubuntu@[controller.ip.addr.here]:~/```
        - shh into controller, run subsequent steps on controller node:
            ```ssh -i C:\Users\russe\.ssh\primaryPersonal.pem ubuntu@[controller.ip.addr.here]```
        - set perms on pem
            ```chmod 400 primaryPersonal.pem```
        - generate rsa, leave all blank
            ```ssh-keygen```
        - update authorized keys
            ```ssh -i primaryPersonal.pem ubuntu@[node.ip.here.0] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
            ssh -i primaryPersonal.pem ubuntu@[signer0.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
            ssh -i primaryPersonal.pem ubuntu@[signer1.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
            ssh -i primaryPersonal.pem ubuntu@[signer1.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
            ssh -i primaryPersonal.pem ubuntu@172.30.4.194 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub```

## Setup nodes
    - ssh to each node and run the following:
        ```#!bash
        curl -L https://raw.githubusercontent.com/devdevgoat/cggnet-bootnode/main/puppeth/init_node.sh > init_node.sh
        chmod +x init_node.sh
        ./init_node.sh
        exit
        ```
## Setup Puppeth
    - From controller ssh, run:
        ```#!bash
        puppeth
        ```
    - Use the following inputs:
        - blockitechs
        - 2 (configure new genisis)
        - 1 (create)
        - 2 (Clique)
        - 5 (seconds)
        - paste in first 2 accounts from the init_controller (sealers)
        - enter a blank value
        - paste in the 3rd account
        - enter a blank value
        - yes (pre-fund)
        - 112 (chain id)
        - 2 (manage)
        - 2 (export genesis)
        - enter blank (default)
    - exit puppeth, or open a seperate ssh to controller
    - copy to a notes file the keys for the new accounts
        ```#bash
        sudo su
        cd /home/ubuntu/accts/keystore/
        cat *
        cd ..
        exit
        cd ~/
        echo ''
        cat ~/passfile
        ```
    - we'll copy each of these and the password back into puppeth later
- Return to prev puppeth or run 
        ```#bash
        puppeth
        ```
    - with following inputs:
    ### Ethstats
        - blockitechs
        - 4 (deploy)
        - 1 (ethstats)
        - 1 (another server)
        - *paste ip address for node 1*
        - yes (fingerprint?)
        - 8080 (port)
        - n (prevent port sharing)
        - p@ssw0rd (password)
        (you can verify now at ip.address:8080)
    ### Bootnode
        - 4
        - # (Deploy new network component)
        - 2 (Bootnode)
        - 1
        - /home/ubuntu/blockitechs/bootnode (data folder)
        - 30305 (port)
        - enter (peer)
        - enter (light peers)
        - blockitechs_bootnode

    ## Sealer Nodes (repeat for each sealer)
        - 4
        - # (Deploy new network component)
        - 3 (sealer)
        - # (connect another server)
        - ipaddress to sealer node #
        - /home/ubuntu/blockitechs/sealernode (data folder)
        - enter (port)
        - enter (peer)
        - enter (light peers)
        - blockitechs_sealer_#
        - paste json from ealier
        - paste value in ~/passfile 
        - enter (empty blocks mgas)
        - enter (full blocks)
        - 0.0001 (signer)

    ## Explorer Nodes (repeat for each sealer)
        - 4
        - # (Deploy new network component)
        - 4 (explorer)
        - # (connect another server)
        - ipaddress to sealer node #
        - /home/ubuntu/blockitechs/explorer (data folder)
        - /home/ubuntu/blockitechs/postgres (pg folder)
        - enter (port.. probaly shouldn't share with )
        - blockitechs_explorer
        
    ## START MINING
        - from bootnode:
        ```
        docker exec -it <container_id> geth attach ipc:/root/.ethereum/geth.ipc
        add the node peers manually?
        ```
    ## stand up rpc accesible node
        - none of the puppeth nodes support http/rpc which is required for connecting a wallet. 
            we can stand up a new node, or jsut use our controller node.
        - get commands from http://[bootnode]:8081/#geth for light node
        - ssh into controller
        - run 
            ```
            geth --datadir=$HOME/.b2 init b2.json
            geth --networkid=112 --port 30304 --datadir=$HOME/.b2 --ethstats='controller-rpc:p@ssw0rd@172.30.4.81:8080' --bootnodes=enode://05b31f2c98c93b8c59294a7d37a43e7063c7d59ad0bd2160e7c7d094a1c154bc1d8a44fe4f6b46e3b7016030bee99c8e53e72fa58444160dfa295cbfa15dd1ad@172.30.4.81:30303 --http --http.addr 0.0.0.0 --http.port 8545     
        ```
    
    # Verify rpc is working
        - run against controller node from your local machine
        ```
        curl -X POST -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","method":"eth_blockNumber","id":1}' 54.227.206.150:8545
        ```

    # explorer not working
        - going to have to setup manually: https://github.com/gkaemmer/poa-explorer


RUN   echo 'geth --cache 512 init /genesis.json' > geth.sh &&        echo 'mkdir -p /root/.ethereum/keystore/ && cp /signer.json /root/.ethereum/keystore/' >> geth.sh &&   echo $'exec geth --networkid 112 --cache 512 --port 30303 --nat extip:172.30.4.113 --maxpeers 50  --ethstats \'sealer1:p@ssw0rd@172.30.4.194\' --bootnodes enode://05b31f2c98c93b8c59294a7d37a43e7063c7d59ad0bd2160e7c7d094a1c154bc1d8a44fe4f6b46e3b7016030bee99c8e53e72fa58444160dfa295cbfa15dd1ad@172.30.4.81:30303  --unlock 0 --password /signer.pass --mine --miner.gastarget 7500000 --miner.gaslimit 10000000 --miner.gasprice 100000' >> geth.sh

# Troubleshooting

 - No idea how to deal with ssh loosing connections...
 - if you get error:
 ```Named volume "home/ubuntu/blockitechs/explorer:/opt/app/.ethereum:rw" is used in service "explorer" but no declaration was found in the volumes section.```
    - log into the bootnode and delete the named folder (explorer)
