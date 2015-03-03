#!/bin/bash

moveDotFiles() {
	current_home="$2"	
	sudo -H -u $1 cp  files/dot/.vimrc $current_home 
	sudo -H -u $1 cp  files/dot/.bashrc $current_home	
	sudo -H -u $1 cp -r files/dot/.vim $current_home
}

checkoutSubModule() {
	currentPath=$( pwd )
	sub_module_path="$currentPath/vim_sub_modules.txt"
	cd $2 
	cd .vim && rm -rf bundle
	sudo -H -u $1 mkdir bundle
	cd bundle
	while read line; do
		sudo -H -u $1 git clone $line
	done < $sub_module_path 
	cd $currentPath
}

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1;
fi

for user in $(find /home/ -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do
	moveDotFiles $user "/home/$user/"
	checkoutSubModule $user "/home/$user/"
done


moveDotFiles "root" "/root"
checkoutSubModule "root" "/root"

