#!/bin/bash

logGen() {
	LOGMESSAGE=$1
	echo "$(date "+%y-%m-%d") :: $LOGMESSAGE" >> log_backup_amarok.log
}

if [[ $1 == "-s" ]]; then
	sleep 4m
fi

cd /home/sroz9960/amarok_backups

FILENAME="amarok_$(date "+%y-%m-%d").sql"
mysqldump -u root --password=password amarok > $FILENAME
if [[ $? -eq 0 ]]; then
	tar -cf $FILENAME.tar $FILENAME && xz -z $FILENAME.tar
	if [[ $? -eq 0 ]]; then
		logGen "Backup was successful"
		rm -rf $FILENAME
	else
		logGen "Tar/xz operation failed"
	fi
else
	logGen "MySQL dump failed"
fi
