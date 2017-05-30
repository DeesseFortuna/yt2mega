#!/bin/bash
CHANNELname="$1" #just pass in the channel name
VIDEOSlink="https://www.youtube.com/user/$CHANNELname/videos"
MEGAuser="" #mega account details
MEGApass=""
MEGApath="/Root/YouTube-Backups-$CHANNELname/" #customize if you wish, but script was written for folders in /Root/

#set up temp file names
TMP="YTlist.txt"
TMPm="MEGAlist.txt"

#clear them
> $TMP
> $TMPm

#make a list of files in the mega account
megals -u $MEGAuser -p $MEGApass > $TMPm

#remove /Trash/ entries from the list
sed -i 's/^\/Trash.*//g' $TMPm

#if the upload directory doesn't exist, make it
#NOTE: Only handles one folder level past /Root/
if ! grep -qr $MEGApath $TMPm ; then
	megamkdir -u $MEGAuser -p $MEGApass $MEGApath
fi

#make list of all the videos' playlist index, URL, and ID, old to new
#this will skip any videos flagged for copyright or blocked in your country, but the indexes will show those gaps
#remove --playlist-reverse if you want 001 to be the most recent video
youtube-dl -i --playlist-reverse --skip-download --get-filename -o '%(playlist_index)s - %(title)s [%(id)s]' $VIDEOSlink | tee -a $TMP

#loop over each line in the list, each representing a video that is still live
while IFS='' read -r line || [[ -n "$line" ]]; do
	cd ./dl/ #descend into the download directory for ease of scripting
	NUM=${line:0:3} #extract the first 3 chars of the line representing the playlist index
	CURRENTid=${line: -12:11} #extract the ID from the end of the line, always 11 long
	if ! grep -qr $CURRENTid ./../$TMPm ; then #check if the ID is found in the list of files on MEGA
		youtube-dl -o '%(title)s [%(id)s].%(ext)s' -f best --merge-output-format webm https://youtu.be/$CURRENTid #if not, download it
		FILE=`ls | head -1` #since ideally just one file is left when yt-dl is done, a kludge to get the filename
		mv "$FILE" "$NUM - $FILE" #prepend playlist index to the filename
		FILE=`ls | head -1` #get the new name
		megaput -u $MEGAuser -p $MEGApass --path=$MEGApath "$FILE" #shove it at MEGA
		rm -rf ./* #clean for next video
	fi
	cd ./../ #ascend one level for the loop to work
done < $TMP
