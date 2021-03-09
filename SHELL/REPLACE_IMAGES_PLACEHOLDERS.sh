#!/bin/bash

set -e

htmls=(index.html thankyou.html)
BASEDIR=$(dirname "$0")

mkdir -p ${BASEDIR}/placeholders

for html in $htmls; do
    files=`grep -Po '<img[^>]*src="\K[^"]*(?=")' $BASEDIR/$html`
    sed -i "s|</html>|<script src=\"assets/js/lazyload.min.js\"></script></html>|g" "$BASEDIR/$html"
    for filename in $files; do
        filebasename=${filename##*/}
        echo "FILENAME: " "${filebasename}"
        sed -i "s|src=\"$filename\"|src=\"placeholders/${filebasename}.webp\" data-src=\"$filename.webp\"|g" "$BASEDIR/$html"
        if [ -f "$BASEDIR/placeholders/${filebasename}" ]; then
            continue
        else
            convert $filename -blur 0x20 $BASEDIR/placeholders/${filebasename}
            cwebp -q 60 $BASEDIR/placeholders/${filebasename} -o $BASEDIR/placeholders/${filebasename}.webp
            cwebp -q 90 $filename -o $filename.webp
        fi
    done
done