#!/bin/bash

if [ ! -d ../set1 ]; then
  echo "Could not find ../set1"
  exit 1
fi

if [ -d TMP ]; then
  rm -rf TMP
fi
mkdir TMP
cp -R ../set1/* TMP
cd TMP
../../../src/ConvertDir2Fat32.sh