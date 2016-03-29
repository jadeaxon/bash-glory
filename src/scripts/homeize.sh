#!/usr/bin/env bash

# Convert a fresh home directory into a GitHub-backed home directory.

set -e
S=$(basename $0)

sudo apt-get install pcregrep
sudo apt-get install fortune
sudo apt-get install keychain
sudo apt-get install curl
sudo apt-get install vim

mkdir -p ~/tmp/vim
source /usr/share/lib/bash-glory/interactive/vim.sh

setup_vim

cd ~
git init
git remote add origin git@github.com:jadeaxon/home.git
git fetch
git checkout -f -t origin/master


echo "$S: You should now start a new shell."


