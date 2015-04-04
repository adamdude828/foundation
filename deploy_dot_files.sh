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
    runFromHere $1 "sudo -u $1 rm -rf $2"
    runFromHere $1 "sudo -u $1 ln -s ${current_location}files/dot/$2 $2"
#    usermod -aG dotfiles $1
}

for user in $(find /home/ -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do
    linkResource "/home/$user/" ".vim"
    linkResource "/home/$user/" ".bashrc"
    linkResource "/home/$user/" ".vimrc"
done

linkResource "/root" ".vim"
linkResource "/root" ".bashrc"
linkResource "/root" ".vimrc"

