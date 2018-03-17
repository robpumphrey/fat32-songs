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
## run TrackRelabel.sh -A "Ablum Name" -a "Artist Name" -y year -p <directory pattern>
####################################################################
__end_of_usage__
exit 1
}

artist=
album=
year=1970
genre=101
pattern='*'

while getopts "p:a:A:y:H" argname; do
 case $argname in
    A) album=$OPTARG ;;
    a) artist=$OPTARG ;;
    y) year=$OPTARG ;;
    p) pattern=$OPTARG ;;
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
echo "Artist:  ${artist}"
echo "Album:   ${album}"
echo "Diretories to use are "
ls -1d $pattern
echo ""
echo "Carry on? (Enter for y, CTRL-C to abort)"
read carryon


playlistname=`echo "${artist}-${album}" | sed -e 's/ //g'`
trackname=`echo "${album}" | sed -e 's/ //g'`
track=1
targetdir="../${playlistname}/"
mkdir "${targetdir}"

fullplaylist="${targetdir}/${playlistname}.m3u"
echo -n "" > "${fullplaylist}"
IFS='
'

for d in $pattern; do
  if [ ! -e "${d}/playlist.m3u" ]; then
    echo "Must have a playlist.m3u file in directory $d"
    exit 1
  fi
done
for d in $pattern; do
  for f in `cat "$d/playlist.m3u"`; do
    printf -v g "%s-%02d.mp3" $trackname $track
    echo "$g" >> ${fullplaylist}
    echo "copying $d/$f to ${targetdir}$g"
    cp "$d/$f" "${targetdir}$g"
    printf -v chapter "%02d" $track
    id3 -t "Chapter $track" -T $track -a "${artist}" -A "${album}" -y "${year}" -g "${genre}" "${targetdir}$g"
    let track=$track+1
  done
done
