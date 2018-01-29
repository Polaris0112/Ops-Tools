## Puppet 安装工具和部分使用指南

### 使用介绍

- `master-install`：同时安装`puppet`服务端、客户端，适用于CentOS6/CentOS7

- `client-install.sh`：安装`puppet`客户端，第一个参数需要指定`master ip`，适用于CentOS6/CentOS7

- `fileserver.conf`：定义`puppet master`文件服务器的配置文件，部署在`/etc/puppet`下

- `init.pp`：模块的主入口文件

- `site.pp`：是`puppet`的主入口文件


### 部分使用指南

### puppet语法

```shell
Usage : puppet <subcommand> [options] <action> [optins]

子目录的查看帮助语法是
'puppet help <subcommand> <action>' for help on a specific subcommand action
'puppet help <subcommand>'for help on a specific subcommand

查看所有可用的资源类型
puppet describe --list
```

#### manifest
puppet的程序文件叫做manifest,以.pp作为文件后缀名

puppet语言核心是’资源定义’ , 定义一个资源核心就在于描述目标状态
manifest实现了常见的程序逻辑,如条件语句,资源集合等
manifest定义resource
“puppet apply”子命令能将一个manifest中描述的目标状态强制实现

#### 资源定义

```shell
syntax

every resource has a type , a title , and a set of attributes

type {'title':
    attribute => value,
}

示例
user {'puppet':
    ensure  =>present,
    gid     =>'666',
    uid     =>'666',
    shell   =>'/bin/bash',
    home    =>'/home/puppet',
    managehome  =>true,
}
```
注意:

在定义资源类型时必须使用小写字符,

资源名称仅是一个字符串,但是要求在同一个类型中必须唯一

比如,可以用名字叫nginx的service资源和package资源,但是在package类型的资源中只能有一个名叫nginx

puppet resource 命令可以交互式查找和修改puppet资源

#### 资源类型

##### group
- manage group

- 使用puppet describe group 命令来获取帮助

attribute:

- name:组名,可以不写,不写的话就默认title是组名

- gid:GID

- system:是否是系统组

- ensure:目标状态 present/absent

- members:成员用户

##### user

- manage users

- 使用puppet describe user 命令来获取帮助

attribute:

- name:用户名,不写则title默认就是用户名

- ensure:present/absent

- uid

- gid

- groups:附加组,不能包含基本组

- comment:注释

- expiry:过期时间

- home:家目录

##### package

- manage packages

attribute:

- ensure:installed , present , latest , absent

- name:包名

- source:程序包来源,一般是已经自己搞好的rpm或者dpkg

##### service
- manage running services

attribute:

- ensure:stopped(also called ‘false’) , running(also called ‘true’)

- enable:true/false/manual

- name:

- path:

- restart

##### file

manages files,including their content , ownership , and permissions

attribute:

- ensure:present , absent , file , directory , link

- file:普通文件,内容由content属性生成或者复制source属性文件路径来创建

- link:符号链接文件,必须由target属性指明链接的目标文件

- directory:目录 , 同通过source指向的路径复制生成,recurse属性指明是否递归复制

- path:路径

- source:源文件

- content:文件内容

- target:符号链接的目标文件

- owner:属主

- group:属组

- mode:权限

- atime/ctime/mtime:时间戳

示例:

```shell
file{'test.txt';
    path        =>'/tmp/test.txt',
    ensure      =>file,
    content     =>"hello world",
    owner       =>'nginx',
    mode        =>0664
    source      =>'/etc/fstab',
}
file{'test.symlink';
    path        =>'/tmp/test.symlink',
    ensure      =>link,
    target      =>'/tmp/test.txt',
    require     =>File['test.txt'],
}
```

##### exec

user/group:运行命令的用户身份

path

onlyif:指定一个命令,此命令执行成功,当前命令才能运行

unless:指定一个命令,此命令运行失败,当前命令才会运行

refresh:重新执行当前command的替代命令

refreshonly:仅接收到订阅的资源的通知才会运行

cron
command:要执行的任务

ensure:present/absent

hour:

minute:

monthday

month

weekday:

user

target:添加为哪个用户的任务

name:cron job的名称

notify
attribute:

- message:信息内容

- name:信息名称

##### 特殊资源命令

Name/Namevar

most types have an attribute whith identifies a resource on the target system
this is referred to as the ‘namevar’ , and is often simply called ‘name’
namevar values must be unique per resource type , with only rare exceotions(such as exec)
ensure

