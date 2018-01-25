#!/bin/bash
MYSQL_SOCK=$2
#MYSQL_PWD="123nagios"
#ARGS=2
#if [ $# -ne "$ARGS" ];then
#    echo  "Please input one arguement:"
#fi
case $1 in
    Uptime)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK status|cut -f2 -d":"|cut -f1 -d"T"`
            echo  $result
            ;;
        Com_update)
            result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_update"|cut -d"|" -f3`
            echo  $result
            ;;
        Slow_queries)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK status |cut -f5 -d":"|cut -f1 -d"O"`
                echo  $result
                ;;
    Com_select)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_select"|cut -d"|" -f3`
                echo  $result
                ;;
    Com_rollback)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_rollback"|cut -d"|" -f3`
                echo  $result
                ;;
    Questions)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK status|cut -f4 -d":"|cut -f1 -d"S"`
                echo  $result
                ;;
    Com_insert)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_insert"|cut -d"|" -f3`
                echo  $result
                ;;
    Com_delete)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_delete"|cut -d"|" -f3`
                echo  $result
                ;;
    Com_commit)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_commit"|cut -d"|" -f3`
                echo  $result
                ;;
    Bytes_sent)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Bytes_sent" |cut -d"|" -f3`
                echo  $result
                ;;
    Bytes_received)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Bytes_received" |cut -d"|" -f3`
                echo  $result
                ;;
    Com_begin)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Com_begin"|cut -d"|" -f3`
                echo  $result
                ;;
    Innodb_data_written)
        result=`mysqladmin --defaults-file=/usr/local/zabbix/scripts/.my.cnf  -P$3 -S $MYSQL_SOCK extended-status |grep -w "Innodb_data_written"|cut -d"|" -f3`
                echo  $result
                ;;
        *)
    echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Innodb_data_written)"
        ;;
esac
