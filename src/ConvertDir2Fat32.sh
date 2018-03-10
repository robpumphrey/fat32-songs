#/bin/bash

for f in *; do
  if [ -d "$f" ]; then
    echo "Proccessing directory '$f'"
    Convert2Fat32.sh "$f"
  else
    echo "Skipping file $f"
  fi
done
RenamePlaylist.sh
