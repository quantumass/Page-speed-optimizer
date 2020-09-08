#!/bin/bash

set -e

BASEDIR=$(dirname "$0")
mkdir -p ${BASEDIR}placeholders

for file in $BASEDIR/*/*; do
    if file "$file" |grep -qE 'image|bitmap'; then
        mkdir -p $BASEDIR/placeholders/$(dirname -- "$file")
        filebasename=${file##*/}
        format=`identify -format '%wx%h' $file`
        convert $file -blur 0x20 $BASEDIR/placeholders/$(dirname -- "$file")/${filebasename}
        ##wget https://via.placeholder.com/${format}.webp -O $BASEDIR/placeholders/$(dirname -- "$file")/${filebasename}
    fi
done