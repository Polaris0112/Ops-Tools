#!/bin/bash
# run as root


yum -y install epel-release git net-tools
cd /home
git clone https://github.com/openstack-dev/devstack.git -b stable/mitaka
cd /home/devstack/tools/
bash ./create-stack-user.sh
chown -R stack:stack /home/devstack
chmod 777 /opt/stack -R
su - stack  -c cat /home/devstack/.localrc <<EOF
# Misc
ADMIN_PASSWORD=admin
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
SERVICE_TOKEN=\$ADMIN_PASSWORD

# Target Path
DEST=/opt/stack

# Enable Logging
LOGFILE=\$DEST/logs/stack.sh.log
VERBOSE=True
LOG_COLOR=True
SCREEN_LOGDIR=\$DEST/logs

KEYSTONE_TOKEN_FORMAT=UUID

# Nova
enable_service n-novnc n-cauth

# Neutron
disable_service n-net
ENABLED_SERVICES+=,q-svc,q-agt,q-dhcp,q-l3,q-meta,neutron
ENABLED_SERVICES+=,q-lbaas,q-vpn,q-fwaas
# Swift
#enable_service s-proxy s-object s-container s-accounts
#SWIFT_HASH=66a3d6b56c1f479c8b4e70ab5c2000f5

# Cinder
VOLUME_GROUP="cinder-volumes"
ENABLED_SERVICES+=,cinder,c-api,c-vol,c-sch,c-bak

# Ceilometer
#enable_service ceilometer-acompute ceilometer-acentral ceilometer-anotification ceilometer-collector ceilometer-api
#enable_service ceilometer-alarm-notifier ceilometer-alarm-evaluator

# Heat
enable_service heat h-api h-api-cfn h-api-cw h-eng
enable_service tempest

# Trove
enable_service trove tr-api tr-tmgr tr-cond

# Sahara
enable_service sahara

# Murano
enable_plugin murano git://git.openstack.org/openstack/murano
enable_service murano-cfapi
enable_service g-glare
MURANO_APPS=io.murano.apps.apache.Tomcat,io.murano.apps.Guacamole
enable_service murano murano-api murano-engine
GIT_BASE=https://github.com

EOF

su -u stack -c "bash /home/devstack/stack.sh"
