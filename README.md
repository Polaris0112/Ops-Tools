# Ops-Tools

Repository for tools

此仓库保存的都是工作以来大部分（有些不方便公开）的应用在生产环境上的运维工具，有部署脚本，有命令、工具使用方法记录，仅供查找学习使用，脚本如有问题可以提issue一起探讨。


## 目录介绍

-  [ali](https://github.com/Polaris0112/Ops-Tools/tree/master/ali)：文件夹内的两个脚本都是对阿里云服务器使用的，主要是磁盘扩容和挂在数据盘脚本

-  [ansible](https://github.com/Polaris0112/Ops-Tools/tree/master/ansible)：批量处理工具，使用`ansible`的时候使用对应配置文件的方法，包括主机配置、命令操作方法等格式

-  [lvs_keepalived](https://github.com/Polaris0112/Ops-Tools/tree/master/lvs_keepalived)：记录了负载均衡+高可用配置方案文档，还有对应配置的自动化脚本，普通配置是1vip+2lvs+2real sever

-  [openstack_installation](https://github.com/Polaris0112/Ops-Tools/tree/master/openstack_installation)：虚拟化，使用devstack部署openstack的脚本以及安装部署踩过的坑

-  [puppet](https://github.com/Polaris0112/Ops-Tools/tree/master/puppet)：批量处理工具，部署`puppet`的自动化脚本，以及puppet常用的命令和文件控制批量化部署

-  [qyweixin](https://github.com/Polaris0112/Ops-Tools/tree/master/qyweixin)：这是调用企业微信api来发送信息的接口

-  [send_mail](https://github.com/Polaris0112/Ops-Tools/tree/master/send_email)：发送邮件的接口

-  [ssh](https://github.com/Polaris0112/Ops-Tools/tree/master/ssh)：把~/.ssh/config文件中的服务器信息生成xshell、securecrt对应的会话文件并打包传出

-  [zabbix_installation](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_installation)：监控工具，zabbix-server、zabbix-agent一键部署脚本，适用于CentOS6或者CentOS7，Apache+Percona+Zabbix

-  [zabbix_plugins](https://github.com/Polaris0112/Ops-Tools/tree/master/zabbix_plugins)：这里包含了工作以来使用过的zabbix插件，部分复杂的配上了对应的conf和template xml

-  [saltStack](https://github.com/Polaris0112/Ops-Tools/tree/master/saltStack)：批量处理工具，saltStack服务端、客户端自动化部署脚本和一些命令的基本使用

-  [centos_init](https://github.com/Polaris0112/Ops-Tools/tree/master/centos_init)：操作系统，从最小安装的centos6/7，初始化安装各类适合开发环境的软件包

-  [mongodb](https://github.com/Polaris0112/Ops-Tools/tree/master/mongodb)：MongoDB数据库，各种模式的配置文件模板，配置教程和备份回档工具





