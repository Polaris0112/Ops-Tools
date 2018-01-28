## SaltStack 一键安装工具

### 使用介绍

此工具是一键安装批量部署工具SaltStack服务端、客户端。

-  `salt-master.sh`：安装SaltStack服务端脚本，需要输入一个参数指定`master ip`，如`sh salt-master.sh  192.168.0.2`。

-  `salt-minion.sh`：安装SaltStack客户端脚本，同安装服务端脚本一样，需要指定`master ip`，如`sh salt-minion.sh  192.168.0.2`。


### SaltStack部分使用指南

1.在所有客户端执行测试命令：

```shell
salt "*" test.ping
```

2.在所有minion(客户端)上执行'uptime'命令：

```shell
salt '*' cmd.run 'uptime'
```

3.拷贝文件到所有客户端的tmp目录下面：

```shell
salt-cp '*' install.log /tmp/install.log
```

4.saltstack的配置管理：
```shell
vim /etc/salt/master

file_roots:
  base:
    - /srv/salt/


mkdir /srv/salt 
cd /srv/salt 
vim apache.sls #安装apache并启动

apache-install:
  pkg.installed:
    - names:
      - httpd
      - httpd-devel

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True



salt '*' state.sls apache #执行状态管理脚本
```

5.编辑salt的入口文件：

PS: top-file文件要放在base环境下。 

```shell
vim top.sls

base:
  'SH_T_ansiblecli_02.gigold-idc.com':
    - apache
  'SH_T_ansiblecli_03.gigold-idc.com':
    - apache


salt '*' state.highstate #通过入口文件执行安装apache的脚本 
salt '*' state.highstate test=True #生产环境上面命令很危险，要先测试下
```

#### SaltStack-数据系统Grains

1.查看客户机的所有grains信息：

```shell
salt 'SH_T_test_03.gigold-idc.com' grains.items
```

2.查看客户机的IP地址：

```shell
salt 'SH_T_test_03.gigold-idc.com' grains.get ip_interfaces:eth0
```

3.通过grains判断在哪些客户端上执行'W'命令：

```shell
salt -G 'os:Centos' cmd.run 'w'
```

4.客户端自定义grains并通过top筛选:

```shell
vim /etc/salt/grains #在客户端定义，写完要重启minion

roles:
  - webserver
  - memcache

/etc/init.d/salt-minion restart 
vim top.sls #服务端

base:
  'roles:webserver':     #匹配roles变量为webserver的主机
    - match: grain      #要定义通过grain方法获取参数
    - apache

salt '*' state.highstate #通过top筛选匹配的grain
```

5.通过master刷新minion的grains参数：

```shell
salt '*' saltutil.sync_grains
```

6.通过Python脚本自定义获取grains参数：

```python
vim /srv/salt/_grains/my_grains.py #文件创建在master服务器上

#!/usr/bin/env python
#-*- coding: utf-8 -*-

def my_grains():
    #初始化一个grains字典
    grains = {}
    grains['iaas'] = 'openstack'
    grains['edu'] = 'wmjedu'
    return grains

salt '*' saltutil.sync_grains #编辑完后要记得推送到minion上
```

7. Grains的优先级：

从高到低：系统自带--grains文件---minion配置文件--master自定义的

#### SaltStack-数据系统Pillar

定义： Pillar是动态的，给特定的minion指定特定的数据 ，只有指定的minion可以看到（所有相对安全，可以用来设置密码）。

1.在服务端创建Pillar的base环境：

```shell
vim /etc/salt/master

pillar_roots:
  base:
    - /srv/pillar


mkdir -p /srv/pillar 
/etc/init.d/salt-master restart
```

2.自己创建pillar：

```shell
vim /srv/pillar/apache.sls

my-pillar:
  {%if grains['os'] == 'CentOS'%}
  apache: httpd
  {% elif grains['os'] == 'Debian' %}
  apache: apache2
  {% endif %}


vim /srv/pillar/top.sls

#配置在哪台主机上面使用pillar
base:
  'SH_T_ansiblecli_02.gigold-idc.com':
    - apache

salt '*' saltutil.refresh_pillar #配置完成后要记得刷新pillar 
salt '*' pillar.items #查看配置的pillar
```

3.刷新pillar：

```shell
salt '*' saltutil.refresh_pillar
```

4.通过pillar来筛选哪些minion执行操作：

```shell
salt -I "apache:httpd" cmd.run 'w'
```

5.grains和pillar的区别：

