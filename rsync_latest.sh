#!/bin/bash

#File Name: rsync_latest.sh
#Author: Lewis Gill -- lewisgill.com
#Source: https://github.com/lewisgilldotcom/scripts <--License file located here
#Descriptipn: Will download to your local machine, the latest 3 zip backup files on a remote server running rsync.
#This script is intended to be used with the Server Backup Spigot plugin (https://www.spigotmc.org/resources/server-backup-world-ftp-backup-1-8-1-19-multithreaded.79320/) for Minecraft and when utilised for the intended use case it will download the latest end, nether and overworld backup to your local machine since Server Backup will always make these 3 backups one after the other. 
#If you are running a Linux server that uses bash and are on a Linux host you only need to change the SSH_DETAILS and DOWNLOAD_DIR variables. It is recommened to authenticate via SSH Public Keys as rsync will ask for you password a total of four times otherwise.   

#Config

SSH_DETAILS="example@203.0.113.1"
DOWNLOAD_DIR=("/home") #Ensure you do not have a trailing slash

#Begin Script

RAW_FILES=($(rsync -r "$SSH_DETAILS":paper/Backups | grep ".*\.zip$" |tail -n 3)) #Lists all files in directory except "." & ".." in reverse order while searching with the newest file first. Will then grep for .zip files and list the latest 3. All this is stored in the RAW_FILES array

for i in "${RAW_FILES[@]##*/}" #Filter so don't get path, just get file name then iterate through files array
do
   :
   if [[ $i == *"backup"* ]]; then #Get the line that contains the backup file's name
        rsync -rtvzP "$SSH_DETAILS":paper/Backups/"$i" "$DOWNLOAD_DIR"/$i 
   fi
done
