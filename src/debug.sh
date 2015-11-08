#!/usr/bin/env bash

# Provides functions useful for debugging Bash scripts.


#==============================================================================
# Functions
#==============================================================================

# Prints the name of a variable and its value.
# E.g., dv HOME
dv() {
	local variable="$1"
	eval value=\$$variable
	echo "$variable = $value"
}


#==============================================================================
# Tests
#==============================================================================

debug__test() {
	dv HOME
	dv blarg
	dv USER
}


# Script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	debug__test
fi


