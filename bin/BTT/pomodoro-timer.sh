#!/bin/bash

touch /tmp/last;
cat ~/.task/num | awk '{printf "[%s] ", $1}';
POINT=`/usr/local/bin/gdate +%s`;
SEC=$((`cat /tmp/last` + 1500 - $POINT ))
if [ $SEC -lt 0 ]; then
    echo 0;
    if [ $SEC -lt 6]; then
        osascript -e 'display notification "停止工作" with title "時間到"';
    fi;
else
    echo `/usr/local/bin/gdate -d@$SEC -u +%M:%S`;
fi;
