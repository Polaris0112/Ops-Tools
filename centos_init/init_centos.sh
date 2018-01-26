#!/bin/bash

release_version=$(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/')

#修改yum仓库
yum install -y wget curl
yum earse -y epel-release remi-release
rm -f /etc/yum.repos.d/*
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum install -y epel-release 
yum install -y ntpd ntpdate



#同步时间
if [ $release_version -eq 6 ];then
    service ntpd start
    chkconfig ntpd on
else
    systemctl start ntpd
    systemctl enable ntpd
fi
hwclock --systohc

#关闭SSH域名解析
sed -i 's%#UseDNS yes%UseDNS no%' /etc/ssh/sshd_config
sed -i 's%GSSAPIAuthentication yes%GSSAPIAuthentication no%' /etc/ssh/sshd_config
if [ $release_version -eq 6 ];then
    service sshd restart
else
    systemctl restart sshd
fi

#安装Python2.7
mkdir -p /root/python
cd /root/python
wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz
xz -d Python-2.7.11.tar.xz
tar -xf Python-2.7.11.tar
cd Python-2.7.11
./configure
make
make install
mv /usr/bin/python  /usr/bin/python.bak
ln -sf /usr/local/bin/python2.7 /usr/bin/python
if [ $release_version -eq 6 ];then
    sed -i 's@#!/usr/bin/python$@#!/usr/bin/python2.7@g' /usr/bin/yum
    sed -i 's@#!/usr/bin/python$@#!/usr/bin/python2.7@g' /usr/libexec/urlgrabber-ext-down
else
    sed -i 's@#!/usr/bin/python$@#!/usr/bin/python2.7.5@g' /usr/bin/yum
fi

#安装必备软件
yum groupinstall -y Development tools
yum install -y libselinux-python rsync tree lrzsz net-tools bc iptraf iotop vim tmux sysstat gdb gcc gcc-c++ man xz

#安装nginx
yum install -y nginx


#安装数据库
#yum install -y mysql mysql-server mysql-devel
#yum install -y redis
#cat > /etc/yum.repos.d/mongodb-org-3.6.repo <<EOF
#[mongodb-org-3.6]
#name=MongoDB Repository
#baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.6/x86_64/
#gpgcheck=1
#enabled=1
#gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
#EOF
#yum install -y mongodb-org
#chkconfig mongod off




