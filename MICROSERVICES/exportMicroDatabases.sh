#!/bin/bash

echo -n Password: 
read -s password

mysqldump -u root -p$password pastrymicrocentralachat > /home/developer/sqlscripts/pastrymicrocentralachat.sql
mysqldump --opt --where="1 limit 100" -u root -p$password  PastryMicroCaisse > /home/developer/sqlscripts/PastryMicroCaisse.sql
mysqldump -u root -p$password  PastryMicroCatalogue > /home/developer/sqlscripts/PastryMicroCatalogue.sql
mysqldump --opt --where="1 limit 100" -u root -p$password  PastryMicroCommand > /home/developer/sqlscripts/PastryMicroCommand.sql
mysqldump --opt --where="1 limit 100" -u root -p$password  PastryMicroStock > /home/developer/sqlscripts/PastryMicroStock.sql

echo "DONE"
