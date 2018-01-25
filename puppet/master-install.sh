#!/bin/bash

release_version=$(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/')

if [ $release_version -eq 6 ];then
    wget  http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
    yum install -y puppetlabs-release-6-7.noarch.rpm
else
    wget http://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-12.noarch.rpm
    yum install -y puppetlabs-release-7-12.noarch.rpm
fi

#yum update -y

yum install -y ruby facter puppet-server

# 启动

service puppet start

service puppetmaster start

 

# 设置开机自启动

chkconfig  puppet on

chkconfig  puppetmaster on
