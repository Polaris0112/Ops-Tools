#!/bin/bash
NULL=
TEMP="127.0.0.1|::1:"
IP=`/usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k agent.hostname | awk '{print $1}'`
if [ "$1" == "$NULL" ] ; then
	PORT=`netstat -an | grep  ESTABLISHED | awk '{print $4}' | egrep -vE "$TEMP" | awk -F ":" '{print $NF}' | sort | uniq`
elif [ "$1" == "all" ] ; then
	PORT=`netstat -an | grep  ESTABLISHED | awk '{print $4}' | egrep -vE "$TEMP" | awk -F ":" '{print $NF}' | sort | uniq`
else
	AA=`echo $1 | tr "." "|"`
	PORT=`netstat -an | grep  ESTABLISHED | awk '{print $4}' | egrep -vE "$TEMP" | awk -F ":" '{print $NF}' | grep -Ev "$AA" | sort | uniq`
fi
NUM=`echo $PORT | wc -w`
i=1
printf '{\n'
printf '\t"request":"sender data",\n'
printf '\t"data":[\n'
	for A in $PORT
	do
		INIT_NAME=`cat /usr/local/zabbix/scripts/portList.txt | awk '{print $1" "$2}' | awk '$1=='$A'' | awk '{print $2}'`
		[ -z $INIT_NAME ]
		if [ $? -eq 0 ] ; then
			INIT_NAME={"$"$2_"$IP"_$i}
		fi
		if [ $i -lt $NUM ] ; then
		printf "\t\t{ \n"
		printf "\t\t\t\"{#PORT}\":\"$A\",\t\"{#NAME}\":\"$INIT_NAME\"},\n"
		else
		printf "\t\t{ \n"
		printf "\t\t\t\"{#PORT}\":\"$A\",\t\"{#NAME}\":\"$INIT_NAME\"}]}\n"
		fi
	i=$(($i+1))
	done
