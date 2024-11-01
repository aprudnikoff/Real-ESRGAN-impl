#!/bin/bash

env >> /etc/environment;
mkdir -p ${DATA_DIRECTORY:-/workspace}


# ----------------------------------------------------------
# Bootstrap python project
# ----------------------------------------------------------
# Install python prequities
apt-get -y install libgl1
apt-get -y install python3-pip
pip3 install --upgrade pip setuptools

# Clone python project and install dependencies
mkdir ~/projects
cd ~/projects/
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone https://github.com/aprudnikoff/Real-ESRGAN-impl.git
cd Real-ESRGAN-impl/
pip3 install -e .
# python3 setup.py develop


# ----------------------------------------------------------
# Bootstrap JS project
# ----------------------------------------------------------

# Add ssh key for bitbucket
echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDjlPbeg+G+0T80vbjPb7ae/E2YYcvw0ioeu9c3zAOFbgAAAJiw9W81sPVv
NQAAAAtzc2gtZWQyNTUxOQAAACDjlPbeg+G+0T80vbjPb7ae/E2YYcvw0ioeu9c3zAOFbg
AAAEDbjPimrtyANiUqYK2KABjkxpkgTT5k/DYPZ7iScTIwZuOU9t6D4b7RPzS9uM9vtp78
TZhhy/DSKh671zfMA4VuAAAAFWEucHJ1ZG5pa292QGdtYWlsLmNvbQ==
-----END OPENSSH PRIVATE KEY-----
" >> ~/.ssh/id_ed25519
chmod 400 ~/.ssh/id_ed25519


# Install nvm and node
mkdir ~/temp
cd ~/temp/
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20


# Install exiftool
apt-get -y install build-essential
curl --output Image-ExifTool-12.97.tar.gz https://exiftool.org/Image-ExifTool-12.97.tar.gz
gzip -dc Image-ExifTool-12.97.tar.gz | tar -xf -
cd Image-ExifTool-12.97
perl Makefile.PL
make test
make install


# Clone JS project and install dependencies
cd ~/projects/
ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts
git clone git@bitbucket.org:pxx/stock-ass.git
cd stock-ass/
git checkout vast
npm i






echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Caralho!!! All done!"
