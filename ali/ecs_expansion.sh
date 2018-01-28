#!/bin/bash
# Ali-ecs-q3-data-disk-expansion shell script
# run as root
# author  cjj


device="/dev/vdb"
part="/dev/vdb1"
node="/data"

## 安装lsof方便查看在节点中正在打开的文件
/usr/bin/yum install -y lsof >/dev/null 2>&1


echo -e "Before expansion\n"
df -Th |grep $node

## 卸载对应节点
/bin/umount $node
if [ $? -eq 1 ];then
    echo -e "=============\n"
    /usr/sbin/lsof $node
    if [ $? -eq 0 ];then
        echo "These files are opened in $node. So umount $node failed" 
    else
        echo "Other errors."
    fi
    exit 1
fi

## 对硬盘进行重新分区
echo "d
n
p
1


wq
" | /sbin/fdisk $device # > /dev/null 2>&1


## 检查文件系统，并变更文件系统大小
/sbin/e2fsck -f $part # > /dev/null 2>&1
/sbin/resize2fs $part # > /dev/null 2>&1


## 重新挂载节点
/bin/mount $part $node


## 查看结果
echo -e "============="
echo -e "After expansion\n"
/bin/df -Th |grep $node

