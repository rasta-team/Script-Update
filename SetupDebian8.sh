#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

			   red='\e[1;31m'
               green='\e[0;32m'
               NC='\e[0m'
			   
               echo -e "${red}Connecting to Rasta-Server.net...${NC}"
               sleep 0.1
			   
			   echo "Connecting to your ip :$myip"
               sleep 0.3
               
			   echo "Checking Permission..."
               sleep 0.4
               
			   echo -e "${green}Permission Accepted...${NC}"
               sleep 0.5
flag=0

wget --quiet -O ip.txt https://raw.githubusercontent.com/rasta-team/SERVER_IP_REGISTER/master/ip.txt

echo "" 
echo "        ---------[WELCOME TO RASTA-TEAM™ AUTO-SCRIPT]----------"
echo "        ====================================================="
echo "        #           WhatsApp     : +60169872312             #"
echo "        #           Telegram     : @myvpn007                #"
echo "        #                                                   #"
echo "        #       Copyright: © RASTA-TEAM™ Premium 2018       #"
echo "        ====================================================="
echo ""
read -p "Your IP Server: " -e -i $myip

echo ""
echo "Checking Permission..."
sleep 1

ip="ip.txt"

lines=`cat $ip`

for line in $lines; do

        if [ "$line" = "$myip" ];
        then
                flag=1
				echo ""
				echo -e "${green}Permission Accepted...${NC}"
				sleep 0.5
				echo ""
				echo "		==============================		"
				echo "		Thanks for using our services.		"
				echo "		==============================		"
				echo ""
        fi
		
done

if [ $flag -eq 0 ]
then
clear
echo "                                                        				 "
echo "======================================================================="
echo  "Sorry, your ip address $myip is not allowed to access this scripts"
echo "                                                        "
echo "Please contact your network administrator to access this service.
IT-Department : +0169872312
Telegram : @myvpn007"
echo "======================================================================="

rm -f /root/ip.txt
rm -f /root/SetupDebian8.sh

	exit 1
fi

sudo apt-get install dos2unix

wget https://raw.githubusercontent.com/rasta-team/Script-Update/master/FullUnlimitedDebian8.sh

dos2unix FullUnlimitedDebian8.sh

chmod +x FullUnlimitedDebian8.sh

./FullUnlimitedDebian8.sh

#REMOVE INSTALLATION FILE
rm *.sh;

cat /dev/null > ~/.bash_history && history -c
