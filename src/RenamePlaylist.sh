#!/bin/bash

for f in *; do
  echo $f
  pushd "$f"
  if [ -e playlist.m3u ]; then
    mv playlist.m3u "$f".m3u
  fi
  popd
done
