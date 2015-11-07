#!/bin/bash

# Name: Healing.sh
# Author: Stephen Rozanc
# Simple healing script for fixing up my music collection

IFS=$'\n'
MUSICDIR="/media/64Bit/Music"
LOGFILE="/tmp/musicfix.log"

exec 2>&-

touch "$LOGFILE" || ( echo "Unable To Create Log File" )

[ -w "$LOGFILE" ] &&
        ( for i in $(find "$MUSICDIR" -type f -iname "*.mp3"); do 
                mp3val -f -nb "$i" | grep FIXED >> $LOGFILE
        done ) || ( echo "Chosen Log File is not writable"; exit 1 )
