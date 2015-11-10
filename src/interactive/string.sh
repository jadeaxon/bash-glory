#!/usr/bin/env bash

# Interactive functions for dealing with strings.


#==============================================================================
# Functions
#==============================================================================

# Emits a date header such as I use in various logs I keep.
# From Vim, just do :r!datebars.
# Or, press X on a line containing V:!datebars.
# Kind of sweet how it uses indented here file plus command substitution.
# Yes, the Vim shell commands do have the ~/.bashrc functions/aliases.
datebars() {
	cat <<-HEADER
	-------------------------------------------------------------------------------
	$(date +%a) $(mdy /)
	-------------------------------------------------------------------------------
	HEADER
}


# Creates a bar of the given character.
# TO DO: Make properly handle patterns longer than 1.
# bar <pattern> <length>
bar() {
	pattern="${1:-=}"
	seq 1 100 | for n in $(cat); do 
		echo -n "$pattern"
	done
	echo
}


# Creates a couple bars.
bars() {
	pattern="$1"
	shift
	bar $pattern
	echo "$*"
	bar $pattern
}


#==============================================================================
# Tests
#==============================================================================


