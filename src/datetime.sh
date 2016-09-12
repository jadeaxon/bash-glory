#!/usr/bin/env bash

# Interactive functions for dealing with dates and times.


#==============================================================================
# Functions
#==============================================================================

# Displays a YYYYMMDD date.  You can supply a separator arg.
# ymd - => YYYY-MM-DD.
ymd() {
	date +%Y$1%m$1%d
}


# Displays a MMDDYYY date with optional separator.
mdy() {
	date +%m$1%d$1%Y
}


#==============================================================================
# Tests
#==============================================================================


