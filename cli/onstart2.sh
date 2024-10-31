#!/bin/bash

cd ~
mkdir temp
cd temp/

# Install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20


# Repo
cd ~/projects/
ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts
git clone git@bitbucket.org:pxx/stock-ass.git
cd stock-ass/
git checkout master
npm i
