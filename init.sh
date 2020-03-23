source activate gmatic
#conda env export > doc/environment.yml

if [ ! -d fastqc ]; then
	mkdir -p fastq fastqc/raw fastqc/clean clean bam RSEM count edgeR table stat figure RData 
fi
