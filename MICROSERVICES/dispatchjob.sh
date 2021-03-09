#!/bin/bash
RED='\033[1;31m'
BLUE='\033[1;34m'
NC='\033[0m'
echo -e "${RED} fetching $1 ${NC}"
microservice="$(basename $1)"
cd $1
echo -e "${BLUE} running $microservice ${NC}"
php artisan ultra:queue
