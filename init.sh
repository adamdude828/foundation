#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1;
fi


apt-get update
apt-get -y install php5 vim apache2
source config.cfg
echo "mysql-server mysql-server/root_password password $mysql_password" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $mysql_password" | debconf-set-selections
apt-get -y install mysql-server

#make user and generate key
adduser $regular_access_user --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$regular_access_user:$regular_access_user_password" | chpasswd
#need to generate key in context of user
sudo -H -u "$regular_access_user"  ssh-keygen -t rsa -N "$regular_access_user_ssh_key" -f "/home/$regular_access_user/.ssh/id_rsa" usermod -a -G admin "$regular_access_user"

if [[ "$regular_access_user" != "$regular_server_user" ]]
then
	adduser $regular_server_user --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
	echo "$regular_server_user:$regular_server_user_password" | chpasswd
	sudo -H -u "$regular_server_user"  ssh-keygen -t rsa -N "$regular_server_user_ssh_key" -f "/home/$regular_server_user/.ssh/id_rsa"
	passwd -l "$regular_server_user"
fi

sed -i "s/www-data/$regular_server_user/g" /etc/apache2/envvars 
service apache2 restart

apt-get -y install php5-mysql php5-mcrypt
service apache2 restart

cp -r files/apache2/* /etc/apache2
sed -i "s/_phpmyadminport_/$phpmyadmin_port/g" /etc/apache2/sites-enabled/server_services.conf
sed -i "s/Listen 80/NameVirtualHost *:80\nListen 80\nListen $phpmyadmin_port/g" /etc/apache2/ports.conf
service apache2 restart

mkdir -p /var/www/sites
mkdir -p /var/www/util

chown -R "$regular_server_user:$regular_server_user" /var/www

currentpath=$( pwd )
cd /var/www/util
git clone https://github.com/phpmyadmin/phpmyadmin.git

cd /var/www/util/phpmyadmin
thetagname=$( git tag | tail -1)
git checkout "$thetagname"
cd $currentpath

pwd
chmod 775 deploy_dot_files.sh
./deploy_dot_files.sh

apt-get -y install unattended-upgrades
sed -i "s/\/\/  \"${distro_id}:${distro_codename}-security\"/\"${distro_id}:${distro_codename}-security\"/g" /etc/apt/apt.conf.d/50unattended-upgrades
