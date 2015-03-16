import os
from recsys.evaluation.ranking import AveragePrecision
from recsys.evaluation.ranking import ReciprocalRank
testfile = open("testset_txt_img_cat.list","r")
resultsfolder="../Java/Results/"
lines = testfile.xreadlines()
GT=[]
ap = AveragePrecision()
rr = ReciprocalRank()
for line in lines:
	GT.append(line.split()[2])
#	GT.append(line.strip())
CCA = resultsfolder
for fname in os.listdir(CCA):
	content = open(CCA+"/"+fname,"r")
	values = content.xreadlines()
	q=[]
	for each in values:
		q.append(each.strip())
	sum10=0.0
	totmrrsum=0
	count=0
	count1=0
	for i,j in zip(GT,q):
		num=0.0
		denom=1.0
		localsum=0.0
		q1 = j.split()
		for corr in q1:
			if i==corr:
				num=num+1.0
				localsum=localsum+(num/denom)
			denom=denom+1.0
		#print localsum, num
		if num!=0.0:
			sum10=sum10+(localsum/num)
			count=count+1
		rr.load(q1,i)
		valrr=rr.compute()
		if valrr!=0.0:
			totmrrsum=totmrrsum+rr.compute()
			count1=count1+1
	print fname, "MAP=",sum10/693, " MRR=",totmrrsum/693
