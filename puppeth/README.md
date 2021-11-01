# How to setup:

## 1 Deploy EC2 instances
- Create 3 instances of ubuntu (link to template)
    - 1 micro, 10gb ebs, 2 vCPU, 4gb ram as controller
    - 2 mediums as nodes
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
        sudo ./init_controller.sh
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
            ```ssh -i primaryPersonal.pem ubuntu@[node1.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub```
            ```ssh -i primaryPersonal.pem ubuntu@[node1.ip.addr.here] 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub```