## MongoDB各类部署模板和备份回滚工具

### 使用介绍

#### 统一说明：

- `{{ path to log }}`：需要替换成mongodb日志文件的自定义路径，如`/data/db/mongodb/log/mongodb.log`

- `{{ path to data }}`：需要替换成mongodb存储的自定义路径，如`/data/db/mongodb/data`

- `{{ path to pid }}`：需要替换成mongodb存放pid文件的自定义路径，如`/var/run/mongodb/mongodb.pid`

- `{{ ip }}`：启动mongodb的ip地址，建议使用内网ip或者本地ip

- `{{ port }}`：启动mongodb的绑定端口，若启动前端口已经正在使用则会启动失败

- `{{ replSet name }}`：确定副本集的名字所用

- `{{ keyfile }}`：确认副本集集群节点的凭证，生成命令为
```shell
openssl rand -base64 756 > mongodb-keyfile
chmod 400 mongodb-keyfile
```

#### 文件说明

- `single`：MongoDB单节点配置文件模板

- `replSet`：MongoDB副本集配置文件模板

- `shard`：Mongodb分片+副本集配置文件模板
  - `shard.yml`：sharding配置文件模板（包含副本集）
  - `config.yml`：分片的config server配置文件模板（包含副本集）
  - `mongos.yml`：Mongos配置文件模板

- `rollback_script`：备份以及回滚操作工具
  - `dump.sh`：定时备份数据库工具，需要配置6-10行，对应MongoDB登录ip端口、用户密码（可选，如果需要用户登录的话，需要admin库的backup角色）
  - `restore.sh`：回档工具入口工具，需要编辑4-6行，对应填写`dump.sh`备份的绝对路径、回档的mongodb实例（建议与源实例分开以免污染源库）和源数据库的uri，可以查询当前可操作的回档点（按时间格式），然后跟住帮助命令`--restore`后面依次填入回档文件夹名（日期时间）、需回档数据库名、回档数据集合名、回档指定的字段和对应的值（这样可以确认是具体那条记录），然后就会先将指定时间点的备份恢复到回档mongodb实例中，从中寻找指定的那条document，再对源库进行修改。
  - `restore.py`：修改文件6-7行，写入指定回档mongodb的uri和源库的uri，此文件执行的是寻找回档数据库并恢复到源库的操作。









