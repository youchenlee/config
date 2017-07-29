#!/bin/bash
date +%s > /tmp/last;
oldnum=`cat ~/.task/num`;
newnum=`expr $oldnum + 1`;
echo $newnum > ~/.task/num

