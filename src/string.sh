#!/usr/bin/env bash

# Functions for manipulating arbitrary strings.

#==============================================================================
# Functions
#==============================================================================

# Trims whitespace from a string.  Echoes trimmed to stdout.
trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}


#==============================================================================
# Tests
#==============================================================================

string__test() {
	trim '  remove extra whitespace   '
}


# Script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	string__test
fi


