# -*- coding:utf-8 -*-
def bubble_sort(lists):
    length=len(lists)
    for index in range(0,length):
        for i in range(index+1,length):
            if lists[index] > lists[i]:
                lists[index],lists[i]=lists[i],lists[index]
    return lists
#一下为测试其正确性：
lists=[10,23,1,53,654,54,16,646,65,3155,546,31]
print bubble_sort(lists)
