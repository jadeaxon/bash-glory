#!/usr/bin/env bash

#==============================================================================
# Functions
#==============================================================================

# Tails log files.
# TO DO: Make arg autocomplete to /var/log/ contents.
tfl() {
	tail -f "/var/log/$1"
}


#------------------------------------------------------------------------------
# Build
#------------------------------------------------------------------------------

# Deploys the latest Debian pkg available in project to target CM/SPS /root/packages.
# PRE: You are in a project dir that has a debian/ subfolder. 
# PRE: The project dir contains a build.sh which builds its Debian pkg in the debian/ subfolder.
deploy_to() {
	local target="$1"
	target="root@$target"

	# John's mcast projects use an output/ dir for the Debian pkgs.
	if [ -d output/ ]; then
		mv output/*.deb debian/
	fi
	
	local pkg=$(basename debian/*.deb)

	pkgsdir=/root/packages
	if [ "$dt" == "nv" ]; then
		pkgsdir=/home/root/packages
	fi

	# Handle the dige-provision pkg case.
	deb_dir=debian
	shopt -s nullglob
	exists=$(echo $deb_dir/*.deb)
	shopt -u nullglob
	if [ -z "$exists" ]; then
		deb_dir=debian_nv
	fi

	scp $deb_dir/*.deb $target:$pkgsdir
	armel=$(echo $deb_dir/*.deb | grep -c _armel.deb)
	if (( armel )); then
		if [ "$dt" == "nv" ]; then # We are deploying pkg directly to an NV.
			ssh $target 'cd ~/packages; dpkg -i *.deb; mkdir -p installed; mv *.deb installed/'
		else # Deploying player-side pkg to a server.
			ssh $target 'cd ~/packages; rmpkg-$(group) *_armel.deb; addpkg-$(group) *.deb; mkdir -p armel; mv *.deb armel/'
		fi
	else # Server-side pkg.  These will be amd64 arch.
		ssh $target 'cd ~/packages; dpkg -i *.deb; mkdir -p installed; mv *.deb installed/'
	fi
	
	echo "deploy_to: Deployed $pkg to $target."
} # deploy_to()


# Builds and deploys the project to the appropriate place.
# TO DO: Maybe each project dir should have a build.conf.sh this can source.
build_and_deploy() {
	# Yes, I'm that lazy.
	if defined dt; then
		deployment_target="$dt"
	fi

	if [ -f build.conf.sh ]; then
		source build.conf.sh
	fi

	if [ -f build.sh ]; then
		./build.sh
		if (( ! $? )); then
			# TO DO: Deploy to SPS, L7, or NV as appropriate.
			deploy_to $deployment_target
		else
			echo "build_and_deploy: ERROR: Build failed."
		fi

	else
		echo "build_and_deploy: ERROR: Can't build: no build.sh script here."
		return 1
	fi

} # build_and_deploy()


# alias a='./a' # For use with Hello/C++ projects.  Just type 'a' after 'm.'.
a() {
	if [ -f './a' ]; then
		./a # For Linux
	elif [ -f './a.exe' ]; then
		./a.exe # For Cygwin
	else 
		echo "Neither a nor a.exe exist here."
	fi
}


#------------------------------------------------------------------------------
# Source Control
#------------------------------------------------------------------------------

# Reports either SVN or Git status.
svn_or_git_status() {
	if [ -d .svn ]; then
		svn status
	elif [ -d ../.svn ]; then
		svn status
	elif [ -d ../../.svn ]; then 
		svn status
	elif [ -d ../../../.svn ]; then
		svn status
	elif [ -d .git ]; then
		git status
	elif [ -d ../.git ]; then
		git status
	elif [ -d ../../.git ]; then
		git status
	elif [ -d ../../../.git ]; then
		git status
	else
		echo "svn_or_git_status(): ERROR: You do not appear do be in either an SVN or Git repo."
		return 1
	fi
} # svn_or_git_status()


# Does a git pull.  Performs special gymnastics to route around home dir Bash history files.
git_pull() {
	if [ "$PWD" == "$HOME" ]; then
		set +o history
		git stash
		git pull "$@"
		git stash pop
		set -o history
	else # Normal git pull
		git pull "$@"
	fi
} # git_pull()


#------------------------------------------------------------------------------------------------------------------
# digEplayer L7/L10
#------------------------------------------------------------------------------------------------------------------

# Is the machine we are running on a digEplayer?
is_digEplayer() {
	if [ -f /usr/local/bin/player_type ]; then
		return 0 # Inverted logic.
	fi
	return 1
}


# Sets the PLAYER_TYPE environment variable to whichever type of digEplayer this code is running on.
initialize_player_type() {
    if is_digEplayer; then
        PLAYER_TYPE=$(player_type)
    else # This is not a digEplayer.
        PLAYER_TYPE="not"
    fi
}


# Is this machine a digEplayer L7?
is_L7() {
	if [ "$PLAYER_TYPE" == "L7" ]; then
		true
	else
		false
	fi
}

# Is this machine a digEplayer L10?
is_L10() { 
	if [ "$PLAYER_TYPE" == "L10" ]; then
		true
	else
		false
	fi
}


# Setup the content devmapper device and mount it to /mnt/L10/content.
# Extracted from /usr/sbin/bootstrap.
# PRE: You are NFS booted on a player.
setup_content_device() {
    cdevs=(
        # device node   sysfs entry
        "/dev/sda3  /sys/block/sda/sda3"
        "/dev/mmcblk0p1 /sys/block/mmcblk0/mmcblk0p1"
    )

    table=""
    total=0
    for cdev in "${cdevs[@]}"; do
        # Each entry in table is a size 2 list.
        cdev=($cdev)
        if [ -e ${cdev[1]} ]; then
            dev=${cdev[0]}
            size=$(< ${cdev[1]}/size)
            table="$table\n$total $size linear $dev 0"
            let total+=$size
        fi
    done
    echo -e "$table" | dmsetup create content

	# mount -t ext2 /dev/mapper/content /mnt/$PLAYER_TYPE/content

} # setup_content_device()


# Start digemenu again.
dm() {
    killall digemenu
    killall digeoverlay
    cd /opt/gstreamer_demo/omap3530
    digeoverlay &
    digemenu -lll &
    cd -
}


# Truncates all the .log files in /var/log.
clear_logs() {
	for f in /var/log/*.log; do
		> $f
	done
}


#------------------------------------------------------------------------------------------------------------------
# NV/Linux Development
#------------------------------------------------------------------------------------------------------------------

# Checks what type of ARM exectuable a given file is.
arm_type() { 
	if [ 1 -gt $# ] ; then 
		echo "Usage: $0 <eabi-executable>"
	else
		atype=$(readelf -h $1 | grep Machine:)
		if [ "x$atype" = "x" ] ; then 
			echo "'$1' is not an ELF"
		else mach=$(echo $atype | grep ARM)
			if [ "x$mach" = "x" ] ; then 
				echo "'$1' is not an ARM executable"
			else 
				atype=$(readelf -A $1 | grep Tag_ABI_VFP_args)
				if [ "x$atype" != "x" ]; then
					echo "'$1' uses hard-float, vfp (armhf)"
				else 
					atype=$(readelf -A $1 | grep NEON)
					if [ "x$atype" = "x" ] ; then 
						echo "'$1' uses soft-float (armel)"
					else 
						echo "'$1' uses hard-float, neon (armhf)"
					fi
				fi
			fi
		fi
	fi 
} # arm_type()


#==============================================================================
# Tests
#==============================================================================

