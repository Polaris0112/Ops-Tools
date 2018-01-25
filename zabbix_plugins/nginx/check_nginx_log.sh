#!/bin/bash
#T=`date --date='1 minutes ago' +'%F %H'`
#T='02/Apr/2015:14:10:03'
#T="2015/06/22"
T=`date -d '1 minutes ago' +'%Y/%m/%d %H:%M'`
#|awk -F":" '{print $1}'|uniq|awk -F"/" '{print $NF}'|sed ':a ; N;s/\n/ / ; t a ;'`
Test=`echo $3 | awk '{gsub(/\@/,"|");print}'`

if [ -z "$Test" ];then
	Test="test.lxl.log.err.ttt"
fi
A=`tail -n 100 $1 | grep "$T" | grep -iE 'emerg|aler'|egrep -v "$Test"|wc -l`

if [ $A -gt $2 ];then
	E=`tail -n 100 $1 | grep "$T" | grep -iE 'emerg|aler'|egrep -v "$Test"|head -1`
#	File=`tail -n 50000 $1 |grep "$T" | grep -iE 'emerg|aler'`
	echo "$E"
fi
