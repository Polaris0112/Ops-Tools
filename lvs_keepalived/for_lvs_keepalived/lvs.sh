#!/bin/bash

yum install popt-devel ipvsadm -y

cd /tmp
wget http://www.keepalived.org/software/keepalived-1.2.7.tar.gz
tar zxvf keepalived-1.2.7.tar.gz
cd keepalived-1.2.7
./configure
make && make install
cp /usr/local/etc/rc.d/init.d/keepalived /etc/rc.d/init.d/
cp /usr/local/etc/sysconfig/keepalived /etc/sysconfig/
mkdir -p /etc/keepalived
cp /usr/local/etc/keepalived/keepalived.conf /etc/keepalived/
ln -s /usr/local/sbin/keepalived /usr/sbin


