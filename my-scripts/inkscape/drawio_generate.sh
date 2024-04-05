#!/usr/bin/env bash

###############################################################################
#                         $1 full path to the target file                     #
#                         $2 full path to the template file                   #
###############################################################################
DRAWIO_FILE="$1.drawio"
TEMPLATE="$2"

# Extract out file_name_<p9> to get a specific page
PAGE=$(echo $1 | sed 's/.*_<p\([0-9]\{1,\}\)>/\1/')

# re='^[0-9]+$'
# if ! [[ $PAGE =~ $re ]] ; then
#     PAGE=1;
# fi
echo $PAGE

# 1 - copy template if file does not exist
if [ -e "$DRAWIO_FILE" ]; then
    echo "==> $DRAWIO_FILE already exists"
else
    cp "$TEMPLATE" "$DRAWIO_FILE"
fi

# 2 - open the file with and run in background
drawio "$DRAWIO_FILE" &

# export function
function image_export {
    BASENAME="$1"

    # Export, transparent, svg/png, first page, 200 scale
    drawio --export "$1.drawio" --output "$1.svg" --transparent --page-index 1 --scale 200
    drawio --export "$1.drawio" --output "$1.png" --transparent --page-index 1

    echo "==> Exported $BASENAME"
}
export -f image_export

# 3 - export once
image_export "$1"

# 4 - watch the file and rerun export when it changes
# -0 means that records produced by fswatch are sliced by the NULL character
# -0 is required to match this
# -n 1 ensuret that xarsgs is evaluated for every record
# -I {} sets {} as the subsitution character
# _ {} passes the subsituted string as the command
# _ is the positional parameter 0 passed to the script (i.e. $0. Normally it is the name of the script, so we can use anything here)
fswatch -0 "$DRAWIO_FILE" | xargs -0 -I {} bash -c 'image_export "$@"' _ "$1"
