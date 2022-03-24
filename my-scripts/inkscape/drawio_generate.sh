#!/usr/bin/env bash

###############################################################################
#                         $1 full path to the target file                     #
#                         $2 full path to the template file                   #
###############################################################################
DRAWIO_BIN="/Applications/draw.io.app/Contents/MacOS/draw.io"
DRAWIO_FILE="$1.drawio"
TEMPLATE="$2"

# 1 - copy template if file does not exist
if [ -e "$DRAWIO_FILE" ]; then
    echo "==> $DRAWIO_FILE already exists"
else
    cp "$TEMPLATE" "$DRAWIO_FILE"
fi

# 2 - open the file with and run in background
$DRAWIO_BIN "$DRAWIO_FILE" &

# export function
function image_export {
    BASENAME="$1"

    # Export, transparent, svg/png, first page, 200 scale
    /Applications/draw.io.app/Contents/MacOS/draw.io -x -t -f svg -p 1 -s 200 "$1.drawio"

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
fswatch -0 "$DRAWIO_FILE" | xargs -0 -n 1 -I {} bash -c 'image_export "$@"' _ "$1"
