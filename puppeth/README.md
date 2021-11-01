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
- Note all public ip addresses 
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
            ```ssh -i primaryPersonal.pem ubuntu@[bootnode.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub```
            ```ssh -i primaryPersonal.pem ubuntu@[signer0.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub```
            ```ssh -i primaryPersonal.pem ubuntu@[signer1.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub```

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
        - 1 (eth stats)
        - 1 (another server)
        - *paste ip address for node 1*
        - yes (fingerprint?)
        - 8080 (port)
        - n (prevent port sharing)
        - p@ssw0rd (password)
        (you can verify now at ip.address:8080)
    ### Bootnode
        - 4
        - 2
        - 2
        - 1
        - /home/ubuntu/blockitechs/bootnode (data folder)
        - 30305 (port)
        - enter (peer)
        - enter (light peers)
        - blockitechs_bootnode

    ## Sealer Nodes (repeat for each sealer)
        - 4
        - 3
        - 3
        - 2
        - ipaddress to sealer node 0
        - /home/ubuntu/blockitechs/sealernode (data folder)
        - enter (port)
        - enter (peer)
        - enter (light peers)
        - blockitechs_sealer_0
        - paste json from ealier
        - paste value in ~/passfile 
        - enter (empty blocks mgas)
        - enter (full blocks)
        - 0.0001 (signer)