ensure =>file 存在且为一个普通文件
ensure =>directory 存在且为一个目录
ensure =>present 存在,可通用于上述描述情况
ensure=>absent 不存在
资源间的次序
puppet提供了before,require,notify,subscribe来定义资源间的相关性

资源的引用通过”Type[‘title’]”的方式进行,如User[‘nginx’]

比如

```shell
user{'redis':
    ensure      =>present,
    gid         =>800,
    uid         =>800,
    system      =>true,
}

group{'redis';
    ensure      =>present,
    gid         =>800,
    system      =>true,
    before      =>User['redis'],
}
```

##### puppet中的类
类:puppet中命名的代码模块,常用于定义一组通用的目标资源,可在puppet全局调用

类可以被继承,也可以包含子类

语法格式

```shell
class NAME{
    ...puppet code...
}

class NAME(parameter1,parameter2){
    ....puppet code....
}
```

类代码只有声明之后才会执行,调用方式

``` shell
include CLASS_NAME1,CLASS_NAME2,…

class{‘CLASS_NAME’:

  attribute =>value,

}
```
示例
```shell
class apache2{
    $pkgname=$opratingsystem?{
    /(?i-mx:(ubuntu|debian))/   =>'apache2',
    /(?i-mx:(redhat|fedora|centos))/  =>'httpd',
    default                     =>'httpd',
}

    package{"$webpkg":
        ensure =>installed,
    }

    file{'/etc/httpd/conf/httpd.conf':
        ensure      =>file,
        owner       =>root,
        group       =>root,
        source      =>'/tmp/httpd.conf',
        require     =>Package["$webpkg"],
        notify      =>Service['httpd'],
    }

    service{'httpd':
        ensure      =>running,
        enable      =>true,
    }
}

include apache2
```

示例2

```shell
class web($webserver='httpd'){
    package{"$webserver":
        ensure      =>installed,
        before      =>[File['httpd.conf'],Service['httpd']],
    }

    file{'httpd.conf':
        path        =>'/etc/httpd/conf/httpd.conf',
        source      =>'root/manifests/httpd.conf',
        ensure      =>file,
    }

    service{'httpd':
        ensure      =>running,
        enable      =>true,
        restart     =>'systemctl restart httpd.service',
        subscribe   =>File['httpd.conf'],
    }
}

class{'web':
    webserver   =>'apache2',
}
```

类继承的方式

```shell
class SUB_CLASS_NAME inherits PARENT_CLASS_NAME{
    .....puppet code...
}
```

在子类中为父类的资源新增属性或者覆盖指定的属性的值

```shell
Type['title']{:
    attribute       =>value,
    ...
}

比如
class nginx::proxy inherits nginx {
    Service['nginx']{
        subscribe       =>File['nginx-proxy.conf'],
    }
```

##### puppet模板

文本文件中内嵌变量替换机制

```shell
<%= @VARIABLE_NAME %>

file{'title':
    ensure      =>file,
    content     =>template('/PATH/TO/ERB_FILE'),
}

示例
file{'nginx.conf':
    path        =>'/etc/nginx/nginx.conf',
    ensure      =>file,
    content     =>template('/root/manifests/nginx.conf.erb'),
    require     =>Package['nginx'],
}
```

模块就是按照一个约定的预定义的结构存放了多个文件或子目录的目录,目录里的这些文件或者子目录必须遵照一定的格式命名规范

puppet会在配置的路径下查找所需要的模块

MODULES_NAME:

- manifests/

- init.pp

- files/

- templates/

- lib/

- spec/

- tests/

模块名只能以小写字母开头,可以包含小写字母,数字和下划线,但是不能使用”main”和”settings”

manifests/

- init.pp:必须一个类定义,类名称必须与模块名称相同

files/:静态文件

- puppet URL

- puppet:///modules/MODULE_NAME/FILE_NAME

templates/

- template(‘MOD_NAME/TEMPLATE_FILE_NAM’)

lib/:插件目录,常用于存储自定义的facts以及自定义类型

spec/ 类似于tests目录,存储lib/目录下插件的使用帮助和范例

tests/ 当前模块的使用帮助或使用范例文件

puppet config命令

- 获取或设定puppet配置参数

- puppet config print [argument]

- puppet查找模块文件的路径:modulepath

- puppet config print modulepath ,

可以指定自己要的路径,比如:

```shell
puppet apply --modulepath=/root/dev/modules -e "include::server"
```

模块更多的语法可以用puppet help module








