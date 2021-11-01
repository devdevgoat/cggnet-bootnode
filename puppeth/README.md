# How to setup:

## 1 Deploy EC2 instances
- Create 3 instances of ubuntu (link to template)
    - 1 micro as controller
    - 2 mediums as nodes
- enable tcp/udp on the following ports for all trafic:
    - 30303
    - 8545
    - ...
- Note all public ip addresses 
- Note your .pem file for ssh

## 2 Setup controller
    - download git file (tbd here)
    - run init_controller.sh from controller instance
    - Setup intance communication by 
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