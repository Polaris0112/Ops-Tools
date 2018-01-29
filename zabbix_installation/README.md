## Zabbix 服务端、客户端一键安装脚本

### 使用介绍

- `zabbix_server.sh`：`Zabbix`服务端一键安装脚本，适用于CentOS6.x/CentOS7.x，运行之前需要修改第6-7行，填入`dbpasswd`代表数据库root的密码，`zbpasswd`代表`zabbix`使用的数据库密码。然后运行`sh zabbix_server.sh`，安装完相关依赖之后会出现一个交互，判断是否安装新的`MySQL(Percona)`数据库，`Y`的话就会先卸载原有的mysql数据库（如果之前有的话），然后进行安装`Percona`，如果选择`N`则跳过这个过程，直接进入安装`php5.6`。等待一段时间后，安装完成，登录`http://ip/zabbix`就可以进入网页安装界面，按照指定步骤操作即可。

- `zabbix_agent.sh`：运行之前需要确认`master ip`，然后执行`sh zabbix_agent.sh  [master ip]`，采用的是`yum`的安装方式，所以配置文件路径均在`/etc/zabbix`目录下。






