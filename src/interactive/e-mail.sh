#!/usr/bin/env bash

#==============================================================================
# Functions
#==============================================================================

# Adds a to do task to Remember the Milk.
# PRE: Mail rule exists in Hotmail to forward messages beginning with D: to my RtM e-mail address.
# Instantly syncing to Android requires that you have an RtM Pro account.
todo() {
	j@h "D: $1"

}

# Sends e-mail to @Waiting in Hotmail.
# PRE: Correct mail rule in Hotmail exists.
# Aliased to @W.
send_waiting_e-mail() {
	j@h "W: $1"
}


#==============================================================================
# Tests
#==============================================================================


