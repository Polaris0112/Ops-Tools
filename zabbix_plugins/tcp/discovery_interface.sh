#!/bin/sh
Interface=`snmpwalk -v 2c -c efun 127.0.0.1 .1.3.6.1.2.1.31.1.1.1.1 | grep -vE "lo|lo0|plip0|ipfw0|usbus" | awk -F ":" '{print $NF}' | tr -d '"'`
Outside=`echo $Interface | awk '{print $1}'`
Inside=`echo $Interface | awk '{print $2" "$3" "$4}'`
NUM=`echo $Inside | wc -w`
i=1
printf '{\n'
printf '\t"request":"sender data",\n'
printf '\t"data":[\n'
if [ $NUM -ne 0 ] ; then
	for A in $Inside
	do
		if [ $i -lt $NUM ] ; then
		printf "\t\t{ \n"
		printf "\t\t\t\"{#IFNAME_IN}\":\"$A\",\t\"{#IFNAME_OUT}\":\"$Outside\"},\n"
		else
		printf "\t\t{ \n"
		printf "\t\t\t\"{#IFNAME_IN}\":\"$A\",\t\"{#IFNAME_OUT}\":\"$Outside\"}]}\n"
		fi
		i=$(($i+1))
	done
else
       printf "\t\t{ \n"
       printf "\t\t\t\"{#IFNAME_OUT}\":\"$Outside\"}]}\n"
fi
