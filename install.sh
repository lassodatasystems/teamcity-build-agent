#!/usr/bin/env bash

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