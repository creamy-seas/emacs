#!/bin/bash


#----------------------------------------
# JEW ENGINE
#----------------------------------------
# Using the direcotry that clean was launched from 
# 1) create an "_output" directory if it does not exist
# 2) move the compulation files into that folder
#
# $1 name of the master file (%s in auctex)
#----------------------------------------

#1) remove and copy the generate "_output" directory in the master directory
#rm -r ./auto 2> /dev/null
mkdir -p _output

#2) copy all the files into there. 3 times, because the script quits prematurely for some reason, so need to be repeated
#mv -f ./$1.* ./_output 2> /dev/null
#mv "_output/$1."{pdf,tex} . 2> /dev/null
#mv -f ./$1.* ./_output 2> /dev/null

echo -f $1.{aux,bbl,blg,fdb_latexmk,fls,log,out,synctex.gz} _output
mv -f $1.{aux,bbl,blg,fdb_latexmk,fls,log,out,synctex.gz} ./_output

#echo $(ls -l)
#mv -f $1.{aux,bbl,blg,fdb_latexmk,fls,log,out,synctex.gz} ./_output
#mv -f $1.{aux,bbl,blg,fdb_latexmk,fls,log,out,synctex.gz} ./_output
#cp -p "./_output/"*".pdf" . 2> /dev/null
#cp -p "./_output/"*".tex" . 2> /dev/null
