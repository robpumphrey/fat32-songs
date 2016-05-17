#!/bin/bash

DISCARD_CHARS='[^A-Za-z0-9_.-]'
if [ "$#" != 1 ]; then
  echo "Must specify directory name $#"
  exit 1
fi

echo "Converting '$1'"
if [ ! -d "$1" ]; then
  echo "Directory '$1' does not exist"
  exit 1
fi

newname=`echo $1 | sed -e "s/$DISCARD_CHARS//g"`
if [ "$newname" != "$1" ]; then
  if [ -d "$newname" ]; then
    echo "Directory '$newname' exists, abort"
    exit 1
  fi
  mv "$1" "$newname"
fi

pushd $newname > /dev/null
if [ -e playlist.m3u ]; then
  mv playlist.m3u ${newname}.m3u
fi

#rename m3u files
for f in *.m3u; do
  m3uName=`echo $f | sed -e "s/$DISCARD_CHARS//g"`
  if [ "${m3uName}" != "${f}" ]; then
    mv "$f" "${m3uName}"
  fi
  sed -e "s/[^A-Za-z0-9_.-]//g" "${m3uName}" > ${m3uName}.tmp
  origcount=`cat ${m3uName} | sort | uniq | wc -l`
  newcount=`cat ${m3uName}.tmp | sort | uniq | wc -l`
  if [ "${origcount}" != "${newcount}" ]; then
    echo "After mangling, there are files with the same name"
    exit 1
  fi
  mv "${m3uName}.tmp" "${m3uName}"
done

#rename mp3 files
for f in *.mp3; do
  mp3Name=`echo $f | sed -e "s/$DISCARD_CHARS//g"`
  if [ "${mp3Name}" != "${f}" ]; then
    mv "$f" "${mp3Name}"
  fi
done

popd > /dev/null