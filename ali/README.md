## 阿里云相关工具

### 使用介绍

-  `ecs_expansion.sh`：首先修改工具7-9行，分别是硬盘设备名`device`，分区名`part`和挂载点`node`为需要扩容的对应变量，然后执行`sh ecs_expansion.sh`即可。

-  `mount_disk.sh`：这个脚本是根据阿里云服务器初始化的，因为阿里云有分系统盘和数据盘，数据盘一开始均为vdb，所以这个脚本不用修改什么，就直接`sh mount_disk.sh`就会把数据盘分区、格式化、挂载和写入到/etc/fstab中，下次重启就能自动挂载。



