#!/usr/bin/env bash

# Interactive functions for dealing with Vim.


#==============================================================================
# Functions
#==============================================================================

# Edits a command on the PATH using Vim.  Aliased to 'vw'.
# E.g. vi somescript.py
vimwhich() {
	if [ -z "$1" ]; then
		echo "Usage: vimwhich <script>"
		return
	fi
	local path=$(command which "$1" 2> /dev/null)
	if [[ "$path" == \/* ]]; then
		vi "$path"
	else
		echo "vimwhich: $1 not found in PATH."
	fi
}


# Installs stuff from Vim which may be missing.
setup_vim() {
	cd ~
	echo "setup_vim: Installing Pathogen."
	mkdir -p ~/.vim/autoload ~/.vim/bundle
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	
	# For some reason, gVim isn't reading out of ~/.vim/autoload/.
	if [ "$CYGWIN" ]; then
		cp ~/.vim/autoload/pathogen.vim /cygdrive/c/Program\ Files\ \(x86\)/Vim/vim74/autoload/
	fi
	
	cd -	
	echo "setup_vim: Installing Syntastic."
	cd ~/.vim/bundle
	rm -rf syntastic	
	git clone https://github.com/scrooloose/syntastic.git
	cd -

	mkdir -p ~/tmp/vim
} # setup_vim()


#==============================================================================
# Tests
#==============================================================================


