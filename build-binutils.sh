#!/bin/bash

TARGET_ALIAS=$1
if [ -z "$2" ]
then
  TARGET=$TARGET_ALIAS
else
  TARGET=$2
fi
TARG_XTRA_OPTS=""

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## Create and enter the toolchain/build directory
mkdir -p build && cd build || { exit 1; }

## Configure the build.
../configure --quiet --prefix="$PS2DEV/$TARGET_ALIAS" --target="$TARGET" $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet -j $PROC_NR clean   || { exit 1; }
make --quiet -j $PROC_NR CFLAGS="$CFLAGS -D_FORTIFY_SOURCE=0" || { exit 1; }
make --quiet -j $PROC_NR install || { exit 1; }
make --quiet -j $PROC_NR clean   || { exit 1; }
