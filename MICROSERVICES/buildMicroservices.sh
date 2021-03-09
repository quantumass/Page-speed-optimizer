#!/bin/bash

echo -n  Username: 
read username
echo -e "\n" 
echo -n  Password: 
read -s password
echo -e "\n" 
echo -n Branch: 
read  branch
echo -e "\n" 

scriptFile='/home/developer/scripts/build.sh'
baseFolder='/home/developer/microservices/'
folders=('queuems' 'cataloguev2ms' 'precisionfrontv2' 'precisionadmin' 'cataloguems' 'labms' 'tempcommandms' 'centralachatms' 'entreprisems' 'authms' 'stockms' 'caissems' 'filems' 'notificationms')
#folders=('cataloguems' 'labms' 'entreprisems' 'authms' 'stockms' 'caissems')
#folders=('queuems' 'cataloguev2ms' 'tempcommandms' 'centralachatms' 'filems')
echo "" > building.log
for folder in ${folders[@]};
do
  echo "WORKING ON ${baseFolder}${folder}"
  echo "WORKING ON ${baseFolder}${folder}" >> building.log
{ # try
  "${scriptFile}" "${baseFolder}${folder}" "${username}" "${password}" "${branch}"
} || { # catch
  echo "FAILED ON ${baseFolder}${folder}" >> building.log
}
done
