#!/usr/bin/env bash

# Functions for supporting Linux from Scratch (LFS).

source /usr/share/lib/bash-glory/debug.sh


#==============================================================================
# Functions
#==============================================================================

# PRE: $LFS is defined.
# PRE: $bpkg and $ver are defined.  These should be the base source package name and version.
# Sets up variables used by other LFS functions.
# POST: $archive is defined.
LFS::init() {
	local F=$FUNCNAME
	set -e
	shopt -s nullglob

	if [ -z "$LFS" ]; then
		echo "$F: ERROR \$LFS is not defined."
		return 1
	elif [ -z "$bpkg" ]; then
		echo "$F: ERROR: \$bpkg is not defined."
		return 1
	elif [ -z "$ver" ]; then
		echo "$F: ERROR: \$ver is not defined."
		return 1
	fi

	S=$(basename $0) # Yes, $0 is still the *script* name inside a function.
	D=$(pwd)
	src=$LFS/sources

	pkg=${bpkg}-${ver} # Full pkg name.
	archive=( $src/${pkg}.tar.* ) # Expand glob into an array.
	archive=${archive[0]}

	if [ -z "$archive" ]; then
		echo "$F: ERROR: Failed to define \$archive."
		return 1
	fi
} # LFS::init()


# Prints the state of various global variables.
LFS::debug() {
	dv LFS
	dv bpkg
	dv ver
	dv S
	dv D
	dv src
	dv pkg
	dv archive
}


# Extracts a source archive to the current directory and cds to it.
# PRE: LFS::init() has been called.
LFS::extract_archive() {
	echo "$S: Extracting archive $archive."
	rm -rf $pkg
	tar xavf $archive
	cd $pkg
}

# Applies a patch to the source archive if one exists.
# PRE: LFS::init() has been called.
LFS::apply_patch() {
	patch=( $src/${pkg}*.patch )
	patch=${patch[0]}
	if [ "$patch" ]; then
		echo "$S: Patching ${pkg} with ${patch}."
		patch -p1 < $patch
	fi
}


# Finishes the build.
# PRE: LFS::init() has been called.
LFS::cleanup() {
	cd $D
	rm -rf $pkg/
	echo "$S: WIN: You have built $pkg from scratch!"
}


#==============================================================================
# Tests
#==============================================================================

example__test() {
	echo
}


# Script is being run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	example__test
fi


