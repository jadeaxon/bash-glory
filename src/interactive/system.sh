#!/usr/bin/env bash

# Functions for dealing with the system.

#==============================================================================
# Functions
#==============================================================================

# Print a list mapping each /dev device to its lsusb device.
dev2usb() {
	for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
		(
		syspath="${sysdevpath%/dev}"
		devname="$(udevadm info -q name -p $syspath)"
		[[ "$devname" == "bus/"* ]] && continue
		eval "$(udevadm info -q property --export -p $syspath)"
		[[ -z "$ID_SERIAL" ]] && continue
		echo "/dev/$devname - $ID_SERIAL"
		)
	done
} # dev2usb()


#==============================================================================
# Tests
#==============================================================================

# Script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	S=$(basename $0)
	echo "$S: No tests defined."
	exit 0
fi


