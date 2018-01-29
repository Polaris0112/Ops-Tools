#!/bin/bash
# backup mongo databases crontabily
time=$(date +%Y_%m_%d_%H_%M)


db_host=""
username=""
password=""
databases=""
output_location="{{ path to output}}/${time}"

if [ -z $databases];then
    databases=".*"
fi

if [[ ! -z $username && -z $password ]];then
    echo "lack of password"
    exit 1
fi


if [ -z $username ];then
    for db_name in $(echo "show dbs;"|mongo ${db_host} --shell|grep -E $databases|awk '{print $1}')
    do
        CMD="mongodump --host ${db_host} -d ${db_name} -o ${output_location}"
        #echo "$CMD"
        $CMD
    done
else
    for db_name in $(echo "show dbs;"|mongo ${db_host} -u $username -p$password --authenticationDatabase admin --shell|grep -E $databases|awk '{print $1}')
    do
        CMD="mongodump --host ${db_host} -d ${db_name} -o ${output_location}"
        #echo "$CMD"
        $CMD
    done
fi

