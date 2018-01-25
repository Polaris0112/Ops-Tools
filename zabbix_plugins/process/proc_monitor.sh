#!/bin/bash
process=$1
name=$2

function mem
{
    #memory=$(top -b -n 1|grep -we "$process"|sort |head -1|awk '{if (match($6,/[0-9]+m/)) print $6*1024;else if (match($6,/[0-9]+g/)) print $6*1024*1024; else print $6}')
    memory=$(top -b -n 1|grep -we "$process"|awk '{if (match($6,/[0-9]+m/)) sum=$6*1024;else if (match($6,/[0-9]+g/)) sum=$6*1024*1024; else sum=$6;all_mem+=sum}END{printf "%.f",all_mem}')
    echo "$memory"
}

function cpu
{
    cpustat=$(top -b -n 1|grep -we "$process"|awk '{sum+=$9}END{if (sum>0) print sum;else print "0.0"}')
    echo "$cpustat"
}

function getport
{
    get_process_pid=$(top -b -n 1|grep -we "$process"|grep -v grep|sort |head -1|awk '{print $1}')
    if [[ $get_process_pid ]];then
        get_father_pid=$(ps -ef|grep -w $get_process_pid|grep -v grep|sort|head -1|awk '{if ($3 == 1) print $2; else print $3}')
    else
        get_father_pid=""
    fi
   
    get_father_pid=$(pgrep -o $process)

    if [ $get_father_pid ];then
        gp=$(sudo netstat -tunlp|grep -w $get_father_pid|head -1|awk '{print $4}'|awk -F ":" '{print $NF}')
    else
        gp=""
    fi
}

function flowin
{
    getport
    if [ $gp ];then
        in_data=$(sudo iptables -nvx -L|grep -w "dpt:$gp"|awk '{sum+=$2}END{print sum}')
    else
        in_data=0
    fi
    if [ ! $in_data ];then
        in_data=0
    fi

    echo $in_data
}

function flowout
{
    getport
    if [ $gp ];then
        out_data=$(sudo iptables -nvx -L|grep -w "spt:$gp"|awk '{sum+=$2}END{print sum}')
    else
        out_data=0
    fi
    if [ ! $out_data ];then
        out_data=0
    fi

    echo $out_data

}

function discovery
{
    #process_list=$(top -b -n 1|sed -n '8,$'p|grep -Ev 'top|grep'|grep -e "$process"|awk '{if ($6 != 0) print $0}'|sort -rn -k9|awk '{print $12}'|uniq)
    process_list=$(top -b -n 1|sed -n '8,$p'|grep -Ev 'top|grep'|awk '{if ($6 != 0) print $0}'|sort -rn -k9|awk '{print $12}'|uniq |head -10)
    COUNT=$(echo "$process_list" |wc -l)
    echo '{"data":['
    echo "$process_list" | while read -r LINE; do
        echo -n '{"{#TABLENAME}":"'"$LINE"'"}'
        INDEX=$[ $INDEX + 1]
        if [[ "$INDEX" -lt "$COUNT" ]]; then
            echo ','
        fi
    done
    echo ']}'
}




case $name in
mem)
    mem
;;
cpu)
    cpu
;;
flowin)
    flowin
;;
flowout)
    flowout
;;
*)
    discovery
;;
esac
exit 0

