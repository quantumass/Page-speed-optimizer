#!/bin/bash

set -e

read -p "Enter the username of the database : " user
read -p "Enter the password of $user : " password

COMMIT_COUNT=0
COMMIT_LIMIT=10

for file in mysql-backups-090321/*.sql.gz; do
    DB=`echo ${file##*/} | sed -e "s/\.sql\.gz$//"`
    echo "IMPORTING TO $DB"
    mysql -u $user -p$password -e "DROP DATABASE IF EXISTS $DB;"
    mysql -u $user -p$password -e "CREATE DATABASE IF NOT EXISTS $DB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"
    gunzip < $file | mysql -u $user -p$password -D $DB --default-character-set=utf8 --binary-mode=1 &
    (( COMMIT_COUNT=COMMIT_COUNT+1 ))
    if [ ${COMMIT_COUNT} -eq ${COMMIT_LIMIT} ]; then
        COMMIT_COUNT=0
        wait
    fi
done

if [ ${COMMIT_COUNT} -gt 0 ]; then
    wait
fi


