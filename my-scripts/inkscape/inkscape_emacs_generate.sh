#!/bin/bash

# 1 - copy file to the current folder
TEMPLATE="$HOME/creamy_seas/sync_files/emacs_config/ilya_scripts/inkscape/inkscape_template.svg"
SVGFILE=$1.svg

if [ -e "$SVGFILE" ]; then
    echo "==> File \"$1.svg\" already exists"
else
    cp $TEMPLATE $SVGFILE
fi

# 2 - open the file
inkscape "$SVGFILE" &

# 3 - export image to latex after inkscape is closed
#wait %1
#inkscape_export.sh $SVGFILE
