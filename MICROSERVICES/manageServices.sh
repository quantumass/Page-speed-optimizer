#!/bin/bash
microServices=(microcaisse microlab microcatalogue microqueuejob microentreprise microgateway microstock micronotification)
for microbe in "${microServices[@]}"
do
    echo "================================"
    echo "=========== $microbe "
    echo "================================"
    sudo systemctl "$1" "$microbe".service
done 
