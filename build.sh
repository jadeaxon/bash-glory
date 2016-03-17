#!/usr/bin/env bash

set -e

if [ "$CYGWIN" ]; then
	echo "build: Use ./install.sh to install on Cygwin."
	exit 1
fi

cd debian
make clean
make

echo
echo "build: SUCCESS!"
exit 0

