#!/bin/bash
status=`sudo ipvsadm -ln | egrep -v TCP | egrep -c ":(80|443)"`
echo $status
