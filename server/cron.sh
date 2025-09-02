#!/bin/bash

dir=$(cd `dirname $0` && pwd)
envFile=$(ls -l $dir/.env | awk '{print $NF}')

# load config
source $envFile

# generate data
cd $dir
./data.sh

# create screenshot
cd $dir/public

if ! type firefox &> /dev/null && [[ -d "/Applications/Firefox.app/Contents/MacOS/" ]]; then
  PATH="$PATH:/Applications/Firefox.app/Contents/MacOS"
fi

firefox --screenshot http://localhost:$DISPLAY_SERVER_PORT --window-size=600,800
pngcrush -c 0 screenshot.png display.png
# firefox --screenshot http://localhost:$DISPLAY_SERVER_PORT --window-size=600,800 && pngcrush -c 0 screenshot.png display.png
# firefox --screenshot http://localhost:$DISPLAY_SERVER_PORT/color --window-size=600,800 && gm convert  screenshot.png display.jpg
