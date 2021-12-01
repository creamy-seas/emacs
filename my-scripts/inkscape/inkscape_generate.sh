#!/usr/bin/env bash

###############################################################################
#                         $1 full path to the target file                     #
#                         $2 full path to the template file                   #
###############################################################################
SVGFILE="$1.svg"
TEMPLATE="$2"

# 1 - copy template if file does not exist
if [ -e "$SVGFILE" ]; then
    echo "==> $SVGFILE already exists"
else
    cp "$TEMPLATE" "$SVGFILE"
fi

# 2 - open the file with inkscape. Run in background
inkscape "$SVGFILE" &

# export function
function inkexport {
    BASENAME="$1"

    # export png, pdf and pdf_latex
    # inkscape --file="$BASENAME.svg"\
    #          --export-area-drawing\
    #          --without-gui\
    #          --export-pdf="$BASENAME.pdf"\
    #          --export-latex\
    #          --export-png="$BASENAME.png" 2> /dev/null

    # For inkscape 1.0
    inkscape --export-area-drawing\
             --export-latex --export-filename="${BASENAME}.pdf" \
             "${BASENAME}.svg"
    inkscape --export-area-drawing\
             --export-filename="${BASENAME}.png" \
             "${BASENAME}.svg"

    # use imagemagic to trim the png
    convert "$BASENAME.png" -trim "$BASENAME.png" 2> /dev/null

    echo "==> Exported $BASENAME"
}
export -f inkexport

# 3 - export once
inkexport "$1"

# 4 - watch the file and rerun export when it changes
# -0 means that records produced by fswatch are sliced by the NULL character
# -0 is required to match this
# -n 1 ensuret that xarsgs is evaluated for every record
# -I {} sets {} as the subsitution character
# _ {} passes the subsituted string as the command
# _ is the positional parameter 0 passed to the script (i.e. $0. Normally it is the name of the script, so we can use anything here)
fswatch -0 "$SVGFILE" | xargs -0 -n 1 -I {} bash -c 'inkexport "$@"' _ "$1"
