#First run extract_phe.sh with mn_fields.txt

library(data.table)

#Read variable file (already filtered on the most recent gid_current)
dt <- fread("/mnt/scratch/examples/ukb_phenotype_2021-09-23.txt.gz")

#Find ICD code feilds 
icd_cols <- grep('f.41270',names(dt),value=TRUE)

#Reshape wide to long
icd_long <- melt(setDT(dt), id.vars = 1, measured.vars = icd_cols, variable.name = "feild", value.name="icd_10")

# Cleanup ICD10 codes; i.e. add dot and remove suffixes
icd_long[,ICD10category:=gsub("([A-Z][0-9]{2}).+","\\1",icd_long$icd_10)]
icd_long[,ICD10suffix:=gsub("[A-Z].+","",gsub("^[A-Z][0-9]{2}","",icd_long$icd_10))]
icd_long[,ICD10:=paste0(ICD10category,ifelse(ICD10suffix == "","","."),icd_long$ICD10suffix)]

#ICD codes for mononuclesis
#Find ids with matching ICD code for your phenotype
idx10 <- which(icd_long$ICD10=="B27") # Exact match
idx10category <- which(icd_long$ICD10category=="B27") # Match category
idx = sort(union(idx10, idx10category))
cases <- unique(icd_long$f.eid[idx])

#Add column for those IDs to the main dataset
dt$MN_ICD10 <- ifelse(dt$f.eid %in% cases, 1, 0)

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

