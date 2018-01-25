#!/bin/bash
ACT_COUNT=0
for NUM in `sudo ipvsadm -ln| grep Route | awk '{print $5}'`
do
ACT_COUNT=$(($ACT_COUNT+ $NUM))
done
echo $ACT_COUNT
