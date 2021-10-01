#First run extract_phe.sh with mn_fields.txt

library(data.table)

#Read variable file (already filtered on the most recent gid_current)
dt <- fread("ukb_phenotype_2021-09-23.txt.gz")

#ICD code for mononucleosis
icd10 <- "B27"
icd_cols <- grep('f.41270',names(dt),value=TRUE)

#Go through ICD instance columns and identify those who had any B27 diagnose at any time
dt$MN_ICD10 <- apply(dt[,..icd_cols], MARGIN=1, FUN = function(x) {ifelse(any(grepl(icd10,x)==T),1,0)})

#Name and create base variables
setnames(dt,"f.eid","FID")
setnames(dt,"f.22001.0.0","Sex")
setnames(dt,"f.34.0.0","BirthYear")

dt$IID <- dt$FID
dt$PATID <- 0
dt$MATID <- 0

#Create 
dt[,Chip:=as.integer(f.22000.0.0>0)]

#Rename principal components variables
for(num in 1:40){setnames(dt,paste("f.22009.0.",as.character(num),sep=""),paste("PC",as.character(num),sep=""))}

#Filter out sex mismatch individuals and sex chromosome aneuploidies
dt <- dt[dt$"f.31.0.0" == dt$Sex]
dt <- dt[is.na(dt$"f.22019.0.0")]


out <- dt[,c("FID","IID","PATID","MATID","MN_ICD10","BirthYear","Sex","Chip","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10")]

write.table(out,"/mnt/scratch/examples/MN_ICD10_2021-09-23_phenoConstruct.txt",sep="\t",quote=F,col.names=T,row.names=F)

