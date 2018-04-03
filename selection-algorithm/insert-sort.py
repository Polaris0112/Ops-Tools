# -*- coding:utf-8 -*-
def insert_sort(lists):
    # 插入排序
    count = len(lists)
    for i in range(1, count):
        key = lists[i]
        j = i - 1
        while j >= 0:
            if lists[j] > key:
                lists[j + 1] = lists[j]
                lists[j] = key
            j -= 1
    return lists
#测试
lists=[10,23,1,53,654,54,16,646,65,3155,546,31]
print insert_sort(lists)
