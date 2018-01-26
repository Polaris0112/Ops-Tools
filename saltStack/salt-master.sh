#!/bin/bash
# run as root

if [ ! -z $1 ];then
    master=$1
    host_id=$(hostname)
else
    echo "Lack of master ip."
    exit 1
fi

release_version=$(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/')

yum install -y epel-release
yum install -y salt salt-master  salt-minion

egrep -v '^#|^$' /etc/salt/minion
sed -i "s/#master: salt/master: $master/g" /etc/salt/minion
sed -i "s/#id:/id: $host_id/g" /etc/salt/minion

if [ $release_version -eq 6 ];then
    service salt-master start
    service salt-minion start
    chkconfig salt-master on
    chkconfig salt-minion on
else
    systemctl start salt-master.service
    systemctl start salt-minion.service
    systemctl enable salt-master.service
    systemctl enable salt-minion.service
fi


## accept minion key
# salt-key -A        accept all keys
# salt-key -a [id]   accept selected key
# salt-key -L        list keys


## test minion
# salt '*' test.ping
# salt '*' test.versions_report

## run shell command
# salt '*' cmd.run 'uptime'

## transfer files
# salt-cp '*' install.log /tmp/install.log


## use file to control
# salt ‘*’ state.sls [filename] test=True 



