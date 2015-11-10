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


# Removes duplicates from the PATH variable, preserving order.
# So, to alter path do
# export PATH=/new/directory:"$PATH"
# unique_path
unique_path() {
    regexp='^\s*$'
    if [[ $PATH =~ $regexp ]]; then
        return 0
    fi

    export PATH=$( \
        echo $PATH | \
        perl -pe 's/:/\n/g' | \
        perl -ne 'print if not $seen{$_}; $seen{$_} = 1' | \
        perl -pe 's/\n/:/g' | perl -pe 'chop' \
    )
}


# Removes duplicates from the CLASSPATH variable, preserving order.
# So, to alter path do
# export CLASSPATH=/new/directory;"$CLASSPATH"
# unique_classpath
unique_classpath() {
    regexp='^\s*$'
    if [[ $CLASSPATH =~ $regexp ]]; then
        return 0
    fi

    export CLASSPATH=$( \
        echo $CLASSPATH | \
        perl -pe 's/;/\n/g' | \
        perl -ne 'print if not $seen{$_}; $seen{$_} = 1' | \
        perl -pe 's/\n/;/g' | perl -pe 'chop' \
    )
}


#===============================================================================
# Tests
#===============================================================================



