#!/usr/bin/env bash

set -ex

# pip
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
echo "export PATH=~/.local/bin:$PATH" >> ~/.profile
source ~/.profile
pip3 install awscli --upgrade --user

# node
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get install -y nodejs

# docker linter
npm install dockerfilelint -g

# jq
apt-get install -y jq

# packer
curl -o packer.zip $(curl https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux.*amd64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
unzip packer.zip
echo "export PATH=~/packer/:$PATH" >> ~/.bashrc