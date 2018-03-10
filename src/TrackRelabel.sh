#!/bin/bash 
usage() {
cat <<'__end_of_usage__'
####################################################################
## Rename mp3 files
## Protocol to rip a multi disc album to one playlist
## Use ripperX to rip CD, no need to bother with CDDB
## Give each CD a auther such as A and album name 1, 2, 3 etc
## Move mp3 files into one master folder
## touch playlist.m3u in master
## cat each playlist.m3u into the master
## run TrackRelabel.sh -A "Ablum Name" -a "Artist Name" -y year
####################################################################
__end_of_usage__
exit 1
}

artist=
album=
year=1970
genre=101

while getopts ":a:A:y:H" argname; do
 case $argname in
    A) album=$OPTARG ;;
    a) artist=$OPTARG ;;
    y) year=$OPTARG ;;
    H ) usage
       exit 0;;
    : ) error "Option '$OPTARG' requires an argument.";;
   \?) error "Unknown option: $OPTARG";;
   * ) error;;
  esac
done

if [ "${album} = "" ]; then
  echo "Set album with -A"
  exit 1
fi
if [ "${artist} = "" ]; then
  echo "Set artist with -a"
  exit 1
fi
if [ ! -e playlist.m3u ]; then
  echo "Must have a playlist.m3u file"
  exit 1
fi

playlistname=`echo "${artist}-${album}" | sed -e 's/ //g'`
trackname=`echo "${album}" | sed -e 's/ //g'`
track=1
echo -n "" > "${playlistname}.m3u"
IFS='
'
for f in `cat playlist.m3u`; do
  printf -v g "%s-%02d.mp3" $trackname $track
  echo "$g" >> ${playlistname}.m3u
  if [ "$g" != "$f" ]; then
    echo "$f moving to $g"
    mv "$f" "$g"
  fi
  printf -v chapter "%02d" $track
  id3 -t "Chapter $track" -T $track -a "${artist}" -A "${album}" -y "${year}" -g "${genre}" "$g"
  let track=$track+1
done
rm playlist.m3u