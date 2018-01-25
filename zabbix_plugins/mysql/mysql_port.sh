#!/bin/bash
pidfile=/tmp/pid.txt
ps aux | grep jdk|grep -v grep |awk '/socketwait/{print $(NF-1),$2}' |
  sed "s/[0-9] / /g" |
  awk ' {a[$1]=a[$1] "|"$2}END{for(i in a)print sum[i] i a[i]}'|
  awk -F'0[|]' '{print $1,$2}'|
  egrep -v '-' > $pidfile

while read line;do
    PROJ=$(echo $line | awk '{print $1}') 
	string+='{"{#PROJ}":"'$PROJ'"},'
done < $pidfile
rm -fr $pidfile
printf '{"data":['${string%\,*}']}'
