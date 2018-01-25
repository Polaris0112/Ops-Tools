#!/bin/bash
#passwd = 密码
mysql --defaults-file=/usr/local/zabbix/scripts/.my.cnf -P$1 -S $2 -e 'show slave status\G' |grep -E "Slave_IO_Running|Slave_SQL_Running"|awk '{print $2}'|grep -c Yes
