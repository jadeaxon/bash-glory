#!/usr/bin/env bash

# Interactive functions for dealing with web-related stuff.


#==============================================================================
# Functions
#==============================================================================

# Opens up Firefox and searches for args combined into query string.
query_google() {
	query="$*" # Combine all args into one big string.
	url="https://www.google.com/search?q=$query"
	# firefox "$url" &
	# explorer.exe "$url" &
	# cmd.exe /c start "$url"
	(cd /mnt/c && cmd.exe /c start "" "$url")
}


#==============================================================================
# Tests
#==============================================================================


