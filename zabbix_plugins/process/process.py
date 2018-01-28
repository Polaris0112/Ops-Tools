#!/usr/bin/env python
# -*- coding: utf-8 -*-
# author: chenjiajian
# date:2017-04-24
import string
import sys
import re
import os
import time

def read_line(line):
    line = line.strip('\n').strip()
    programname = line.split()[11]
    memoryuse = line.split()[5]
    cpuuse = line.split()[8]
    pid = line.split()[0]
    return programname,memoryuse,cpuuse,pid


def check_file(path):
    for i in range(50):
        if os.path.getsize(path) > 1000:
            break
        else:
            time.sleep(0.2) 
            continue
    return True
            

def getdata(file_path):
    check_file('/tmp/top.txt')
    with open(file_path) as f:
        top_content = f.readlines()
    f.close()
    result=[]
    for line in top_content[8:]:
        if len(line) > 5 and len(line.split()) != 0:
            result.append(list(read_line(line.strip())))
    return result

def topprogram(file_path):
    date=getdata(file_path)
    top={}
    for i in date:
        if 't' in i[1]:
            i[1]=string.atof(i[1].split('t')[0])*1073741824
        elif 'g' in i[1]:
            i[1]=string.atof(i[1].split('g')[0])*1048576
        elif 'm' in i[1]:
            i[1]=string.atof(i[1].split('m')[0])*1024
        else:
            i[1]=string.atof(i[1])
        if top.get(i[0]):
            top[i[0]]=[top[i[0]][0]+i[1],top[i[0]][1]+string.atof(i[2]),i[3]]
        else:
            top.setdefault(i[0],[i[1],string.atof(i[2]),i[3]])
    return sorted(top.items(),key=lambda d:d[1][0])[-1:-11:-1]

def tonetflow(file_path,data):
    for i in data:
        pid = i[1][2]
        check_file('/tmp/netstat.txt')
        with open('/tmp/netstat.txt','r') as g:
            netstat_content = g.readlines()
        g.close()
        for li in netstat_content:
            if re.search(pid, li):
                break
        else:
            pid = os.popen("ps -ef|grep "+str(i[1][2])+"|grep -Ev 'grep|vim'|awk '{printf $3}'").read()
        for li in netstat_content:
            if re.search(pid, li) and len(i[1]) == 3:
                port = li.split()[3].split(':')[-1]
                TCPFLOW_IN=os.popen("sudo iptables -nvx -L|grep 'tcp dpt:"+str(port)+"' |awk '{print $2}'").read()
                UDPFLOW_IN=os.popen("sudo iptables -nvx -L|grep 'udp dpt:"+str(port)+"' |awk '{print $2}'").read()
                if TCPFLOW_IN != '' and UDPFLOW_IN !='':
                    FLOW_IN = float(TCPFLOW_IN.split()[0]) + float(UDPFLOW_IN.split()[0])
                elif TCPFLOW_IN != '' and UDPFLOW_IN =='':
                    FLOW_IN = float(TCPFLOW_IN.split()[0])
                elif TCPFLOW_IN == '' and UDPFLOW_IN !='':
                    FLOW_IN = float(UDPFLOW_IN.split()[0])
                else:
                    FLOW_IN = 0.0
                TCPFLOW_OUT=os.popen("sudo iptables -nvx -L|grep 'tcp spt:"+str(port)+"' |awk '{print $2}'").read()
                UDPFLOW_OUT=os.popen("sudo iptables -nvx -L|grep 'udp spt:"+str(port)+"' |awk '{print $2}'").read()
                if TCPFLOW_OUT != '' and UDPFLOW_OUT !='':
                    FLOW_OUT = float(TCPFLOW_OUT.split()[0]) + float(UDPFLOW_OUT.split()[0])
                elif TCPFLOW_OUT != '' and UDPFLOW_OUT =='':
                    FLOW_OUT = float(TCPFLOW_OUT.split()[0])
                elif TCPFLOW_OUT == '' and UDPFLOW_OUT !='':
                    FLOW_OUT = float(UDPFLOW_OUT.split()[0])
                else:
                    FLOW_OUT = 0.0
                if len(i[1]) == 5:
                    i[1][-2] = i[1][-2] + FLOW_IN
                    i[1][-1] = i[1][-1] + FLOW_OUT
                else:
                    i[1].append(FLOW_IN)
                    i[1].append(FLOW_OUT)
                break
        else:
            if len(i[1]) == 3:
                FLOW_IN = 0.0
                i[1].append(FLOW_IN)
                FLOW_OUT = 0.0
                i[1].append(FLOW_OUT)

    return data
    

def translatejson(file_path):
    data=topprogram(file_path)
    print '{'
    print '  \"data\":['
    for i in data:
        if i != data[-1]:
            print '{\"{#TABLENAME}\":\"%s\"},' %i[0]
        else:
            print '{\"{#TABLENAME}\":\"%s\"}' %i[0]
    print '    ]'
    print '}'

def printdata(file_path,key):
    data=topprogram(file_path)
    data=tonetflow(file_path,data)
    for i in data:
        if key[1] == 'cpu':
            if key[0] == i[0]:
                print i[1][1]
                break
        elif key[1] == 'mem':
            if key[0] == i[0]:
                print i[1][0]
                break
        elif key[1] == 'flowin':
            if key[0] == i[0]:
                print i[1][-2]
                break
        else:
            if key[0] == i[0]:
                print i[1][-1]
                break
    else:
        print float('0.0')


def main():
    file_path='/tmp/top.txt'
    if sys.argv[1] == 'json':
        translatejson(file_path)
    else:
        key = [sys.argv[1],sys.argv[2]]
        printdata(file_path,key)

if __name__=='__main__':
    #try:
        main()
    #except Exception as e:
    #    print e
