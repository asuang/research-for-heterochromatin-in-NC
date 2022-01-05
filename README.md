**<font color="grey"><font size=5>Analysis and visualization of ChIP-Seq  </font></font>**
##   <font size=4>step1 ChIP_seq.sh (RNA-seq mappers)</font> 
This step is to process raw reads with QC, adapter trimming, alignment, discarding multiple hits, normalizing enrichment and peak callling.
You need to install following softwares for each step: <kbd>fastqc</kbd> ,<kbd>trim_galore</kbd> ,<kbd>bowtie2</kbd> ,<kbd>picard</kbd> ,<kbd>bamCoverage(deepTools)</kbd> , <kbd>macs2</kbd> .
 ##   <font size=4>step2 denoise.py (RNA-seq mappers)</font> 
This step is to denoise the backgroud signal with the sliding window.
  ##   <font size=4>step3 normalize_bw.py (RNA-seq mappers)</font> 
  This step is to normalize .bw files for metagene analysis by  <kbd>deepTools</kbd>.Briefly, this script is used to normalize each region by the max value of themselves. The using example is shown below.
  ```shell
  computeMatrix reference-point -p 16 --referencePoint TES -S bw_normalize/${sample_name}.bw -R /media/hp/disk1/song/Genomes/NC10/Genes/intersect_wt_RIP.bed -b 1500 -a 3000 --skipZeros -o  ${sample_name}_end.mat.gz
  python hequn_chip.py -d /media/hp/disk4/shuang/ChIP_seq/hequn -f  ${sample_name}_end.mat.gz  ${sample_name}_end.nm
  plotProfile -m ${sample_name}_end.nm.gz --perGrop -out ${sample_name}_end.pdf
  ```

**<font color="grey"><font size=5>Analysis and visualization of WGBS  </font></font>**
##   <font size=4>step1 methylation.sh (RNA-seq mappers)</font> 
This step is to process clean reads with alignment, deduplicate,extracting methlation.
You need to install following softwares for each step: <kbd>bismark</kbd> ,<kbd>bowtie2</kbd>,<kbd>bedGraphToBigWig</kbd>
  ##   <font size=4>step2 normalize_bw.py (RNA-seq mappers)</font> 
  This step is to normalize .bw files for metagene analysis by  <kbd>deepTools</kbd>.Briefly, this script is used to normalize each region by the max value of themselves. The using example is shown below.
  ```shell
  computeMatrix reference-point -p 16 --referencePoint TSS -S ${sample_name}.bw -R /media/hp/disk1/song/Genomes/NC10/Genes/intersect_wt_RIP.bed -b 3000 -a 1500 --skipZeros -o  ${sample_name}_start.mat.gz  
  computeMatrix reference-point -p 16 --referencePoint TES -S ${sample_name}.bw -R /media/hp/disk1/song/Genomes/NC10/Genes/intersect_wt_RIP.bed -b 1500 -a 3000 --skipZeros -o  ${sample_name}_end.mat.gz
  python hequn_chip.py -d /media/hp/disk4/shuang/ChIP_seq/hequn -f  ${sample_name}_start.mat.gz  ${sample_name}_start.nm
  python hequn_chip.py -d /media/hp/disk4/shuang/ChIP_seq/hequn -f  ${sample_name}_end.mat.gz  ${sample_name}_end.nm
  python hequn_chip.py -d /media/hp/disk4/shuang/ChIP_seq/hequn -f  ${sample_name}_end.mat.gz  ${sample_name}_end.nm  
  plotProfile -m ${sample_name}_end.nm.gz --perGrop -out ${sample_name}_end.pdf
  ```
