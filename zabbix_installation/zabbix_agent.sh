#!/bin/bash

if [ ! -z $1 ];then
    master=$1
else
    echo "Lack of master ip."
    exit 1
fi

rpm -e zabbix-agent >/dev/null 2 &>1
rpm -e zabbix-release >/dev/null 2 &>1
rpm -e zabbix >/dev/null 2 &>1

release_version=$(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/')
if [ $release_version -eq 6 ];then
    rpm -ivh http://repo.zabbix.com/zabbix/3.5/rhel/6/x86_64/zabbix-release-3.5-1.el6.noarch.rpm
else
    rpm -ivh http://repo.zabbix.com/zabbix/3.5/rhel/7/x86_64/zabbix-release-3.5-1.el7.noarch.rpm
fi

yum install -y zabbix-agent

IP=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`


sed -i 's/^.*EnableRemoteCommands=1/EnableRemoteCommands=0/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^.*Server=127.0.0.1/Server='$master'/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^.*StartAgents=.*$/StartAgents=1/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^ServerActive=.*$/ServerActive='$master'/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^.*RefreshActiveChecks=.*$/RefreshActiveChecks=120/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^.*BufferSize=.*$/BufferSize=200/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^.*Timeout=.*$/Timeout=10/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^Hostname=.*$/Hostname='${IP}'/g' /etc/zabbix/zabbix_agentd.conf

if [ $release_version -eq 6 ];then
    sed -i 's/^.*SELINUX=.*$/SELINUX=disabled/g' /etc/sysconfig/selinux
else
    sed -i 's/^.*SELINUX=.*$/SELINUX=disabled/g' /etc/selinux/config
fi

setenforce 0
service zabbix-agent restart
chkconfig zabbix-agent on

