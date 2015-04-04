#!/usr/bin/env bash

runFromHere() {
     #capture current path
     currentPath=$(pwd)

     #move to temp spot
     cd $1

     #run command
     $2

     #go back to old path
     cd "$currentPath"
}

installDb() {
    echo "mysql-server mysql-server/root_password password $mysql_password" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $mysql_password" | debconf-set-selections
    apt-get -y install mysql-server
}

createUsers() {
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
}

getCurrentLocation() {
    DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    current_location="$DIR/$1"
}