#!/bin/bash
num=0
Test=`echo $2 | awk '{gsub(/\@/,"|");print}'`
TXT='repl|event_scheduler|system|user'
if [ -z "$Test" ];then
	Test="test.lxl.log.err.ttt"
fi
Time=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf -S /tmp/mysql.sock processlist | egrep -v "$TXT" | egrep -v "$Test" | awk '{print $12}' | grep -o '[0-9]\+' | sort -rn | xargs echo`
for i in $Time
do
	if [ $i -gt $1 ];then
		
		let "num+=1"
		
	fi
done
echo $num
