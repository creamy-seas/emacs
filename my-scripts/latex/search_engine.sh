#!/bin/bash


#----------------------------------------
# SEARCH ENGINE
#----------------------------------------
# Using the direcotry that search was launched from 
# 1) determine if we are in the master directory of the latex project
# 2) source the "synctex.gz" files from the "_output" directory
# 3) launch skim
#
# $1 name of the master file (%s in auctex)
# $2 line number we are on %n
# $3 the name of the output pdf file to open %o
# $4 the full path to the current file %b
#----------------------------------------


#1) check if the master file is in this directory
if [ -f $1 ]; then
    #2) if the master file is in this directory, all operations done locally
    relMastDir="."
else
    #3) if there is no master file, all operations are done on the parent directory
    relMastDir="."
fi

#3) copy the "synctex.gz" file that is required for viewing
mv $relMastDir/_output/$1.synctex.gz $relMastDir 2> /dev/null

#4) launch the skim viewer
/Applications/Skim.app/Contents/SharedSupport/displayline -b -g $2 $3 $4

#5) move file back
#mv $relMastDir/$1.synctex.gz $relMastDir/_output 2> /dev/null
