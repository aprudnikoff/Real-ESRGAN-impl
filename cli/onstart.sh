#!/bin/bash

env >> /etc/environment;
mkdir -p ${DATA_DIRECTORY:-/workspace}
apt-get -y install libgl1
apt-get -y install python3-pip
pip3 install --upgrade pip setuptools
mkdir ~/projects
ssh-keyscan github.com >> ~/.ssh/known_hosts
cd ~/projects
git clone https://github.com/aprudnikoff/Real-ESRGAN-impl.git
cd Real-ESRGAN-impl/
pip3 install -e .
# python3 setup.py develop

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Caralho!!! All done!"
