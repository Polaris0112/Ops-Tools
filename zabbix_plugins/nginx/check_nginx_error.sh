#!/bin/bash
D=$((date "+%d/%b/%Y:%H")|cut -c1-16)
#D='02/Apr/2015:14:10:03'
#echo $D
Test=`echo $3 | awk '{gsub(/\@/,"|");print}'`

if [ -z "$Test" ];then
	Test="test.lxl.log.err.ttt"
fi
cd $1
for F in $(find $1 -name '*.log' -mmin -30 | grep log$)
do
if test -f $F;then
	N=$(tail -n 1000 $F|grep $D| egrep -v "$Test"|awk '{print $9}' |grep -iE '404|^5'|wc -l)
	if [ "$N" != "" ];then
	if [ $N -gt $2 ];then
		LOG+="$F:nginx aceece is unormal "
	fi
	fi
fi
done
printf "$LOG"
