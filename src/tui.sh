#!/usr/bin/env bash

# Functions for creating text user iterface (TUI) elements.

#===============================================================================
# Functions
#===============================================================================

# Creates an interactive menu from an array.
menu() { 
    local IFS=$' \t\n' # Use default setting of IFS. 
    local num n=1 opt item cmd 
    echo 
 
    # Loop though the command-line arguments.
    for item; do 
        printf "    %3d. %s\n" "$n" "${item%%:*}" 
        n=$(( $n + 1 )) 
    done 
    echo 
 
    # If there are fewer than 10 items, set option to accept key without ENTER.
    if [ $# -lt 10 ]; then 
        opt=-sn1 
    else 
        opt= 
    fi 
	# Get response from user. 
    read -p " (1 to $#) ==> " $opt num                
 
    # Check that user entry is valid. 
	case $num in 
		[qQ0] | "" ) 
			return 
			;; # q, Q or 0 or "" exits 
		*[!0-9]* | 0*) # invalid entry 
			printf "\aInvalid response: %s\n" "$num" >&2 
			return 1 
			;; 
	esac 
    echo 
 
	# Check that number is <= to the number of menu items.
    if [ "$num" -le "$#" ]; then 
		# Execute it using indirect expansion.
        eval "${!num#*:}"            
    else 
        printf "\aInvalid response: %s\n" "$num" >&2 
        return 1 
    fi 
} # menu()


# Echoes given text, but only if called within an interactive shell (generally by sourcing).
# iecho => interactive echo
# TO DO: Factor to bashlib.  Even if I export this, you can't call it from another program.
# Q. Is there a way to make .bashrc functions public to all subshells?
iecho() {
	if [ "$PS1" ]; then
		echo "$@"
	fi
}
export iecho


# Wait for a keystroke.
# TO DO: You have to press <Enter> for this to work.
wait_for_keystroke() {
	read -p 'Press any key to continue. . . .'

}


#===============================================================================
# Tests
#===============================================================================



