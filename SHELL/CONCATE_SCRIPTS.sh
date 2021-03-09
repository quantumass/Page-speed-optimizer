#!/bin/bash

set -e

htmls=(index.html)
BASEDIR=$(dirname "$0")

for html in $htmls; do
    cp $BASEDIR/$html $BASEDIR/${html}.backup
done

for html in $htmls; do
    files=`grep -Po '<link[^>]*href="\K[^"]*(?=")' $BASEDIR/$html`
    mkdir -p assets/css/${html}-page/
    echo "" > ./assets/css/${html}-page/main.css
    for file in $files; do
        filebasename=${file##*/}
        echo "FILENAME: " "${filebasename}"
        if test -f "./$file"; then
            echo -e "\n" >> $BASEDIR/assets/css/${html}-page/main.css
            echo "/* ----------AUTO CONCATINATION---------------- */" >> $BASEDIR/assets/css/${html}-page/main.css
            echo -e "\n" >> $BASEDIR/assets/css/${html}-page/main.css
            cat "./$file" >> ./assets/css/${html}-page/main.css
            sed -i "s|href=\"$file\"|src=\"\"|g" "$BASEDIR/$html"
        fi
    done
    sed -i "s|</head>|<link rel=\"stylesheet\" href=\"assets/css/${html}-page/main.css\" /></head>|g" "$BASEDIR/$html"
done

for html in $htmls; do
    files=`grep -Po '<script[^>]*src="\K[^"]*(?=")' $BASEDIR/$html`
    mkdir -p assets/js/${html}-page/
    echo "" > $BASEDIR/assets/js/${html}-page/main.js
    for file in $files; do
        filebasename=${file##*/}
        echo "FILENAME: " "${filebasename}"
        if test -f "./$file"; then
            echo -e "\n" >> $BASEDIR/assets/js/${html}-page/main.js
            echo "/* ----------AUTO CONCATINATION---------------- */" >> $BASEDIR/assets/js/${html}-page/main.js
            echo -e "\n" >> $BASEDIR/assets/js/${html}-page/main.js
            cat "./$file" >> $BASEDIR/assets/js/${html}-page/main.js
            # sed -i "s|src=\"$file\"|src=\"\"|g" "$BASEDIR/$html"
        fi
    done
    sed -i "s|</body>|<script src=\"assets/js/${html}-page/main.js\" /></body>|g" "$BASEDIR/$html"
done