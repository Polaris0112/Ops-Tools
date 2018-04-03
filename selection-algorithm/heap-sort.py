# -*- coding:utf-8 -*-
def head_sort(list):
	length_list = len(list)
	first=int(length_list/2-1)
	for start in range(first,-1,-1):
		max_heapify(list,start,length_list-1)
	for end in range(length_list-1,0,-1):
		list[end],list[0]=list[0],list[end]
		max_heapify(list,0,end-1)
	return list

def max_heapify(ary,start,end):
	root = start
	while True:
		child = root*2 + 1
		if child > end:
			break
		if child + 1 <= end and ary[child]<ary[child+1]:
			child = child + 1
		if ary[root]<ary[child]:
			ary[root],ary[child]=ary[child],ary[root]
			root=child
		else:
			break
#测试：
list=[10,23,1,53,654,54,16,646,65,3155,546,31]
print head_sort(list)
