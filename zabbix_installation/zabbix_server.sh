#!/bin/bash
# run as root

#### Please First fill with mysql database root password and zabbix database password ####

dbpasswd=''
zbpasswd=''

##########################################################################################


yum install make gcc libcurl-devel net-snmp-devel httpd wget lrzsz telnet lsof libevent-devel pcre* -y

grep "^zabbix" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd zabbix
fi
grep "^zabbix" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd zabbix -g zabbix
fi

release_version=$(cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/')

## install mysql (Percona)
read -rp "Install a NEW Mysql(Percona) for zabbix[Y/N]" result
if [[ $result == "Y" ]] || [[ $result == "y" ]];
then
    for i in $(rpm -qa|grep -iE "mysql|percona")
    do
        #echo $i
        rpm --nodeps -e "${i}"
    done
    rm -rf /var/lib/mysql/*  > /dev/null 2>&1
    rm -f /etc/yum.repos.d/percona-release.repo > /dev/null 2>&1
    cat >>/etc/yum.repos.d/percona-release.repo<<EOF
########################################
# Percona releases and sources, stable #
########################################
[percona-release-\$basearch]
name = Percona-Release YUM repository - \$basearch
baseurl = http://repo.percona.com/release/\$releasever/RPMS/\$basearch
enabled = 1
gpgcheck = 1
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-percona

[percona-release-noarch]
name = Percona-Release YUM repository - noarch
baseurl = http://repo.percona.com/release/\$releasever/RPMS/noarch
enabled = 1
gpgcheck = 1
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-percona

[percona-release-source]
name = Percona-Release YUM repository - Source packages
baseurl = http://repo.percona.com/release/\$releasever/SRPMS
enabled = 0
gpgcheck = 1
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-percona
EOF
    wget http://www.percona.com/downloads/RPM-GPG-KEY-percona -O /etc/pki/rpm-gpg/RPM-GPG-KEY-percona
    yum install -y Percona-Server-devel-57 Percona-Server-shared-57 Percona-Server-client-57 Percona-Server-server-57 percona-zabbix-templates Percona-Server-shared
    # Initialize mysql server
    echo "Initialize mysql server..."
    rm -rf /var/lib/mysql/*
    service mysql start 
    sleep 2

    #modify mysql root password
    echo "Changing mysql server password..."
    
    if [ $release_version -eq 6 ];then
        service mysql stop 
        sleep 5
        mysqld_safe --skip-grant-tables &
        sleep 10
        mysql -e 'update mysql.user set authentication_string=password("'$dbpasswd'") where User="root" and Host="localhost"; flush privileges;' --connect-expired-password

        for i in $(pgrep -lo 'skip-grant-tables')
        do
             kill "${i}" > /dev/null 2>&1
             sleep 2
        done
    else
        mysql_root_tmp_password=$(cat /var/log/mysqld.log  | grep "A temporary password" | awk -F " " '{print$11}'|tail -1)
        mysql -u root -p"$mysql_root_tmp_password" -e 'SET PASSWORD = PASSWORD("'$dbpasswd'");ALTER USER "root"@localhost PASSWORD EXPIRE NEVER;flush privileges;' --connect-expired-password
    fi 
    rm -f /etc/my.cnf
    cat >>/etc/my.cnf <<EOF
# *** default location during install, and will be replaced if you
# *** upgrade to a newer version of MySQL.

[mysqld]

# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M

# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin

# These are commonly set, remove the # and set as required.
# basedir = .....
# datadir = .....
# port = .....
# server_id = .....
# socket = .....

# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M 
sync_binlog=0
show_compatibility_56=ON
character-set-server = utf8
# network
connect_timeout = 60
wait_timeout = 2880
max_connections = 2048
max_allowed_packet = 32M
max_connect_errors = 1000
# limits
tmp_table_size = 512M
max_heap_table_size = 256M
# logs
log_error = /var/log/mysql/mysql-error.log
slow_query_log_file = /var/1og/mysql/mysql-slow.log
slow_query_log = 1
long_query_time = 20
log_error_verbosity=2
# innodb
#innodb_data_home_dir = /var/lib/mysql/data
innodb_file_per_table = 1
innodb_status_file = 1
innodb_buffer_pool_size = 2G
innodb_flush_method = O_DIRECT
innodb_io_capacity = 2000
innodb_flush_log_at_trx_commit = 2
innodb_support_xa = 0
innodb_log_file_size = 512M
# other stuff
event_scheduler = 1
query_cache_type = 0
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF
fi

#start mysqld service 
echo "Starting mysql server..."
sleep 2
service mysql start


#Install php for zabbix
echo "Installing php5.6 for zabbix..."
for i in $(rpm -qa|grep php)
do
    #echo $i
    rpm --nodeps -e "$i"
done
#pm -e webtatic-release
if [ $release_version -eq 6 ];then
    rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
else
    rpm -ivh http://mirror.webtatic.com/yum/el7/webtatic-release.rpm
fi 

yum install -y php56w-mcrypt php56w-mbstring php56w-common php56w-xmlrpc php56w-mysql php56w-pdo php56w-gd php56w-ldap php56w-xml php56w-cli php56w-bcmath php56w php56w-fpm
service php-fpm start
service httpd restart



#Get and install zabbix-3.4.6
echo "Installing Zabbix-3.4.6 server..."
wget -c https://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.6/zabbix-3.4.6.tar.gz
tar zxf zabbix-3.4.6.tar.gz
cd zabbix-3.4.6 
echo "Configuring zabbix-server... "
./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --with-net-snmp --with-libcurl >/dev/null 
make > /dev/null
make install >/dev/null

echo "Creating zabbix database..."
mysql -uroot -p"${dbpasswd}" -e 'SET PASSWORD = PASSWORD("'$dbpasswd'");' --connect-expired-password
mysql -uroot -p"${dbpasswd}" -e 'CREATE USER "Zabbix"@"localhost" IDENTIFIED BY "'$zbpasswd'";'
mysql -uroot -p"${dbpasswd}" -e 'grant all privileges on zabbix.* to Zabbix@localhost identified by "'$zbpasswd'";flush privileges;'
echo "Config zabbix db done..."


mysql -uroot -p"${dbpasswd}" -e 'drop database zabbix;'
mysql -uroot -p"${dbpasswd}" -e 'create database zabbix character set utf8;'
echo "Import schema.sql..."
mysql -uZabbix -p"${zbpasswd}" -e "use zabbix;source database/mysql/schema.sql;"
echo "Import images.sql..."
mysql -uZabbix -p"${zbpasswd}" -e "use zabbix;source database/mysql/images.sql;"
echo "Import data.sql..."
mysql -uZabbix -p"${zbpasswd}" -e "use zabbix;source database/mysql/data.sql;"



#DB:zabbix  DBPasswd:zabbix 
echo "Configing zabbix ..."
sed -i 's/^DBName=.*$/DBName=zabbix/g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i 's/^DBUser=.*$/DBUser=Zabbix/g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i 's/^DBPassword=.*$/DBPassword='$zbpasswd'/g' /usr/local/zabbix/etc/zabbix_server.conf
sed -i 's/^ServerActive=.*$/ServerActive=127.0.0.1/g' /usr/local/zabbix/etc/zabbix_agentd.conf
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /usr/local/zabbix/etc/zabbix_agentd.conf.d/
cp misc/init.d/fedora/core/zabbix_* /etc/init.d/
sed -i 's#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g' /etc/init.d/zabbix_server
sed -i 's#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g' /etc/init.d/zabbix_agentd

cat >>/etc/services <<EOF
zabbix-agent 10050/tcp Zabbix Agent
zabbix-agent 10050/udp Zabbix Agent
zabbix-trapper 10051/tcp Zabbix Trapper
zabbix-trapper 10051/udp Zabbix Trapper
EOF


#config php.ini
sed -i 's/^.*post_max_size.*$/post_max_size = 16M/g' /etc/php.ini
sed -i 's/^.*max_execution_time.*$/max_execution_time = 300/g' /etc/php.ini
sed -i 's/^.*max_input_time.*$/max_input_time = 300/g' /etc/php.ini
sed -i 's/^.*always_populate_raw_post_data.*$/always_populate_raw_post_data = -1/g' /etc/php.ini
sed -i 's/^.*date.timezone.*$/date.timezone = Asia\/Shanghai/g' /etc/php.ini
sed -i 's/mbstring.func_overload.*$/mbstring.func_overload = 2/g' /etc/php.ini


#config httpd.conf
cat >>/etc/httpd/conf/httpd.conf <<EOF
ServerName 127.0.0.1
<VirtualHost *:80>
DocumentRoot "/var/www/html"
ServerName zabbix_server 
</VirtualHost>
EOF

mkdir -p /var/www/html/zabbix
rm -rf /var/www/html/zabbix/*
cp -a frontends/php/* /var/www/html/zabbix/
cp /var/lib/zabbix/percona/templates/userparameter_percona_mysql.conf /usr/local/zabbix/etc/zabbix_agentd.conf.d/
chmod 777 -R  /var/lib/php/session/

service iptables stop
chkconfig --level 345 iptables off
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux 
echo "/etc/init.d/zabbix_server start" >> /etc/rc.local
echo "/etc/init.d/zabbix_agentd start" >> /etc/rc.local
chkconfig --level 345 mysql on
chkconfig --level 345 httpd on

/etc/init.d/zabbix_agentd restart
/etc/init.d/httpd restart
/etc/init.d/zabbix_server restart

echo "Install done.Please check with website http://ip/zabbix for the further setting."


