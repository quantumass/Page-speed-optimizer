#!/bin/bash
microServices=(caissems cataloguems entreprisems authms stockms labms)
for microbe in "${microServices[@]}"
do
    echo "============ ============ ============"
    echo "============ cleanning $microbe  "
    find ~/microservices/${microbe}/Logs/*.log -mtime +7
    echo "============ ============ ============"
    find ~/microservices/${microbe}/Logs/*.log -mtime +7 -exec rm -f {} \;
done
laravelMicroServices=(commandems centralachatms queuems)
for microbe in "${laravelMicroServices[@]}"
do
    echo "============ ============ ============"
    echo "============ cleanning $microbe laravel  "
    find ~/microservices/${microbe}/storage/logs/*.log -mtime +7
    echo "============ ============ ============"
    find ~/microservices/${microbe}/storage/logs/*.log -mtime +7 -exec rm -f {} \;
done
