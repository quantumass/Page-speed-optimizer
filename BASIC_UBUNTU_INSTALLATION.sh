##CREATED BY QUANTUMASS
#THE POWER OF THE HUMAN

#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${BLUE} This script is for installing Vapor on Ubuntu 16.04 ${NC}"

echo "
        HERE ARE THE STEPS FEEL FREE TO SKIP
        [1] INIT INSTALLING
        [2] ADDING USER
        [4] INSTALLING GIT/NPM
        [5] CHANGING SSH PORT
        [6] INSTALLING FAIL TO BAN
        [7] INSTALLING CLAMAV FOR HEALTH CHECK
        [15] ADDING FIREWALL RULES
"

read -p "Please enter from which step the script should run [1] : " stepvar
stepvar=${stepvar:-1}

uservar="developer"
passvar=`openssl rand -base64 32`
if [ $stepvar -gt 2 ]
then
      passvar="NULL"
fi
sshvar="777"

echo "
   ===================================
   user name: ${uservar} \n
   user password: ${passvar} \n
   ssh port: ${sshvar} \n
   ===================================
" >> ./secure.txt

echo "starting log" > ./init.log

apt-get update -y

# ======================================== 1] INIT INSTALLING
if [ $stepvar -lt 2 ]
then
        apt-get install curl -y
        apt-get install expect -y
        ip=`curl -s https://api.ipify.org`
        echo "server IP [${ip}]" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} server IP [${ip}] ${NC} =============== "

        echo "curl/expect is installed" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} curl/expect is installed ${NC} =============== "
fi
# ======================================== 2] ADDING USER
if [ $stepvar -lt 3 ]
        then
        useradd -m -s /bin/bash $uservar || true #create the user
        echo "the user ${uservar} has been created" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} the user ${uservar} has been created ${NC} =============== "

        echo "${uservar}:${passvar}" | chpasswd

        echo "password added to the user" >> ./init.log 2>&1

        echo -e " =============== ${BLUE} password added to the user ${NC} =============== "


        usermod -aG sudo $uservar #add him to sudors
        echo "the user is added to the sudo group" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} the user is added to the sudo group ${NC} =============== "
fi
# ======================================== 4] INSTALLING GIT/NPM
if [ $stepvar -lt 5 ]
then
        apt-get install git-core -y
        echo "git is installed" >> ./init.log 2>&1
        curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh #to get the script NodeSource PPA which containt node
        bash nodesource_setup.sh #run the script
        apt-get install nodejs -y #to install nodejs
        apt-get install build-essential -y #in order for some npm packages to work
        npm -g install yarn
        echo "npm/yarn is installed" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} git/npm is installed ${NC} =============== "
fi
# ======================================== 5] CHANGING SSH PORT
if [ $stepvar -lt 6 ]
then
sed -i -e "0,/Port 22/s//Port $sshvar/" /etc/ssh/sshd_config
sed -i -e "0,/#Port $sshvar/s//Port $sshvar/" /etc/ssh/sshd_config
service sshd restart
echo "ssh is now working on port ${sshvar}" >> ./init.log 2>&1
echo -e " =============== ${BLUE} ssh is now working on port ${sshvar} ${NC} =============== "
fi
# ======================================== 6] INSTALLING FAIL TO BAN
if [ $stepvar -lt 7 ]
then
        apt-get update -y #update all the packages
        apt-get install fail2ban -y #install fail2ban
        awk '{ printf "# "; print; }' /etc/fail2ban/jail.conf | tee /etc/fail2ban/jail.local #to create presests for fail2Ban
        echo "
        [DEFAULT]
        # Ban hosts for one hour:
        bantime = 3600

        # Override /etc/fail2ban/jail.d/00-firewalld.conf:
        banaction = iptables-multiport

        [sshd]
        enabled = true
        "> /etc/fail2ban/jail.conf
        systemctl restart fail2ban
        echo "fail2ban is configured/installed" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} fail2ban is configured/installed ${NC} =============== "
fi
# ======================================== 7] INSTALLING CLAMAV FOR HEALTH CHECK
if [ $stepvar -lt 8 ]
then
        echo y | apt-get install clamav clamav-daemon
        #write out current crontab
        crontab -l -u $uservar > mycron || true
        #echo new cron into cron file
        echo "00 00 * * * clamscan -r / " >> mycron
        #install new cron file
        crontab -u $uservar mycron
        rm mycron
        echo "clamav is configured/installed" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} clamav is configured/installed ${NC} =============== "
fi
# ======================================== 15] ADDING FIREWALL RULES
if [ $stepvar -lt 16 ]
then
        apt -y install ufw
        ufw --force disable
        ufw --force reset
        ufw logging on
        ufw default deny incoming
        ufw default deny outgoing
        ufw allow out proto udp from any to 8.8.8.8 port 53 # dns out
        ufw allow out proto tcp from any to any port 25 # smtp out
        ufw allow out proto tcp from any to any port 465 # smtp out
        ufw allow out proto tcp from any to any port 587 # smtp out
        ufw allow out proto tcp from any to any port 80 # http out
        ufw allow out proto tcp from any to any port 443 # https out
        ufw allow in proto tcp from any to any port ${sshvar} # ssh in
        ufw allow in proto tcp from any to any port 80 # web in
        ufw allow in proto tcp from any to any port 443 # https in
        IPV6=no # disable IPV6
        echo -e "\n" >> /etc/default/ufw # disable IPV6
        echo "IPV6=no" >> /etc/default/ufw # disable IPV6
        sed -i '/icmp/ s/ACCEPT/DROP/' /etc/ufw/before.rules # disallow ICMP
        ufw --force enable
        ufw status numbered # show the new rules with numbers
        echo "firewall is configured" >> ./init.log 2>&1
        echo -e " =============== ${BLUE} firewall is configured ${NC} =============== "
fi