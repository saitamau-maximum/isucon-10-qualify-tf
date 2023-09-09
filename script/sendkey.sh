#!/bin/bash

# load ip.txt
TARGET_IPS=$(cat ip.txt)
# load public key
PUBLIC_KEY=$(cat key.txt)
LOCAL_IP="192.168.0."
COUNTER=2

# loop through each ip
for ip in $TARGET_IPS; do
    # ssh into each ip and run the following command
    ssh -o StrictHostKeyChecking=no -i ~/.ssh/isucon ubuntu@$ip "/bin/bash -c 'echo $PUBLIC_KEY >> ~/.ssh/authorized_keys'"
    COUNTER=$((COUNTER+1))
done
