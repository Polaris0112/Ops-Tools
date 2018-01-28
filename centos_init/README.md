## CentOS系统初始化工具

### 使用介绍

由于工作环境主要使用的服务器都是基于CentOS系统，所以平时日常接触的都是CentOS比较多，对于CentOS6/CentOS7的初始化也是做成了一个工具。

- `init_centos.sh`：无需修改任何配置参数，运行`sh init_centos.sh`即可，初始化内容为：
  - 更换yum源为阿里云源
  - 安装epel源和ntp同步时间
  - 关闭ssh的域名解析功能（可选，如果需要用域名登陆服务器请注释30-36行）
  - 安装python2.7.11
  - 安装开发环境Development tools，和一些运维相关的工具
  - 安装nginx
  - 安装数据库[mysql、redis、mongodb]（目前是注释的，需要的话可以取消注释）


