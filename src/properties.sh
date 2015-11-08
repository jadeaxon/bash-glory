#!/usr/bin/env bash

# PRE: pcregrep in installed.

# This is how you create the encrypted properties file:
# openssl enc -aes-256-cbc -salt -in temp.properties -out ~/.properties.enc -pass file:~/.ssh/properties.key


#==============================================================================
# Functions
#==============================================================================

# Emits the value of the given property on stdout.
# Consults ~/.properties then ~/.properties.enc.
# Uses ~/.ssh/properties.key to decrypt ~/.properties.enc.
# If property not found and default given, emits default value.
# Otherwise, emits a blank line.
# Examples:
# property name.first
# property color.favorite green
property() {
	local key="$1"
	local default="$2"	
	if [ -z "$key" ]; then
		echo "ERROR: Property key is blank." 1>&2
		return 1
	fi

	if [ ! -f ~/.properties ]; then
		echo "ERROR: No ~/.properties file exists." 1>&2
		return 2
	fi

	# TO DO: $key should really be regex-quoted so completely literal.
	line=$(pcregrep "^$key ?=" ~/.properties | head -1)
	if [ "$line" ]; then
		echo $line | sed "s/$key[ ]*=[ ]*//"
	else # Property not found in ~/.properties.
		penc=~/.properties.enc
		aeskey=~/.ssh/properties.key
		cmd="openssl enc -d -aes-256-cbc -in $penc -pass file:$aeskey"
		line=$($cmd | pcregrep "^$key ?=" | head -1)
		if [ "$line" ]; then
			echo $line | sed "s/$key[ ]*=[ ]*//"
		elif [ "$default" ]; then
				echo $default
		else
			echo
		fi
	fi

} # property()


#==============================================================================
# Tests
#==============================================================================

# Tests this library.
properties__test() {
	property 
	echo
	property DNE default
	echo
	property name.first
	echo
	property SECRET
}


# Only run tests when script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	properties__test
fi



