# ukb_define_ICD_phenotype

# Warning!
Do not transfer individual-level data off the lab    
Summary-level data can be tranfered as per our ethics application and UKBB approval   

## Description
These scripts are to define a phenotype based on ICD codes    

## Dependencies
To define a phenotype based on ICD codes you need to already have a file with the ICD codes.   
If you need to extract this, please follow these intructions:    
[Extract a phenotype or genotype file](https://github.com/benbrumpton/how-to-ukbb/blob/main/extract/extract.md)    

## Step 1
Copy this script to your project directory.
For example:
username@hunt-ukbb-home:~/scratch/repo/how-to-ukbb/define$ `cp define_ICD_phenotype.R ~/mnt/scratch/examples/`

## Step 2
Open the script in a text editor and edit the input and output

Replace the input file (below) with your custom file name and directory:
`dt <- fread("/mnt/scratch/examples/ukb_phenotype_2021-09-23.txt.gz")`

Replace the output file (below) your custom output file name and directory:
`write.table(out,"/mnt/scratch/examples/MN_ICD10_2021-09-23_phenoConstruct_v2.txt",sep="\t",quote=F,col.names=T,row.names=F)`

## Step 3
Replace the ICD code(s) with those that match your phenotype.  
For example,
Replace B27 with J45 if you are interested in asthma
`idx10 <- which(icd_long$ICD10=="B27")` # Exact match
`idx10category <- which(icd_long$ICD10category=="B27")` # Match Category

## Step 5
Run the script.   
`Rscript define_ICD_phenotype.R`
Wait 5-10 mins.   
Then collect your file from output file directory

[BACK-TO-HOME-PAGE](https://github.com/benbrumpton/how-to-ukbb)
