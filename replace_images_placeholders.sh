#!/bin/bash

set -e

htmls=(index.html thankyou.html)

for html in $htmls; do
    files=`grep -Po '<img[^>]*src="\K[^"]*(?=")' $1/$html`
    # sed -i "s|<script src=\"js/main.js\"></script>|<script src=\"js/main.js\"></script><script src=\"js/lazyload.min.js\"></script>|g" "$1/$html"
    for filename in $files; do
        filebasename=${filename##*/}
        echo "FILENAME: " "${filebasename}"
        format=`identify -format '%wx%h' $1/$filename`
        sed -i "s|src=\"$filename\"|src=\"placeholders/${filebasename}\" data-src=\"$filename\"|g" "$1/$html"
        if [ -f "$1/placeholders/${filebasename}" ]; then
            continue
        else
            convert $filename -blur 0x15 $1/placeholders/${filebasename}
            # wget https://via.placeholder.com/${format}.webp -O $1/placeholders/${filebasename}
        fi
    done
done