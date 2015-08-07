#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1;
fi

source functions.sh
git submodule init
git submodule update

groupadd dotfiles
#getCurrentLocation
#chown -R :dotfiles ${current_location}files/
#chmod -R g+x ${current_location}files/

linkResource() {
    getCurrentLocation
    runFromHere $1 "sudo -u $2 rm -rf $3"
    runFromHere $1 "sudo -u $2 ln -s ${current_location}files/dotxennsoft/$3 $3"
#    usermod -aG dotfiles $1
}

for user in $(find /home/ -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do
    linkResource "/home/$user/" $user ".vim"
    linkResource "/home/$user/" $user  ".bashrc"
    linkResource "/home/$user/" $user ".vimrc"
done

linkResource "/root" "root" ".vim"
linkResource "/root" "root" ".bashrc"
linkResource "/root" "root" ".vimrc"

