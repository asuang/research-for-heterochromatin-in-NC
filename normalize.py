import sys
def main(file,fileout): 
    f = open(file,"r")
    fo = open(fileout,"w")
    dict1 = {}
    for line in f:
        if "#" not in line:
            a = line.strip().split("\t")
            if (int(a[2]) - int(a[1]))%10 != 0:
                fo.write(line)
            if (int(a[2]) - int(a[1]))%10 == 0:
                for j in range(int(a[1]),int(a[2]),10):
                    d = a[0]+"\t"+str(j)
                    dict1[d] = float(line.strip().split("\t")[-1])
    for k in dict1.keys():  
        n = 0
        c = k.split("\t")
        for i in range(int(c[1]),int(c[1])+100,10):
                e = c[0]+"\t"+str(i)
                if e not in dict1.keys():
                    n = n + 0
                if e in dict1.keys():
                    n += dict1[e]
        b = n/10
        fo.write(k+"\t"+str(int(c[1])+10)+"\t"+str(b)+"\n")
main(sys.argv[1],sys.argv[2])