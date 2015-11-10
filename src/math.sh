#!/usr/bin/env bash

# Math functions for Bash scripting.

#==============================================================================
# Functions
#==============================================================================

# Use awk to do floating point math since Bash can only do integer math.
# WARNING: Calling _calc directly would expand globs.  You want * to be the multiplication symbol.	
_calc() {
	awk "BEGIN { print \"\" $* }"
	set +o noglob # Turn globbing back on.
}


#==============================================================================
# Tests
#==============================================================================


