# -*- coding:utf-8 -*-
def count_sort(list):
	max=min=0
	for i in list:
		if i < min:
			min = i
		if i > max:
			max = i 
	count = [0] * (max - min +1)
	for j in range(max-min+1):
		count[j]=0
	for index in list:
		count[index-min]+=1
	index=0
	for a in range(max-min+1):
		for c in range(count[a]):
			list[index]=a+min
			index+=1
	return list
	#测试：
list=[10,23,1,53,654,54,16,646,65,3155,546,31]
print count_sort(list)
