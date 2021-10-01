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
Replace the ICD codes with those that match your phenotype.  
For example,
Replace B27 with 


Extract phenotypes. Phenotypes are any variable contained in a field.    
Fields can be found using the UKB data showcase:     
https://biobank.ndph.ox.ac.uk/ukb/search.cgi     

Once you have a list of fields you can extract them using the below command:    
username@hunt-ukbb-home:~/scratch/repo/ukb_extract/extract_phe$ `bash extract_phe.sh ~/projects/hla/hla_fields.txt`

where `hla_fields.txt` contains the list of fields:    
Field_ID     
22182    

Pleas note: ~/projects/hla/hla_fields.txt is just an example

## extract_snp
Most of the genotypes in biobank are found in the bulk downloads. The most common genotypes of interest are SNPs.    
Variants can be found using the UKB data showcase:     
https://biobank.ctsu.ox.ac.uk/crystal/gsearch.cgi
  
Once you have a list of variants you can extract them using the below command:     
username@hunt-ukbb-home:~/scratch/repo/ukb_extract/extract_snp$ `bash extract_snp.sh ch_rsid.txt dose`

where `ch_rsid.txt` contains the chromosome and rsid:     
2 rs142760803       
4 rs1917332       
13 rs74737349      

Please note: the outputformat can be `bgen`, `vcf` or `dose`.

[BACK-TO-HOME-PAGE](https://github.com/benbrumpton/how-to-ukbb)
