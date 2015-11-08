#!/usr/bin/env bash


# Prints the name of a variable and its value.
dv() {
	local var=$1
	local temp='$'"$var"
	eval "value=$temp"
	echo "$var = $value"
}


#==============================================================================
# Test
#==============================================================================

dv HOME
dv blarg
dv USER

