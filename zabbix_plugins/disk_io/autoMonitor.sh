#!/bin/sh
#
# Filename:	autoMonitorDiskIO.sh
# Description: 部署zabbix low-level discovery 监控磁盘IO
# Notes: 在被监控客户端运行此脚本,前提条件已经安装好zabbix agent
#
ROOT_UID=0
if [ "$UID" -ne "$ROOT_UID" ];then
  echo "Error: Please run this script as root user."
  exit 1
fi
# 自行修改为你的zabbix agent配置文件路径
AGENT_CONF="/etc/zabbix/zabbix_agentd.conf"
mkdir -p /etc/zabbix/monitor_scripts
# 创建 low-level discovery mounted disk 脚本
cat > /etc/zabbix/monitor_scripts/mount_disk_discovery.sh << 'EOF'
#!/bin/bash
#Function: low-level discovery mounted disk
#Script_name: mount_disk_discovery.sh 
mount_disk_discovery()
{
  local regexp="\b(btrfs|ext2|ext3|ext4|jfs|reiser|xfs|ffs|ufs|jfs|jfs2|vxfs|hfs|ntfs|fat32|zfs)\b"
  local tmpfile="/tmp/mounts.tmp"
  :> "$tmpfile"
  egrep "$regexp" /proc/mounts > "$tmpfile"
  local num=$(cat "$tmpfile" | wc -l)
  printf '{\n'
  printf '\t"data":[ '
  while read line;do
    DEV_NAME=$(echo $line | awk '{print $1}')
    FS_NAME=$(echo $line | awk '{print $2}')
    SEC_SIZE=$(sudo /sbin/blockdev --getss $DEV_NAME 2>/dev/null)
    printf '\n\t\t{'
    printf "\"{#DEV_NAME}\":\"${DEV_NAME}\","
    printf "\"{#FS_NAME}\":\"${FS_NAME}\","
    printf "\"{#SEC_SIZE}\":\"${SEC_SIZE}\"}"
    ((num--))
    [ "$num" == 0 ] && break
    printf ","
  done < "$tmpfile"
  printf '\n\t]\n'
  printf '}\n'
}
case "$1" in
  mount_disk_discovery)
    "$1"
    ;;
  *)
    echo "Bad Parameter."
    echo "Usage: $0 mount_disk_discovery"
    exit 1
    ;;
esac
EOF
touch /tmp/mounts.tmp
chown zabbix:zabbix /tmp/mounts.tmp
chown -R zabbix:zabbix /etc/zabbix/monitor_scripts
chmod 755 /etc/zabbix/monitor_scripts/mount_disk_discovery.sh
# 判断配置文件是否存在
[ -f "${AGENT_CONF}" ] || { echo "ERROR: File ${AGENT_CONF} does not exist.";exit 1;}
include=`grep '^Include' ${AGENT_CONF} | cut -d'=' -f2`
# 在配置文件中添加自定义参数
if [ -d "$include" ];then
  cat > $include/disk_lld.conf << 'EOF'
UserParameter=mount_disk_discovery,/bin/bash /etc/zabbix/monitor_scripts/mount_disk_discovery.sh mount_disk_discovery
EOF
else
  grep -q '^UserParameter=mount_disk_discovery' ${AGENT_CONF} || cat >> ${AGENT_CONF} << 'EOF'
UserParameter=mount_disk_discovery,/bin/bash /etc/zabbix/monitor_scripts/mount_disk_discovery.sh mount_disk_discovery
EOF
fi
# 授权zabbix用户无密码运行/sbin/blockdev命令
chmod +w /etc/sudoers 
sed -i '/^Defaults\s\+requiretty/s/^/#/' /etc/sudoers
grep -q '^zabbix ALL=(ALL).*blockdev' /etc/sudoers || echo 'zabbix ALL=(ALL)	   NOPASSWD: /sbin/blockdev' >> /etc/sudoers
chmod 440 /etc/sudoers
# 重启agent服务
[ -f '/etc/init.d/zabbix-agent' ] && /etc/init.d/zabbix-agent restart || echo "需手动重启zabbix agent服务."

