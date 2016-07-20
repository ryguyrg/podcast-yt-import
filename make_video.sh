#!/bin/bash

MP3FILE=$1
LABELTEXT=$2
MP4FILE=`echo "$1" | sed "s/\.mp3/-video\.mp4/"`

convert -border 100 -bordercolor none -background none -fill white -font "Calibri-Bold" -antialias -size 890x415 caption:"$LABELTEXT" miff:- |    composite -gravity west -geometry +0+3 - PodcastCover-NoTitle.png   anno_composite.jpg

cat "$MP3FILE" | ffmpeg -loop 1 -i anno_composite.jpg -i - -shortest -c:v libx264 -c:a aac -strict -2 -b:a 192k -pix_fmt yuv420p "${MP4FILE}"

