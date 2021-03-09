#!/bin/bash

set -e

read -p "Enter the username of the database : " user
read -p "Enter the password of $user : " password

mysql -u $user -p$password -A --skip-column-names -e"SELECT DISTINCT table_schema FROM information_schema.tables WHERE table_schema NOT IN ('information_schema','mysql','performance_schema','phpmyadmin','sys')" > databases.txt;

COMMIT_COUNT=0
COMMIT_LIMIT=10
for DB in `cat databases.txt`; do
    mysqldump -u $user -p$password --hex-blob --routines --triggers ${DB} | gzip > ${DB}.sql.gz &
    (( COMMIT_COUNT=COMMIT_COUNT+1 ))
    if [ ${COMMIT_COUNT} -eq ${COMMIT_LIMIT} ]; then
        COMMIT_COUNT=0
        wait
    fi
done

if [ ${COMMIT_COUNT} -gt 0 ]; then
    wait
fi