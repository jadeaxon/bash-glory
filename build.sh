#!/usr/bin/env bash

set -e

cd debian
make clean
make

echo
echo "build: SUCCESS!"
exit 0

