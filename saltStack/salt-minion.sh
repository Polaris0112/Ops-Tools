#!/bin/bash
# run as root

if [ ! -z $1 ];then
    master=$1
    host_id=$(hostname)
else
    echo "Lack of master ip."
    exit 1
fi  

yum install -y epel-release
yum install -y salt salt-minion

egrep -v '^#|^$' /etc/salt/minion
sed -i "s/#master: salt/master: $master/g" /etc/salt/minion                                              
sed -i "s/#id:/id: $host_id/g" /etc/salt/minion

if [ $release_version -eq 6 ];then
    service salt-minion start
    chkconfig salt-minion on
else
    systemctl start salt-minion.service
    systemctl enable salt-minion.service
fi


