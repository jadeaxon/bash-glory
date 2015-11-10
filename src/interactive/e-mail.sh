#!/usr/bin/env bash

#==============================================================================
# Functions
#==============================================================================

# Adds a to do task to Remember the Milk.
# Relies on a forwarding rule in Hotmail that forwards messages
# whose subjects begin with D: to my RtM inbox.
# Instantly syncing to Android requires that you have an RtM Pro account.
todo() {
	j@h "D: $1"

}


#==============================================================================
# Tests
#==============================================================================


