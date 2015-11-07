#!/bin/bash

# Name: copper.sh
# Description: Shell script which finds the album art used by Amarok
# and copys to my rockbox ipod
# Author: Stephen Rozanc
# Date: April 2015

# Our Picture directory; the source:
picDir="/home/sroz9960/.kde/share/apps/amarok/albumcovers/cache"

# Destination of iPod .. Where we are copying pictures to:
ipodDir="/media/iPodClassic"

copyCovers() {

	# Iterate over our Amarok Query:
	while IFS=^ read artist album; do
		
		# Get our hash:
		inputfile=$(echo -n $artist$album | tr '[:upper:]' '[:lower:]' | md5sum -)
		
		# Strip trailing characters
		inputfile=${inputfile%???}
		
		# Ok; this is our picture file:
		srcPic="${picDir}/130@${inputfile}"

		# If it legitimately exists:
		if [ -f "$srcPic" ]; then
		
			# Prepare our copy directory path; convert "The Devil Wears Prada" to "Devil Wears Prada, The"
			if ( grep -Pq "^The " <<< "$artist" ) ; then
				artist=${artist#The }
				artist="${artist}, The"
			fi

			# Replace : with _
			artist=$(sed 's/:/_/g' <<< "$artist")
			album=$(sed 's/:/_/g' <<< "$album")
		
			# He Shoots and Scores:
			convert "$srcPic" -resize 130x130 "$ipodDir"/"$artist"/"$album"/cover.jpg
		fi
	done
}

# == Entry ==

# Let's query Amarok:
dcop amarok collection query "SELECT DISTINCT CONCAT(artist.name,'^',album.name) FROM album, artist, tags WHERE album.id = tags.album AND artist.id = tags.artist" | copyCovers;

# Let's pull out of the path of existing music collection:
dcop amarok collection query "SELECT DISTINCT CONCAT(artist,'^',album,'^',path) FROM images" | while IFS=^ read artist album path; do
	
	# Folder.jpg File:
	if ( grep -Pq "Folder.jpg$" <<< "$path" ); then
		
			path=$(sed 's/^\.//g' <<< "$path")

                        if ( grep -Pq "^The " <<< "$artist" ) ; then
                                artist=${artist#The }
                                artist="${artist}, The"
                        fi
	
                        artist=$(sed 's/:/_/g' <<< "$artist")
                        album=$(sed 's/:/_/g' <<< "$album")

			convert "$path" -resize 130x130 "$ipodDir"/"$artist"/"$album"/Folder.jpg
	fi
done
