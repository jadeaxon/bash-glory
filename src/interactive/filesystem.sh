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


#==============================================================================
# Tests
#==============================================================================


