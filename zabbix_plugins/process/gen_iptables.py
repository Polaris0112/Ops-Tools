#!/usr/bin/env python
#-*-coding:utf-8-*-
# author: chenjiajian
# date: 2017-04-12

import os 

def get_tcp_port():
    return os.popen("netstat -tunlp|grep -vE 'only|Local'|grep tcp|awk '{print $4}'|awk -F':' '{print $NF}'|sort -u").read()

def get_udp_port():
    return os.popen("netstat -tunlp|grep -vE 'only|Local'|grep udp|awk '{print $4}'|awk -F':' '{print $NF}'|sort -u").read()



def write_tcp(iptables_data, tcp_port):
    for port in tcp_port:
        iptables_data += """
iptables -A INPUT -p tcp --dport """+ str(port) +""" -j ACCEPT
iptables -A OUTPUT -p tcp --sport """+ str(port) +""" -j ACCEPT
""" 
    return iptables_data


def write_udp(iptables_data, udp_port):
    for port in udp_port:
        iptables_data += """
iptables -A INPUT -p udp --dport """+ str(port) +""" -j ACCEPT
iptables -A OUTPUT -p udp --sport """+ str(port) +""" -j ACCEPT
"""
    return iptables_data

def main():
    tcp_port = get_tcp_port().split('\n')
    udp_port = get_udp_port().split('\n')

    while '' in tcp_port:
        tcp_port.remove('')

    while '' in udp_port:
        udp_port.remove('')
    
    print "tcp:",tcp_port
    print "udp:",udp_port

    iptables_data = """#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

## for ping:
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

"""

    iptables_data = write_tcp(iptables_data, tcp_port)
    iptables_data = write_udp(iptables_data, udp_port)
    
    iptables_data += """
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

service iptables save
"""
    with open('iptables.sh', 'w+') as f:
        f.truncate()
        f.write(iptables_data)
    f.close()

if __name__ == "__main__":
    main()

