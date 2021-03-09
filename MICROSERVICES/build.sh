#!/bin/bash

set -e

RED='\033[1;31m'
BLUE='\033[1;34m'
NC='\033[0m'

echo -e "${RED} fetching $1 ${NC}"
mkdir -p $1 || true
microservice="$(basename $1)"

./clone.exp $1 $2 $3 $4
cd $1

if [ "$microservice" = "centralachatms" ] || [ "$microservice" = "cataloguev2ms" ] || [ "$microservice" = "tempcommandms" ] || [ "$microservice" = "queuems" ] || [ "$microservice" = "filems" ]; then
	if [ "$microservice" = "queuems" ]; then
		php artisan migrate
	else
		php artisan ultra:migrate
	fi
	find . -type f -exec chmod 644 {} \;
	find . -type d -exec chmod 755 {} \;
	chmod -R 777 ./storage/
	chmod -R 777 ./bootstrap/
elif [ "$microservice" = "notificationms" ] || [ "$microservice" = "precisionfrontv2" ] || [ "$microservice" = "precisionadmin" ] ; then
	echo y | yarn install
	if [ "$microservice" = "precisionfrontv2" ] || [ "$microservice" = "precisionadmin" ] ; then
		echo y | yarn build
	fi
	find . -type f -exec chmod 644 {} \;
	find . -type d -exec chmod 755 {} \;
else
	chmod -R 777 .build
	echo y | swift build
	find . -type f -exec chmod 644 {} \;
	find . -type d -exec chmod 755 {} \;
fi
echo -e "${BLUE} FINISHED SUCCESSFULLY $microservice ${NC}"