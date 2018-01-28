## Zabbix 插件

### 使用介绍

该处是放置工作以来使用Zabbix用到的自定义插件，用于监控指定的进程、数据库等数据信息。

-  [disk_io](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/disk_io)：关于硬盘io的监控插件
 - `disk_discovery.conf`：zabbix插件的配置文件，放到根据`agent`设置的`include`参数的路径中
 - `disk_discovery.sh`：自动发现的脚本，请配合上述`conf`的路径进行配置（可以自定义路径）
 - `disk_io_monitor_templates.xml`：适配于zabbix3的模板xml，直接导入这个xml相当于添加模板

-  [lvs](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/lvs)：关于lvs监控插件
  - `lvs.conf`：对应`lvs`插件配置文件（脚本路径可能需要修改）
  - `lvs_active.sh`：检测`lvs`是否激活
  - `lvs_conn.sh`：检测`lvs`连通的个数
  - `lvs_status.sh`：检测`lvs`状态（80|443）

-  [mysql](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/mysql)：关于mysql数据库监控插件
  -  `check_mysql_log.sh`：监控mysql的错误日志情况
  -  `check_mysqlperformance.sh`：需要修改参数`MYSQL_SOCK`和`MYSQL_PWD`，监控com_insert、com_update等参数方便得出mysql当前性能状态
  -  `check_mysqlnetstat.sh`：检查mysql端口、sock状态
  -  `check_mysql_showTime.sh`：监控`processlist`中包含`repl|event_scheduler|system|user`的数量
  -  `mysqlsalve.sh`：监控mysql从的状态

-  [nginx](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/nginx)：关于nginx监控插件
  -  `check_nginx_status.sh`：需要配置指定的ip和端口
  -  `nginx.conf`：zabbix监控nginx插件配置

-  [process](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/process)：监控指定进程的CPU、内存、网络IO
  -  `process.py`：监控进程的py脚本，`python  process.py json`命令可以列出消耗内存最多的十个进程（如果想监控指定的进程，请在`def getdata()`这个函数里面添加正则筛选即可）
  -  `proc_monitor.sh`：监控进程的shell脚本，同样地，如果需要监控指定进程，修改`discovery`函数，在`process_list`加多一个`grep`管道就可以
  -  `process_monitor.conf`：是zabbix agent对应的插件配置文件
  -  `process_monitor.xml`：对应zabbix3网页模板xml

-  [redis](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/redis)：关于redis监控插件
  -  `redis_keyspace_hits.sh`：监控`redis`的`keyspace`状态
  -  `redis_maxmemory.sh`：监控`redis`的最大内存
  -  `redis.conf`：对应zabbix的插件配置文件

-  [tcp](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/tcp)：基于`netstat`命令进行监控tcp连接
  -  `check_tcp_estab.sh`：检查当前已建立的tcp连接
  -  `check_tcp_listen.sh`：检查当前正在监听的tcp连接

-  [firewall](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/firewall)：监控防火墙状态
  -  `check_firewall.sh`：CentOS6的会调用`iptables`命令，CentOS7会调用`firewall-cmd`命令
  -  `iptables.conf`：对应zabbix插件配置文件

-  [cpu](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins/cpu)：自动发现每个CPU数量
  -  `cpu_num_discovery.py`：监控cpu脚本
  -  `cpus.conf`：对应zabbix插件配置文件




