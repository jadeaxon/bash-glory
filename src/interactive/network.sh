#!/usr/bin/env bash

# Interactive functions for dealing with network-related stuff.


#==============================================================================
# Functions
#==============================================================================

# Lists just the IP address of this machine for its eth0 network interface.
if [[ -z $CYGWIN ]]; then
	function ipaddress() {
		# This will (some) handle dual-homed machines.
		# Also handles machines with a wireless connection.
		(ifconfig eth0;ifconfig eth1;ifconfig wlan0) 2> /dev/null | grep 'inet addr' | perl -pe 's/^\s+inet addr:(\S+).*$/$1/g'
	}
else # Cygwin.
	function ipaddress() {
		# None of the Windows machines I am on are dual-homed.
		ipconfig | grep 'IPv4 Address' | head -1 | perl -pe 's/^.*: (.*\d)/$1/'	
	}
fi


# Helps with ssh connections on local network.  Allows me to say 'ssh 104'.
ssh() {
	network=172.16.40 # Default network.
	regex='^[0-9]+$'
	arg=$(trim $1) # Last arg seems to keep trailing newline.	
	if [[ "$arg" =~ $regex ]]; then
		command ssh ${network}.$arg
	else
		command ssh "$@" # Else infinite recursion!
	fi
}


Cb() {
	scp "$1" root@bronzeboy-sp1:/root/
}


Cs() {
	scp "$1" root@silverboy-sp1:/root/
}


# Copies file to the win8 desktop.
# Aliased as CJ.
scp_to_desktop() {
	scp "$@" $J
}

#==============================================================================
# Tests
#==============================================================================