![](https://github.com/Polaris0112/Ops-Tools/blob/master/saltStack/grains_and_pillars.png)

#### SaltStack-远程执行-进阶

1.多种判断需要执行Minion的方法：

```shell
salt -L 'SH_T_test_03, SH_T_ansiblecli_02' cmd.run 'w' #通过列表
salt -S '172.16.1.213' test.ping      #通过ip判断
salt -S '172.16.1.0/24' test.ping     #通过网段判断
vim /etc/salt/master      #配置nodegroups来分组
nodegroups:
  web: 'L@SH_T_test_03.gigold-idc.com,SH_T_ansiblecli_02.gigold-idc.com'
salt -N web test.ping      #通过-N来指定
```

2.将执行返回值写入到数据库中：

执行数据库脚本：

```shell
CREATE DATABASE  `salt`
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

USE `salt`;

--
-- Table structure for table `jids`
--

DROP TABLE IF EXISTS `jids`;
CREATE TABLE `jids` (
  `jid` varchar(255) NOT NULL,
  `load` mediumtext NOT NULL,
  UNIQUE KEY `jid` (`jid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE INDEX jid ON jids(jid) USING BTREE;

--
-- Table structure for table `salt_returns`
--

DROP TABLE IF EXISTS `salt_returns`;
CREATE TABLE `salt_returns` (
  `fun` varchar(50) NOT NULL,
  `jid` varchar(255) NOT NULL,
  `return` mediumtext NOT NULL,
  `id` varchar(255) NOT NULL,
  `success` varchar(10) NOT NULL,
  `full_ret` mediumtext NOT NULL,
  `alter_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  KEY `jid` (`jid`),
  KEY `fun` (`fun`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `salt_events`
--

DROP TABLE IF EXISTS `salt_events`;
CREATE TABLE `salt_events` (
`id` BIGINT NOT NULL AUTO_INCREMENT,
`tag` varchar(255) NOT NULL,
`data` mediumtext NOT NULL,
`alter_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`master_id` varchar(255) NOT NULL,
PRIMARY KEY (`id`),
KEY `tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

vim /etc/salt/master

#文件底部添加
master_job_cache: mysql
mysql.host: '172.16.1.214'
mysql.user: 'root'
mysql.pass: 'Root123'
mysql.db: 'salt'
mysql.port: 3306

/etc/init.d/salt-master restart 
salt '*' cmd.run 'free -m' #执行完成后可以在数据库里面查看
```

#### SaltStack-配置管理

1.”top.sls”文件必须放在base环境下。

```shell
file_roots:
  base:
    - /srv/salt/base
  test:
    - /srv/salt/test
  prod:
    - /srv/salt/prod
```

2.拷贝文件到Minion上：

```shell
vim dns.sls

/etc/resolv.conf:
  file.managed:
    - source: salt://files/resolv.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      DNS_SERVER: 223.6.6.6

salt '*' state.sls dns #直接执行 
```

下面用top来执行 

```shell
vim top.sls

base:
  '*':
    - dns

salt '*' state.highstate #使用高级状态执行
```

3.状态间的依赖关系：

1.我依赖谁：只要依赖的状态为正常，我就执行。

```shell
- require:
  - pkg: lamp-pkg          (状态模块：状态名)
  - file: apache-config
```

2.我被谁依赖：(一般用不到)

```shell
- require_in:    (写在被依赖方)
  - service: mysql-service
```

3.我监控谁：监控某个状态，只有发生变化我才执行，

```shell
- watch:
```

4.我被谁监控：(一般用不到)

```shell
- watch_in:
```

5.我引用谁：

```shell
include:
```

3.jinja模板的使用方法：

1.模板里面赋值： 

```shell
    - template: jinja
    - defaults:
      PORT: 8080
{{ PORT }}
```

2.使用grains参数获取本地IP： {{ grains['fqdn_ip4'][0] }}
3.使用salt远程执行模块获取网卡MAC: {{ salt['network.hw_addr']('eth0') }}
4.使用pillar参数： {{ pillar['apache'] }}

```shell
vim env_init.sls

include:
  - init.dns
  - init.history
  - init.sysctl
```

4.以测试模式执行：

```shell
salt '*' state.highstate test=True
```

5.安装haproxy案例

```shell
include:
  - pkp.pkg-init

haproxy-install:
  file.managed:
    - name: /usr/local/src/haproxy-1.6.11.tar.gz
    - source: salt://haproxy/files/haproxy-1.6.11.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar zxf haproxy-1.6.11.tar.gz && cd haproxy-1.6.11 && make TARGET=linux26 PREFIX=/usr/local/haproxy && make install PREFIX=/usr/local/haproxy
    - unless: test -d /usr/local/haproxy    #后面条件为“假”时执行
    - require:                   #下面两个条件要执行成功才能执行
      - pkg: pkg-init            #代表pkg-init里面的Pkg
      - file: haproxy-install

haproxy-init:
  file.managed:
    - name: /etc/init.d/haproxy
    - source: salt://haproxy/files/haproxy.init
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: haproxy-install
  cmd.run:
    - name: chkconfig --add haproxy
    - unless: chkconfig --list | grep haproxy
    - require:
      - file: haproxy-init

net.ipv4.ip_nonlocal_bind:
  sysctl.present:
    - value: 1

haproxy-config-dir:
  file.directory:
    - name: /etc/haproxy
    - user: root
    - group: root
    - mode: 755
```

