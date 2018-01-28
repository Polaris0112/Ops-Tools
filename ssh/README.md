## ssh session生成工具

### 使用介绍

此工具用于生成SecureCRT、XShell，这两款ssh连接工具的会话文件，来源是服务器上当前用户家目录中`~/.ssh/config`文件作为数据源。

依赖命令：

- `zip`：用于打包压缩生成的会话文件


脚本：

- `CRT_config.sh`：生成`SecureCRT`软件的会话文件脚本，运行`sh CRT_config.sh`完成后会生成一个`CRT_config.zip`的压缩文件，把这个压缩文件传到你的windows下`SecureCRT`存放会话文件的目录并解压即可。

- `xshell_config.sh`：生成`XShell`软件的会话文件脚本，运行`sh xshell_config.sh`完成后会生成一个`xshell_config.zip`的压缩文件，同上把它解压到`XShell`存放会话文件的文件夹即可使用。


`~/.ssh/config`模板例子：

```shell
Host    别名

    HostName        主机名

    Port            端口

    User            用户名

    IdentityFile    密钥文件的路径（可选）
```









