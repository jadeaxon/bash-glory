#!/usr/bin/env bash

# Ubuntu-specific Bash functions meant for scripting.

# Outputs Ubuntu major version to stdout.  Outputs 0 if this machine not running an Ubuntu distro.  
ubuntu_version() {
	local version=0
	if grep ^Ubuntu /etc/issue >& /dev/null; then
		version=$(cat /etc/issue | cut -f2 -d' ' | cut -f1 -d'.')
	fi
	echo $version
} # ubuntu_version()


#==============================================================================
# Tests
#==============================================================================

# Tests this library.
ubuntu_version__test() {
	ubuntu_version
}


# Only run tests when script is being run
# directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	ubuntu_version__test
fi


