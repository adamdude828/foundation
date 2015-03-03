#!/bin/bash

for i in $(find /home/ -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
do
	echo $i
done
