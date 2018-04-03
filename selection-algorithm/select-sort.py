# -*- coding:utf-8 -*-
def select_sort(lists):
    # 选择排序
    count = len(lists)
    for i in range(0, count):
        minn = i
        for j in range(i + 1, count):
            if lists[minn] > lists[j]:
                minn = j
        lists[minn], lists[i] = lists[i], lists[minn]
    return lists

#测试
lists=[10,23,1,53,654,54,16,646,65,3155,546,31]
print select_sort(lists)
