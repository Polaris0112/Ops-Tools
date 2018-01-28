#!/usr/bin/env python
#ecoding:utf-8


import os, json



cmd = 'cat /proc/cpuinfo| grep "processor"| wc -l'
cpus = []
try:
        totalnum = int(os.popen(cmd).read())
        for i in range(0, totalnum):
                cpus += [{'{#CPU_ID}':i}]
        print json.dumps({'data':cpus},separators=(',',':'))
except BaseException,e:
        print e


