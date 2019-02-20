#!/bin/bash


#----------------------------------------
# PDF ENGINE
#----------------------------------------
# Using the direcotry that BUILD was launched from 
# 1) determine if we are in the master directory of the latex project
# 2) source any generated files from the "_output" directory
# 3) launch latexmk
#
# $1 name of the master file (%s in auctex)
#----------------------------------------


#1) check if the master file is in this directory
if [ -f $1 ]; then
    #2) if the master file is in this directory, all operations done locally
    relMastDir="."
else
    #3) if there is no master file, all operations are done on the parent directory
    relMastDir="."
fi

#4) copy previous compulation into the master folder
mv $relMastDir/_output/$1.* $relMastDir 2> /dev/null

#5) run latexmk to create a pdf and run in contant update mode (pvc)
latexmk -pdf -pvc $1
