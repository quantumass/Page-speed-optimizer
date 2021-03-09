#!/bin/bash

set -e

BASEDIR=$(dirname "$0")

for file in $BASEDIR/*; do
    sed -i 's#/nuxt#nuxt#g' $file
done

for file in $BASEDIR/*/*; do
    sed -i 's#/nuxt#nuxt#g' $file
done