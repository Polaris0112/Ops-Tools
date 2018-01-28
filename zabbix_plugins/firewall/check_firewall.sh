#!/bin/bash


version=`cat /etc/redhat-release | awk -F 'release' '{print $NF}' | awk -F '.' '{print $1}'`

if [ $version == 7 ];then
        sudo firewall-cmd --state > /dev/null 2>&1
        if [ $? -eq 0 ];then
                echo 1
        else
                echo 0
        fi
else
        firewall_num=`sudo iptables -nL | grep -Ev "Chain|destination|^$" | wc -l`
        echo $firewall_num
fi

