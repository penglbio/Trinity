#setwd("/run/media/lpeng/PSC168/backup/data/39.HMZ0073_hedanxia_RNAseq_2020318/edgeR/")
egr<- dir("edgeR/")
egr <- egr[grepl("DE_results$",egr)]

argv <- commandArgs(T)
#argv[1]<- "RSEM/all_gene.isoform.TMM.EXPR.matrix"
#argv[2] <- "anno/Trinity_anno.tsv"
#argv[3] <- "table/DEG_table.tsv"
TMM <- read.table(argv[1])
anno <- read.delim(argv[2],row.names=1,header=F)
colnames(anno) <- c("UniprotID","Description")

DES_tbl <- NULL

for (i in 1:length(egr)){
    DEG <- read.table(paste0("edgeR/",egr[i]))
    samp_cmp<- paste0(DEG[1,1],"_vs_",as.vector(DEG[1,2]))
    colnames(DEG) <- paste0(samp_cmp,"_",colnames(DEG))
    DEGs<- DEG[,c(4,3,6)]
    DES_tbl <- merge(DES_tbl,DEGs,by="row.names",all=TRUE)
    rownames(DES_tbl) <- DES_tbl[,1]
    DES_tbl<- DES_tbl[,-1]
}

FC<- DES_tbl[,grepl("FC",colnames(DES_tbl))]
FDR <- DES_tbl[,grepl("FDR",colnames(DES_tbl))]
CPM <- DES_tbl[,grepl("CPM",colnames(DES_tbl))]
deTMM<- TMM[rownames(CPM),]
colnames(deTMM) <- paste0(colnames(deTMM),"_TMM")
DE <- ifelse(FC>1,1,-1)
DE<- ifelse(is.na(DE),0,DE)
colnames(DE) <- sub("_logFC","",colnames(DE))
ANNO<- anno[rownames(CPM),]

DES_tbl<- cbind(deTMM,CPM,DE,FC,FDR,ANNO)
DES_tbl<- data.frame(GeneID=rownames(DES_tbl),DES_tbl)

write.table(DES_tbl,argv[3],sep="\t", row.names=F, quote=F)
