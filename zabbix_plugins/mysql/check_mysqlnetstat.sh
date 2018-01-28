#!/bin/bash
mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf -P$1 -S $2 status | awk {'print $4'}
