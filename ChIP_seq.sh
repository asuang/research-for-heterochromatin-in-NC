#!/bin/sh

echo "job started"
start_time=`date +%s`
species="NC10"
mkdir fastqc
mkdir trimmed_fastq
cd fq
ls -d */ |sed 's/\///' | uniq > filelist.txt

cat filelist.txt | while read i
do
	trim_galore -j 2 --paired ${i}/${i}_1.fq.gz ${i}/${i}_2.fq.gz -o ../trimmed_fastq --basename ${i} 
	
done

cd ..

cp fq/filelist.txt ./

cat filelist.txt | while read line
do 
	fastqc -o ./fastqc -t 16 trimmed_fastq/${line}_val_1.fq.gz trimmed_fastq/${line}_val_2.fq.gz 
done

mv trimmed_fastq/*.txt ./fastqc  

multiqc fastqc -o ./fastqc

cat filelist.txt | while read line; do

	
	input=`echo ${line} | sed 's/_BMR.*//'`
	echo ${input}
	echo ${input} >> mapping_report.txt

	bowtie2 -S trimmed_fastq/${input}.sam -p 16 -x /media/hp/disk1/song/Genomes/${species}/Sequence/WholeGenomeFasta/bowtie2/NC10 -1 trimmed_fastq/${line}_val_1.fq.gz -2 trimmed_fastq/${line}_val_2.fq.gz 2>> mapping_report.txt

	samtools view -@ 16 -Sb trimmed_fastq/${input}.sam > trimmed_fastq/${input}.bam
	samtools sort -@ 16 trimmed_fastq/${input}.bam -o trimmed_fastq/${input}.sort.bam

	java -jar /media/hp/disk4/shuang/picard/picard.jar MarkDuplicates I=trimmed_fastq/${input}.sort.bam O=trimmed_fastq/${input}.sort.markdup.bam M=trimmed_fastq/${input}.markdup.txt
	samtools index trimmed_fastq/${input}.sort.markdup.bam

	bamCoverage -p 16 -b trimmed_fastq/${input}.sort.markdup.bam -o trimmed_fastq/$input.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 41037538 --extendReads 200
	rm trimmed_fastq/${input}.sam

done

mkdir peak
cat filelist.txt |sed 's/_ChIP_BMR.*//' | sed 's/_input_BMR.*//'  | sort | uniq > filelist1.txt 
cat filelist1.txt | while read LINE; do
	
	input=`echo "$LINE" `

	cd peak
	macs2 callpeak -t ../trimmed_fastq/${input}_ChIP.bam -c ../trimmed_fastq/${input}_input.bam -f BAM -g 4.1e8 -q 0.05 --broad --max-gap 500 -n $input 
	cd ..

done