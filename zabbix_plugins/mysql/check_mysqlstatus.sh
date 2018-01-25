#!/bin/bash
MYSQL_SOCK=$2
result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "$1"|cut -d"|" -f3`
echo  $result
