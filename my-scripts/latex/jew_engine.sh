#!/usr/bin/env bash
#
#----------------------------------------
# Using the direcotry that clean was launched from
# 1) create an "auto" directory if it does not exist
# 2) move the compulation files into that folder
#
# $1 name of the master file (%s in auctex)
#----------------------------------------

#1) clean the auto directory
# mkdir -p auto 2> /dev/null

# #2) move all the files that exist
# ending_array=( aux bbl blg fdb_latexmk fls log out toc bcf run.xml nav snm el )

# for ending in "${ending_array[@]}"
# do
#     temp_file="$1.$ending"
#     if [ -f $temp_file ]; then
# 	echo "Removing '$temp_file'"
# 	mv -f "$temp_file" ./auto
#     fi
# done
