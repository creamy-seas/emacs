#!/bin/bash


#----------------------------------------
# PDF ENGINE
#----------------------------------------
# This should be launched with the master file parameters
# 1) source any previously generated files from the "_output" directory
# 2) launch latexmk
#
# $1 base name of the master file (%s in auctex)
#----------------------------------------


#1) copy previous compilation into the master folder
mv ./auto/$1.* ./ 2> /dev/null
sleep 1

#2) run latexmk to create a pdf and run in contant update mode (pvc)
latexmk -pdf -pvc $1
