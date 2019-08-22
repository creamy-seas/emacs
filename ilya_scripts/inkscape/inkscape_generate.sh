#!/bin/bash

# 1 - copy file to the current folder
template="$HOME/creamy_seas/sync_files/emacs_config/ilya_scripts/inkscape/inkscape_template.svg"
svgFile="$1.svg"

if [ -e "$svgFile" ]; then
    echo "==> File \"$1.svg\" already exists"
else
    cp "$template" "$svgFile"  
fi

# 2 - open the file
inkscape "$svgFile" &

# 3 - export image to latex after inkscape is closed
wait %1
inkscape --file="$svgFile" --export-area-drawing --without-gui --export-pdf="$1.pdf" --export-latex --export-png="$1_temp.png"

# 4 - create png and trim edges
convert "$1_temp.png" -trim "$1.png"
rm "$1_temp.png"
