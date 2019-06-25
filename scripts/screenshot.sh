#!/usr/bin/env bash
#
# A simple screenshot script. Very handy for calling a specific from a window
# manager using custom hotkeys (eg: i3)
#
# Requirements:
#   imagemagick
#
savePath=~/Pictures/screencaps/

if [[ ! -d $savePath ]]; then
	mkdir -p $savePath
fi

# Wait two seconds
sleep 1;

# Get our file suffix
date=$(date '+%Y%m%d-%T')

# And action!
import $savePath/screen.$date.png
