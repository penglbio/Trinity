## run on HPC ##
nohup /cluster/home/lpeng/miniconda3/envs/gmatic/bin/snakemake --cluster qsub -j 32 -rp --latency-wait 3600 >> nohup.log 2>&1 &
