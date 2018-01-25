#!/bin/bash
A=`$(PATH=/usr/local/bin:/usr/local/redis/bin:$PATH;/usr/bin/which redis-cli) -h 127.0.0.1 -p 6379 info | grep "keyspace_hits" | cut -d : -f2`
B=`$(PATH=/usr/local/bin:/usr/local/redis/bin:$PATH;/usr/bin/which redis-cli) -h 127.0.0.1 -p 6379 info | grep "keyspace_misses" | cut -d : -f2`
C=`awk -vnamea=$A -vnameb=$B 'BEGIN { print namea+nameb}'`
if [ $C -eq 0 ];then
	echo -1
else
	awk -vnamec=$C -vnamea=$A 'BEGIN { print namea/namec*100}'
fi
