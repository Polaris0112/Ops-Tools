# -*- coding:utf-8 -*-
def kp(arr,i,j):#快排总函数
                #制定从哪开始快排
    if i<j:
        base=kpgc(arr,i,j)
        kp(arr,i,base)
        kp(arr,base+1,j)
def kpgc(arr,i,j):#快排排序过程
    base=arr[i]
    while i<j:
        while i<j and arr[j]>=base:
            j-=1
        while i<j and arr[j]<base:
            arr[i]=arr[j]
            i+=1
            arr[j]=arr[i]
        arr[i]=base
    return i
ww=[3,2,4,1,59,23,13,1,3]
print ww
kp(ww,0,len(ww)-1)
print ww

