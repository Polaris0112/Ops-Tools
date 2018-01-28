## Openstack一键安装工具

### 使用介绍

此工具是方便研究OpenStack时部署环境所用。

- `devstack-install.sh`：运行`sh devstack-install.sh`即可

运行后会有一个`stack`用户，目前我试过安装的时候，`stack`的家目录会在`/opt/stack`，然后`git clone devstack`项目的时候是在`/home/devstack`的。

目前遇到的坑有：

- 在运行`bash /home/devstack/stack.sh`这一步的时候，会刷一堆日志，会安装环境所需依赖，有时候在`pip`下载一些模块的时候会遇到连接`pypi.python.org timeout`这种情况。
  - 我的处理：`kil -9 `当前的`bash /home/devstack/stack.sh`进程，然后编辑`~/.pip/pip.conf`所用到的`pip`源，用`root`安装刚才`pip`卡住的模块，再跑一遍`bash /home/devstack/stack.sh`应该就可以通过刚才卡住的地方了。

- 同样在运行`bash /home/devstack/stack.sh`的时候，会发现`git clone`某个模块，比如`nova`，会很慢，几乎一个多小时都卡住没消息。
  - 我的处理：此时同样地先`kill`掉脚本，然后根据刚才日志所提示的`git clone xxxxx/nova /opt/stack/nova --branch master`自己`git clone`下来会比脚本下载的要快，然后下载完了之后重新跑`bash /home/devstack/stack.sh`应该就可以通过刚才卡住的地方了。



