#!/usr/bin/env bash

# Consolidate sourcing of the entire library.

glory=/usr/share/lib/bash-glory
iglory=/usr/share/lib/bash-glory/interactive

source $glory/debug.sh
source $glory/env.sh
source $glory/string.sh
source $glory/filesystem.sh
source $glory/tui.sh
source $glory/math.sh
source $glory/ubuntu.sh


# Only source interactive libs in interactive shell.
if [[ "$PS1" ]]; then
	source $iglory/filesystem.sh
	source $iglory/network.sh
	source $iglory/www.sh
	source $iglory/e-mail.sh
	source $iglory/swdev.sh
	source $iglory/vim.sh
	source $iglory/string.sh
	source $iglory/bash.sh
	source $iglory/system.sh

	if [ "$CYGWIN" ]; then
		source $iglory/windows.sh
	fi
fi

unset glory
unset iglory

workspace=$HOME/projects/bash-glory


#==============================================================================
# Functions
#==============================================================================

# Provides frontend to bash-glory subcommands.
bash-glory() {
	if [ "$1" == 'version' ]; then
		if [ -z "$CYGWIN" ]; then	
			dpkg-query -W -f='${Version}' bash-glory
		else # Running Cygwin.
			grep ^Version: /usr/share/lib/bash-glory/control | cut -f2 -d' '
		fi
		return 0
	elif [ "$1" == 'github-version' ]; then
		control_file=$workspace/debian/control
		if [ ! -f "$control_file" ]; then
			echo "bash-glory: ERROR: $control_file DNE." 1>&2
			return 1
		fi
		cd $workspace >& /dev/null
		git stash >& /dev/null
		git pull >& /dev/null
		cd - >& /dev/null
		grep ^Version: $control_file | cut -f2 -d' ' || \
			echo "bash-glory: ERROR: Control file has no version." 1>&2 && \
			return 1
		return 0
	elif [ "$1" == 'update' ]; then
		should-update-bash-glory && update-bash-glory
		return 0
	else # Unknown subcommand.
		echo "bash-glory: ERROR: Unknown subcommand '$1'." 1>&2
		return 1
	fi
} # bash-glory()


# Should we update the bash-glory library?
should-update-bash-glory() {
	installed_version=$(bash-glory version)
	# echo "installed_version = $installed_version"
	github_version=$(bash-glory github-version)
	# echo "github_version = $github_version"

	# The major version in GitHub is larger than the installed version.
	iv1=$(echo $installed_version | cut -f1 -d'.') 
	gv1=$(echo $github_version | cut -f1 -d'.')
	(( gv1 > iv1 )) && return 0

	# The minor version is larger.
	iv2=$(echo $installed_version | cut -f2 -d'.') 
	gv2=$(echo $github_version | cut -f2 -d'.')
	(( gv2 > iv2 )) && return 0

	# The revision is larger.
	iv3=$(echo $installed_version | cut -f3 -d'.') 
	gv3=$(echo $github_version | cut -f3 -d'.')
	(( gv3 > iv3 )) && return 0

	# The installed version is up-to-date.
	return 1

} # should-update-bash-glory() 


# Automatically updates the bash-glory library.
update-bash-glory() {
	echo "bash-glory: Updating self."
	cd $workspace >& /dev/null
	rm -f debian/*.deb
	[ -z "$CYGWIN" ] && ./build.sh >& build.log
	./install.sh	
	cd - >& /dev/null

} # update-bash-glory()


#==============================================================================
# Tests
#==============================================================================

# Tests bash-glory().
bash-glory__test() {
	local installed_version=$(bash-glory version)
	echo "installed_version = $installed_version"
	local github_version=$(bash-glory github-version)
	echo "github_version = $github_version"
	
	bash-glory update
}

# Tests should-update-bash-glory().
should-update-bash-glory__test() {
	should-update-bash-glory && echo "bash-glory should be updated"
}

# Tests update-bash-glory().
update-bash-glory__test() {
	update-bash-glory
}


# Only run tests when script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	should-update-bash-glory__test
	bash-glory__test
	## update-bash-glory
fi



