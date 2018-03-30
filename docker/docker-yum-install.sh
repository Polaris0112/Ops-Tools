#!/bin/bash


## dependence
yum update -y
yum install -y yum-utils device-mapper-persistent-data lvm2

yum install -y docker


systemctl start docker
systemctl enable docker


mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://sdu7uwdm.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
