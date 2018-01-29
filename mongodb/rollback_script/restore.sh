#!/bin/bash

basepath=$(cd `dirname $0`; pwd)
backup_location=""
backup_uri=""
origin_uri=""


usage(){
    echo -e "Usage: $0 [OPTIONS]\n Exp: sh $0 --restore 2018_01_16_00_00_01 [dbname] [talbename] [restore_key] [restore_value] "

        echo -e " --list      list recently 10 backup name."
        echo -e " --list-all  list all backup name."
        echo -e " --restore   select backup name and uid to restore."
        echo -e " --help      display help info."
exit 1
}

listall(){
    count=1
    for bn in $(ls -t ${backup_location})
    do
        echo -e "${count}.\t${bn}"
        count=$((${count}+1))
    done
exit 0
}

list(){
    count=1
    for bn in $(ls -t ${backup_location}|head -10)
    do
        echo -e "${count}.\t${bn}"
        count=$((${count}+1))
    done
exit 0
}

restore(){
    if [ -d "$basepath/mongodb/bak/$1" ];then
        if [ -d "$basepath/mongodb/bak/$1/$2" ];then
            if [ $(echo "show dbs;"|mongo ${backup_uri} --shell|grep -E "$2_rollback_$1"|wc -l) -eq 0 ];then
                restore_CMD="mongorestore -h ${backup_uri} -d $2_rollback_$1 $basepath/mongodb/bak/$1/$2"
                $restore_CMD
            fi
            py_restore_cmd="python restore.py $2_rollback_$1 $2 $3 $4 $5"
            $py_restore_cmd
            echo "Restore done."
        else
            echo "Database Name Error."
            exit 1
        fi
    else
        echo "Backup dir name Error."
        exit 1
    fi
exit 0
}

while [ $# -gt 0 ]; do
    case $1 in

        --restore)
            if [ ! -z $2 ];then
                if [ ! -z $3 ];then
                    if [ ! -z $4 ];then
                        if [ ! -z $5 ];then
                            if [ ! -z $6 ];then
                                restore $2 $3 $4 $5 $6 
                            else
                                echo "Lack of resotre value."
                                exit 1
                            fi
                        else
                            echo "Lack of restore key."
                            exit 1
                        fi
                    else
                        echo "Lack of table name."
                        exit 1
                    fi
                else
                    echo "Lack of db name."
                    exit 1
                fi
            else
                echo "Lack of backup dir name."
                exit 1
            fi
            ;;

        --list)
            list
            ;;

        --list-all)
            listall
            ;;

        --help)
            usage
            ;;

        *)
            usage
            ;;

    esac
done
                               
