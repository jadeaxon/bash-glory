#!/usr/bin/env bash

# Wrappers for common commands to help support aliases.

#==============================================================================
# Functions
#==============================================================================

# Recursively search all files in current dir for given regex.
# Aliased as grn.
# Example: grn needle
grep_rn() {
	pcregrep -r -n "$@" * 2>/dev/null
}

# Aliased as grin.
grep_rin() {
	pcregrep -r -i -n "$@" * 2>/dev/null
}

