#!/bin/bash
B=`grep maxmemory /etc/redis/redis.conf | grep -v '^#' | grep -o '[0-9]\{1,9\}'`
awk -vnumb=$B 'BEGIN {print numb*1024*1024*1024}'
