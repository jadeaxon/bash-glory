#!/usr/bin/env bash

# Functions for dealing with environment variables.

#===============================================================================
# Functions
#===============================================================================

# Uniquely add to the end of the PATH environment variable.
# TO DO: What you really want is something that will pop the existing directory to the top if it is
# already in the path.
# Also, a similar operation for adding to the back of a path.
append_to_path() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${PATH}":"$1"
	fi
}

# Prepends given directory to the PATH env var if not already present.
prepend_to_path() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="$1":"${PATH}"
	fi
}


#===============================================================================
# Tests
#===============================================================================



