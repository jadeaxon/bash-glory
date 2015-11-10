#!/usr/bin/env bash

# Interactive functions for Windows integration.


#==============================================================================
# Functions
#==============================================================================

# Opens give file/directory using Windows Explorer.
# Is aliased to 'E'.
open_explorer() {
	if [ -z "$1" ]; then
		# If command is just 'E', then open current directory.
		explorer .
	else
		explorer "$@"
	fi
}


# Unalias spits out a warning if alias does not already exist.
unalias firefox >& /dev/null
function firefox {
	url=${1:-www.google.com}
	'/cygdrive/c/Program Files (x86)/Mozilla Firefox/firefox.exe' "$url"
}


#==============================================================================
# Tests
#==============================================================================


