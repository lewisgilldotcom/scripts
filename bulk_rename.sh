#!/bin/bash
#File Name: bulk_rename.sh
#Author: Lewis Gill -- lewisgill.com
#Source: https://github.com/lewisgilldotcom/scripts <--License file located here
#Description: Removes a given string from the names of all files / folders in a directory. Add the string you wish to remove to the REMOVE_STRING variable then run script. 

#Config

REMOVE_STRING=""

#Begin Script

for file in *
do
	if [ "$file" != "bulk_rename.sh" ] ; then
    		mv "${file}" "${file/"$REMOVE_STRING"/}"
	fi
done

