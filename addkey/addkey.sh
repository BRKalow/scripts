#!/bin/bash
[ -z "$1" ] && echo "Usage: ./addKey.sh [USERNAME] [SERVER NAME]" && exit

echo "SSHing into server and adding your key"
cat ~/.ssh/id_rsa.pub | ssh $1@$2 "cat >> ~/.ssh/authorized_keys"
echo "You should be good to go."
