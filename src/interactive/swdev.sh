#!/usr/bin/env bash

#==============================================================================
# Functions
#==============================================================================

# Tails log files.
# TO DO: Make arg autocomplete to /var/log/ contents.
tfl() {
	tail -f "/var/log/$1"
}


#------------------------------------------------------------------------------
# Build
#------------------------------------------------------------------------------

# Deploys the latest Debian pkg available in project to target CM/SPS /root/packages.
# PRE: You are in a project dir that has a debian/ subfolder. 
# PRE: The project dir contains a build.sh which builds its Debian pkg in the debian/ subfolder.
deploy_to() {
	local target="$1"
	target="root@$target"

	# John's mcast projects use an output/ dir for the Debian pkgs.
	if [ -d output/ ]; then
		mv output/*.deb debian/
	fi
	
	local pkg=$(basename debian/*.deb)

	pkgsdir=/root/packages
	if [ "$dt" == "nv" ]; then
		pkgsdir=/home/root/packages
	fi

	scp debian/*.deb $target:$pkgsdir
	armel=$(echo debian/*.deb | grep -c _armel.deb)
	if (( armel )); then
		if [ "$dt" == "nv" ]; then # We are deploying pkg directly to an NV.
			ssh $target 'cd ~/packages; dpkg -i *.deb; mkdir -p installed; mv *.deb installed/'
		else # Deploying player-side pkg to a server.
			ssh $target 'cd ~/packages; rmpkg-$(group) *_armel.deb; addpkg-$(group) *.deb; mkdir -p armel; mv *.deb armel/'
		fi
	else # Server-side pkg.  These will be amd64 arch.
		ssh $target 'cd ~/packages; dpkg -i *.deb; mkdir -p installed; mv *.deb installed/'
	fi
	
	echo "deploy_to: Deployed $pkg to $target."
} # deploy_to()


# Builds and deploys the project to the appropriate place.
# TO DO: Maybe each project dir should have a build.conf.sh this can source.
build_and_deploy() {
	# Yes, I'm that lazy.
	if defined dt; then
		deployment_target="$dt"
	fi

	if [ -f build.conf.sh ]; then
		source build.conf.sh
	fi

	if [ -f build.sh ]; then
		./build.sh
		if (( ! $? )); then
			# TO DO: Deploy to SPS, L7, or NV as appropriate.
			deploy_to $deployment_target
		else
			echo "build_and_deploy: ERROR: Build failed."
		fi

	else
		echo "build_and_deploy: ERROR: Can't build: no build.sh script here."
		return 1
	fi

} # build_and_deploy()


# alias a='./a' # For use with Hello/C++ projects.  Just type 'a' after 'm.'.
a() {
	if [ -f './a' ]; then
		./a # For Linux
	elif [ -f './a.exe' ]; then
		./a.exe # For Cygwin
	else 
		echo "Neither a nor a.exe exist here."
	fi
}


#------------------------------------------------------------------------------
# Source Control
#------------------------------------------------------------------------------

# Reports either SVN or Git status.
svn_or_git_status() {
	if [ -d .svn ]; then
		svn status
	elif [ -d ../.svn ]; then
		svn status
	elif [ -d ../../.svn ]; then 
		svn status
	elif [ -d ../../../.svn ]; then
		svn status
	elif [ -d .git ]; then
		git status
	elif [ -d ../.git ]; then
		git status
	elif [ -d ../../.git ]; then
		git status
	elif [ -d ../../../.git ]; then
		git status
	else
		echo "svn_or_git_status(): ERROR: You do not appear do be in either an SVN or Git repo."
		return 1
	fi
} # svn_or_git_status()


# Does a git pull.  Performs special gymnastics to route around home dir Bash history files.
git_pull() {
	if [ "$PWD" == "$HOME" ]; then
		set +o history
		git stash
		git pull "$@"
		git stash pop
		set -o history
	else # Normal git pull
		git pull "$@"
	fi
} # git_pull()


#==============================================================================
# Tests
#==============================================================================

