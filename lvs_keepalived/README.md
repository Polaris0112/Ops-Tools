## LVS+KEEPALIVED 部署工具+指南

### 使用介绍

-  `for_lvs_keepalived`：存放部署`lvs`的工具
  -  `lvs.sh`：部署`lvs`脚本（不分主从，主从配置由配置文件决定）
  -  `keepalived.conf.master`：主`lvs`的配置文件，根据文件内的指示进行修改，然后把文件名改成`keepalived.conf`放到`/etc/keepalived/`目录下，并重启`keepalived`服务
  -  `keepalived.conf.slave`：从`lvs`的配置文件，根据文件内的指示进行修改，然后把文件名改成`keepalived.conf`放到`/etc/keepalived/`目录下，并重启`keepalived`服务

-  `for_real_server`：后端服务器配置脚本
  -  `realservers.sh`：主要是修改网卡相关信息，使用的是DR模式

-  `lvs+keepalived.docx`：部署的说明文档







