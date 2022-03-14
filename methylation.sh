ls *.fq.gz | sed 's/_[12].fq.gz//' | uniq > filelist.txt
mkdir mapping
mkdir dedup

cat filelist.txt | while read line ; do
#mapping
bismark --genome /media/hp/disk1/lu/clean/sample/bismark/ -1 ${line}_1.fq.gz -2 ${line}_2.fq.gz -o /media/hp/disk1/lu/clean/sample/mapping --parallel 24 2>> mapping_report.txt
#deduplicate
deduplicate_bismark -p mapping/${line}_1_bismark_bt2_pe.bam --output_dir dedup
done

mkdir methlation
cat filelist.txt | while read line 
do
    bismark_methylation_extractor -p --parallel 24 \
        --comprehensive \
        --no_overlap --bedGraph \
        --counts --buffer_size 200G \
        --report --cytosine_report  \
        --genome_folder 00ref \
        $Bam -o methlation
done
