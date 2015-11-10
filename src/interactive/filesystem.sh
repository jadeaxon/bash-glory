#!/usr/bin/env bash

# Filesystem functions that should only be used interactively, not in scripts.

#==============================================================================
# Functions
#==============================================================================

# Backs up a file or directory.
# TO DO: Detect backup level and act accordingly.
# TO DO: Allow multiple args.
# TO DO: Make numbered .tgz backups.
# TO DO: Use .YYYY-MM-DD.bak instead of number.
backup() {
    local path="$1"
    if [ -f "$path" ]; then
        if [ -e "${path}.bak" ]; then
            if [ -e ${path}.2.bak ]; then
                if [ -e ${path}.3.bak ]; then
                    echo "backup: WARNING: Replacing 3rd backup."
                    cp -p $path ${path}.3.bak
                else
                    cp -p $path ${path}.3.bak
                fi
            else
                cp -p $path ${path}.2.bak
            fi
        else
            cp -p $path ${path}.bak
        fi

    elif [ -d "$path" ]; then
        path=${path%/} # Remove trailing /.
        if [ -e ${path}.tgz ]; then
            echo "backup: ERROR: Backup ${path}.tgz already exists."
            return 1
        else
            tar czvf ${path}.tgz $path
        fi
    else
        echo "backup: ERROR: Path is neither a file nor a directory."
        return 1
    fi
} # backup()


#------------------------------------------------------------------------------------------------------------------
# Mounting
#------------------------------------------------------------------------------------------------------------------

mount_maxheadroom() {
	mount -t cifs //maxheadroom.digecor.net/shares -o username=janderson,password=mypassword /mnt/maxheadroom/shares
}

# Mount C:\ to /mnt/c.  Meant to be called from your VM.
# Your wireless router should be set to always dole out the same IP address to your laptop.
# Well, it should be, but it isn't!
#
# PRE: Windows: Share your entire C:\ drive as a share named C under Windows.
#
# PRE: Ubuntu: apt-get install cifs-utils
# PRE: See 'Samba.txt'.
mountc() {
	if [ "$CYGWIN" ]; then
		echo "mountc: ERROR: You can't do this from Cygwin!"
		return 1
	fi

	# You can add password=<password> to the -o mount options.
	# The nobrl option makes it so Subversion can work on mounted Windows share.
	# Without it, you get this kind of error:
	# svn: E200033: database is locked, executing statement 'RELEASE   s1'
	local windows windows_user mount
	mount=/mnt/c

	# NOTE: You have to use an IP address.  Does not translate hostname using /etc/hosts.
	network=$(ipa | head -1 | cut -d'.' -f1)
	if [ "$HOSTNAME" == "XPS15-vm" ]; then 
		windows=192.168.0.19 # TO DO: Make router always assign this by MAC.
		windows_user=jadeaxon
		# For XPS 15 Windows 10 Pro laptop at home.
		mount -o nobrl,user=$windows_user -t cifs //$windows/C $mount
		(($? == 0)) && cd $mount/Users/$windows_user

	elif ((network == 172)); then
		# For Windows 10 desktop at digEcor.
		windows=172.16.40.77
		windows_user=janderson
		mount -o nobrl,user=$windows_user -t cifs //$windows/C $mount
		(($? == 0)) && cd $mount/Users/$windows_user

	else # Unexpected network.
		echo "mountc: Unexpected network: $network.  Not sure how to mount C: drive."
		return 1
	fi

} # mountc()


# Lists all mounts nicely formatted if called with no args.  Otherwise, runs normal mount command.
mount() {
	if (( $# == 0 )); then
		# List all mounts in nice columns.
		command mount | column -t
	else
		# There are args, so do a normal mount command.
		command mount "$@"
	fi
} # mount()


#==============================================================================
# Tests
#==============================================================================


