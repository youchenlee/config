#!/bin/bash

touch /tmp/lastrest;
POINT=`/usr/local/bin/gdate +%s`;
SEC=$((`cat /tmp/lastrest` + 300 - $POINT ))
if [ $SEC -lt 0 ]; then
    echo 0;
    if [ $SEC -lt 6]; then
        osascript -e 'display notification "停止休息" with title "時間到"';
    fi;
else
    echo `/usr/local/bin/gdate -d@$SEC -u +%M:%S`;
fi;
