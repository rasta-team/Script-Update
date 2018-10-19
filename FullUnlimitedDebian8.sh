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

# go to root
cd

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# Install Pritunl
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" > /etc/apt/sources.list.d/mongodb-org-3.0.list
echo "deb http://repo.pritunl.com/stable/apt jessie main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7F0CEB10
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv CF8E292A
apt-get update
apt-get -y upgrade
apt-get -y install pritunl mongodb-org
service pritunl start

# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/muchigo/VPS/master/conf/squid.conf" 
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# Enable Firewall
apt-get -y install ufw
sudo ufw allow 22,80,81,222,443,8080,9700,60000/tcp
sudo ufw allow 22,80,81,222,443,8080,9700,60000/udp
sudo yes | ufw enable

# Install Web Server
apt-get -y install nginx php5-fpm php5-cli
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/muchigo/VPS/master/conf/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by Nawfal</pre>" > /home/vps/public_html/index.html
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/muchigo/VPS/master/conf/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

# Install Vnstat
apt-get -y install vnstat
vnstat -u -i eth0
sudo chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

# Install Vnstat GUI
cd /home/vps/public_html/
wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 vnstat
cd vnstat
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
cd

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i 's/Port 22/Port  22/g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=441/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service ssh restart
service dropbear restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.850_all.deb"
dpkg --install webmin_1.850_all.deb;
apt-get -y -f install;
rm /root/webmin_1.850_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
service vnstat restart

wget https://raw.githubusercontent.com/rasta-team/Script-Update/master/update-script
chmod +x update-script
./update-script

# Install SSH autokick
cd
wget https://raw.githubusercontent.com/muchigo/VPS/master/Autokick-debian.sh
bash Autokick-debian.sh

# Install Menu
cd
wget https://raw.githubusercontent.com/rasta-team/Script-Update/master/menu
mv ./menu /usr/local/bin/menu
chmod +x /usr/local/bin/menu

#REMOVE INSTALLATION FILE
rm *.sh;

cat /dev/null > ~/.bash_history && history -c

# About
clear
echo "Script ini hanya mengandungi :-"
echo "-Pritunl"
echo "-MongoDB"
echo "-Web Server"
echo "-Squid Proxy  Port 8080, 60000"
echo "-Vnstat"
echo "-Webmin"
echo "-Dropbear Port 441"
echo "-Open SSH Port 22"
echo "Jika ada tambahan sila tambah sendiri ye =)"
echo "Sila login ke pritunl untuk proceed step seterusnya"
echo " "
echo "Disediakan Oleh Kiellez"
echo "TimeZone   :  Malaysia"
echo "Vnstat     :  http://$MYIP:81/vnstat"
echo "Pritunl    :  https://$MYIP"
echo "Webmin     :  http://$MYIP:10000"
echo "Username Pritunl : pritunl"
echo "Password Pritunl : pritunl"
echo "Sila copy code dibawah untuk Pritunl anda"
pritunl setup-key

