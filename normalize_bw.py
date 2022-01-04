#This script is used to the output file of computeMatrix and every sample to be normalized by their max value
import argparse
import getopt
import sys
import re
import os
import numpy
import operator

numpy.seterr(divide='ignore',invalid='ignore')
# get the python script input method2
parser=argparse.ArgumentParser(description="normalize again to the output file of computeMatrix")
parser.add_argument("-f","--filename",type=str,metavar="filename",required=True,help="please input the name of the input file")
parser.add_argument("-o","--outfilename",type=str,metavar="filename",required=True,help="please input the name of the output file")
parser.add_argument("-d","--doc",type=str,metavar="sample",required=True,help="the location where your files are.pattern like this :/media/hp/disk4/shuang/Ribo_seq/XXX")
args=parser.parse_args()
fname=args.filename
oname=args.outfilename
sample=args.doc


matrix=os.popen("less "+sample+"/"+fname).readlines()
nm_m=open(sample+"/"+oname,'w')
for l in matrix:
    l=l.strip()
    if "@" in l:
        nm_m.writelines(l+"\n")
        n=re.match(r'.*sample_boundaries.*?(\[(.*)\]).*',l).group(2).split(",")
        continue
    value=l.split("\t")
    value1=value[:6]
    nm_m.writelines("\t".join(value1)+"\t")
    value2=value[6:]
    value2=list(map(float,value2))
    for i in range(len(n)-1):
        s=numpy.array(value2[int(n[i]):int(n[i+1])])
        try:
            s=s/numpy.max(s[list(map(operator.not_,numpy.isnan(s)))])
        except:
            s=s/1
        s=list(map(str,numpy.round(s,6)))
        nm_m.writelines("\t".join(s)+"\t")
    nm_m.writelines("\n")
nm_m.close()
os.system("gzip "+oname)
