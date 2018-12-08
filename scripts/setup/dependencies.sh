#!/bin/bash

unzip newrelic.zip

apt-get update
apt-get install --always-yes=true python openssh-server nano

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install awscli --upgrade
export PATH=~/.local/bin:$PATH

wget https://github.com/mikefarah/yq/releases/download/2.0.0/yq_linux_amd64
chmod 755 yq_linux_amd64
mv yq_linux_amd64 /usr/bin/yq