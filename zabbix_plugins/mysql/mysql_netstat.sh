#!/bin/bash 
PID=`ps aux | awk '/socketwait/{print $(NF-1),$2}' | sed "s/[0-9] / /g" | awk ' {a[$1]=a[$1] "|"$2}END{for(i in a)print sum[i] i a[i]}'| awk -F'0[|]' '{print $1,$2}' | grep $1 | awk '{print $2}'`
sudo netstat -tnp|awk '$5~/:3306/' |egrep "$PID"|wc -l
