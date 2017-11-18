#!/usr/bin/env bash

# Convert a fresh home directory into a GitHub-backed home directory.

set -e
S=$(basename $0)
cd ~

if [ -d ~/.git ]; then
	echo "$S: ERROR: This user's home directory has already been home-ized."
	exit 1
fi


# Don't try this on Cygwin because you have neither apt-get nor sudo.
if [ ! -n "$COMSPEC" ]; then
	sudo apt-get install pcregrep
	sudo apt-get install fortune
	sudo apt-get install keychain
	sudo apt-get install curl
	sudo apt-get install vim
fi

mkdir -p ~/tmp/vim
source /usr/share/lib/bash-glory/interactive/vim.sh

setup_vim

cd ~
git init
git remote add origin git@github.com:jadeaxon/home.git
git fetch
git checkout -f -t origin/master

echo "$S: You should now start a new shell."


