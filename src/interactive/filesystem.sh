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


# tar, jar, etc. aliases
# alias tx='tar xvzf' # Extract your typical .tar.gz or .tgz file.
# tx() { # For some reason my VM chokes on this style of function declaration just here.
function tx {
	targz='[.]tar[.]gz$'
	tgz='[.]tgz$'
	tarbz2='[.]tar[.]bz2$'

	if [[ "$1" =~ $targz ]]; then
		tar xzvf "$1"
	elif [[ "$1" =~ $tgz ]]; then
		tar xzvf "$1"
	elif [[ "$1" =~ $tarbz2 ]]; then
		tar xjvf "$1"
	else
		# The -a option is supposed to automatically determine compression program by file extension.
		tar xavf "$1"
		# echo "tx: Unknown file extension $(extension $1)."
	fi
} # end tx()


# Function that will help us say tc <directory> to create <directory>.tgz.
create_tgz() {
	if [ -d "$1" ]; then
		dir=${1%/} # Remove trailing /.
		tar czvf $dir.tgz $dir/
	else
		echo "create_tgz(): Argument must be a single directory."
	fi

} # create_tgz()


# Either prints out the absolute path of a file, or print the PATH env var in a line-by-line form.
# path() { # For some reason, my Linux VM chokes on this style of function declaration just here.
function path {
	if [ "$1" ]; then
		# Echo the absolute path of the give file.
		readlink -f "$1"
	else # No arg.
		# Print PATH env var to stdout line-by-line.
		echo $PATH | perl -pe 's/:/\n/g'
	fi

}


#------------------------------------------------------------------------------------------------------------------
# Navigation
#------------------------------------------------------------------------------------------------------------------

# The cd function replaces the builtin command of the same name. The function uses the builtin command 
# pushd to change the directory and store the new directory on DIRSTACK. If no directory is given, pushd uses 
# $HOME. If changing the directory fails, cd prints an error message, and the function returns with a failing exit 
# code (see Listing 11-1). 
# Change directory, storing new directory on DIRSTACK 
cd() { 
	# Preserve natural behavior of 'cd -'
	if [[ "$1" == '-' ]]; then
		builtin cd -
		return
	fi
 

	# Variables for directory and return code.
    local dir 
	local error 
 

    # Ignore all options.
	# NOTE: Rarely do you ever need an option of the cd builtin.
	# If you do, use 'builtin' to call it.'
    while true; do                                    
        case $1 in
            --) break ;; 
            -*) shift ;; 
            *) break ;; 
        esac 
    done 
 
    dir=$1

	# If given a file, cd to that file's directory.
	if [ -f "$dir" ]; then
		dir=$(dirname "$dir")
	fi

	# If a $dir is not empty. 
    if [ -n "$dir" ]; then 
		# pushd changes to given directory and saves current directory on DIRSTACK
        pushd "$dir"                      
    else 
        pushd "$HOME"                    
    fi 2>/dev/null                    
	# Error message should come from built-in cd (below), not pushd 
 
    error=$? # Store pushd's exit code. 
  
    if [ $error -ne 0 ]; then 
		# Let the builtin cd provide the error message.
        builtin cd "$dir"            

    fi 

    return "$error"                 
	
	# The standard output is redirected to the bit bucket because pushd prints the contents of DIRSTACK, 
	# and the only other output is sent to standard error (>&2). 
} > /dev/null # cd()
 

# Backtrack along visited directory stack, DIRSTACK (kind of like browser history).
pd() {
	popd

} > /dev/null


back() {
	popd
} > /dev/null


# cd to given directory and then list it.
# Aliased to '.l'.
cd_and_list() {
	cd "$1"
	my_ls
}


# Change directory to arg if a directory.
# Cat arg(s) if first is a file.
# Meant to be used with 'c' as an alias for it.
cd_or_cat() {
	if [ -d "$1" ]; then
		cd "$1"
	else # I'm a file, not a doctor, Jim.
		cat "$@"
	fi
}


# Show a menu of directories you've visited.
cdm() { 
    local dir IFS=$'\n' item 
	# loop through diretories in DIRSTACK[@] 
    for dir in $(dirs -l -p); do 
		# skip current directory 
        [ "$dir" = "$PWD" ] && continue     
        case ${item[*]} in 
			# $dir already in array; do nothing 
            *"$dir:"*) ;;  
            *) item+=( "$dir:cd '$dir'" ) ;; # add $dir to array 
        esac 
    done 
	# pass array to menu function 
    menu "${item[@]}" Quit:                            
} # cdm()


# Calls the ls command.  When it gets passed for than 1 argument, it
# does not expand directory contents.  With 0 or 1 arguments, it does.
my_ls() {
	# echo "arg count: $#"
    if [ $# -gt 1 ]; then
		ls -ladhF --color "$@"
	else
		ls -lahF --color "$@"
	fi

} # my_ls()


# Reports what a command resolves to including builtins, aliases, functions, and exectuable files.
which() {
	type -a $@
} # which
export -f which


# Lists a directory as a single column of filenames.
list_single_column() {
	if [ -z "$1" ]; then
		ls -1Ad .* * | pcregrep -v "^[.]{1,2}$" # List files as a single column with just the filename.
	elif [ -d "$1" ]; then
		ls -1A "$@" | pcregrep -v "^[.]{1,2}$"
	else # Args.
		ls -1Ad "$@" | pcregrep -v "^[.]{1,2}$"
	fi
}


#------------------------------------------------------------------------------------------------------------------
# Mounting
#------------------------------------------------------------------------------------------------------------------

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


# Mounts the LFS thumbdrive.
# () causes code to run in a subshell.  This allows us to use set -e (it exits current shell).
# PRE: You are root.
mount_LFS() {(
    set -e
    local boot root

    root=$(blkid|grep LFS_root|cut -f1 -d':')
    boot=$(blkid|grep LFS_boot|cut -f1 -d':')
    if [ -z "$root" ]; then
        echo "mount_LFS: ERROR: LFS_root DNE."; exit 1
    fi
    if [ -z "$boot" ]; then
        echo "mount_LFS: ERROR: LFS_boot DNE."; exit 1
    fi

    umount /media/janderson/LFS_boot || true
    umount /media/janderson/LFS_root || true
    mount /dev/sdb1 /mnt/LFS
    mount /dev/sdb2 /mnt/LFS/boot
    mount | grep LFS
    set +e
)} # mount_LFS()


#==============================================================================
# Tests
#==============================================================================


