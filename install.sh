#!/usr/bin/env bash

# PRE: Running on Cygwin.  Use the .deb pkg on Debian/Ubuntu.
if [ -z "$CYGWIN" ]; then
	sudo dpkg -i debian/*.deb
	exit $?
fi

libdir=/usr/share/lib/bash-glory
echo "Installing Bash Glory lib to ${libdir}."
mkdir -p $libdir
cp -p src/*.sh $libdir

mkdir -p $libdir/interactive
cp -p src/interactive/*.sh $libdir/interactive

cp -p debian/control $libdir

