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

# TODO: Do we do this here?
# TODO: Clean up taks in cluster that are running older versions of this image.
# aws ssm agent
# test
curl -O https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb
systemctl status amazon-ssm-agent