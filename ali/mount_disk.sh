#!/bin/bash

mount|grep vdb1

if [[ $? -eq 1 ]];then
    echo "n
p
1


w
    " | fdisk /dev/vdb
    mkfs.ext4 /dev/vdb1
    mkdir -p /data
    echo '/dev/vdb1 /data ext4 defaults 0 0' >> /etc/fstab
    mount /dev/vdb1 /data
else
    echo "Already mount"
fi

