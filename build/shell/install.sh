#!/usr/bin/env bash

set -ex

apt-get update

# General tools.
apt-get install --no-install-recommends -y jq

# Pip.
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
echo "export PATH=~/.local/bin:$PATH" >> ~/.profile
source ~/.profile
pip3 install awscli --upgrade --user

# Node
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install nodejs
node -v
npm -v

# Npm.
npm install -g serverless

# Packer.
curl -o packer.zip $(curl https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux.*amd64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
unzip packer.zip
echo "export PATH=~/packer/:$PATH" >> ~/.bashrc

rm -rf /var/lib/apt/lists/*