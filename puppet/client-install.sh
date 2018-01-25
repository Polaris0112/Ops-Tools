#!/bin/bash

if [ ! -z $1 ];then
    master=$1
else
    echo "Lack of master."
    exit 1
fi


release_version=$(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/')

if [ $release_version -eq 6 ];then
    wget  http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
    yum install -y puppetlabs-release-6-7.noarch.rpm
else
    wget http://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-12.noarch.rpm
    yum install -y puppetlabs-release-7-12.noarch.rpm
fi

yum install -y ruby facter puppet

 

#启动

service puppet start

 

#设置开机自启动

chkconfig  puppet on

 

#配置

#添加下面一行

if [ $(grep "server=" /etc/puppet/puppet.conf |wc -l) -eq 0 ];then
    echo "server=$master" >> /etc/puppet/puppet.conf
else
    sed -i 's/^server=.*$/server='$master'/g' /etc/puppet/puppet.conf
fi

#重启puppet

service puppet restart
