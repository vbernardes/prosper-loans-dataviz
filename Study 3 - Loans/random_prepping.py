#!/usr/bin/python

quarter = range(1, 5)
year = range(2006, 2014)
month = range(1, 13, 6)

# for y in year:
# 	for q in quarter:
# 		print('"Q'+str(q)+' '+str(y)+'",'),


for y in year:
	for m in month:
		print('"'+str(y)+' '+str(m)+'",'),