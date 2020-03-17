#!/usr/bin/env bash

#----------------------------------------
# JEW ENGINE
#----------------------------------------
# Using the direcotry that clean was launched from
# 1) create an "auto" directory if it does not exist
# 2) move the compulation files into that folder
#
# $1 name of the master file (%s in auctex)
#----------------------------------------

#1) clean the auto directory
mkdir -p auto 2> /dev/null
# rm -r */_region_* 2> /dev/null
# rm prv* 2> /dev/null
# rm -r _region* 2> /dev/null

#2) copy all the files into there
echo "Removing files: " $1.{aux,bbl,blg,fdb_latexmk,fls,log,out,toc,bcf,run.xml,el}
mv -f $1.{aux,bbl,blg,fdb_latexmk,fls,log,out,toc,bcf,run.xml,nav,snm,el} ./auto 2> /dev/null
