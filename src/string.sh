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


# Add comma separators to a number and print result.
commify() {
    typeset text=${1}
    typeset bdot=${text%%.*}
    typeset adot=${text#${bdot}}
    typeset i commified

    (( i = ${#bdot} - 1 ))
    while (( i>=3 )) && [[ ${bdot:i-3:1} == [0-9] ]]; do
        commified=",${bdot:i-2:3}${commified}"
        (( i -= 3 ))
    done
    echo "${bdot:0:i+1}${commified}${adot}"
}


# Strips ANSI color escape sequences from text.  This filters all stdin.
# Need this since I set grep to always color so I can pipe it to less.
# However, when I want to pipe grep to xargs, I need to remove the color.
strip_ansi_color() {
	sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
}


#==============================================================================
# Tests
#==============================================================================

string__test() {
	trim '  remove extra whitespace   '
	echo	
	commify 1234567890
	echo
	ls -la --color=always | strip_ansi_color
}



# Script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	string__test
fi


