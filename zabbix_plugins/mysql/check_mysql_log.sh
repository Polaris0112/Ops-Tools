#!/bin/bash
export LANG="en_US.UTF-8"
T=`date -d '1 minutes ago' +'%y%m%d  %k'`
#T='02/Apr/2015:14:10:03'
#T="2015-05-02 14:11:55"
#T="150624  9:59"
Test=`echo $3 | awk '{gsub(/\@/,"|");print}'`

if [ -z "$Test" ];then
	Test="test.lxl.log.err.ttt"
fi
for file in $(sudo find $1 -name '*.err' -mmin -30 | grep err$ |egrep -v "$Test")
do
if test -f $file;then
	A=`sudo tail -n 5000 $file | grep "$T" |grep -iE '\[ERROR\]|Deadlock' | wc -l`
	if [ $A -gt $2 ];then
		File=`sudo tail -n 5000 $file | grep "$T" | grep -iE '\[ERROR\]|Deadlock' | head -1`
		ABC+="$file,$File,is unnormal "
	fi
fi
done
printf "$ABC"
