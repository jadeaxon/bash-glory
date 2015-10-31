#!/usr/bin/env bash

libdir=/usr/share/lib/bash-glory
echo "Installing Bash Glory lib to ${libdir}."
mkdir -p $libdir
cp -p src/*.sh $libdir

