#!/usr/bin/env bash

# PRE: Running on Cygwin.  Use the .deb pkg on Debian/Ubuntu.
if [ -z "$CYGWIN" ]; then
	echo "install.sh: ERROR: This script should only be run in Cygwin."
	exit 1
fi

libdir=/usr/share/lib/bash-glory
echo "Installing Bash Glory lib to ${libdir}."
mkdir -p $libdir
cp -p src/*.sh $libdir

mkdir -p $libdir/interactive
cp -p src/interactive/*.sh $libdir/interactive


