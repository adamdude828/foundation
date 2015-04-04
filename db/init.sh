#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1;
fi

source ../functions.sh
source ../config.cfg

apt-get update
apt-get install vim
installDb

createUsers



