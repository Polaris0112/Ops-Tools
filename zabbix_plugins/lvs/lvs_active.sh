#!/bin/bash
Inactive_count=0
for NUM in `sudo ipvsadm -ln| grep Route | awk '{print $6}'`
do
Inactive_count=$(($Inactive_count+ $NUM))
done
echo $Inactive_count
