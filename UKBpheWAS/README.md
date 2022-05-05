# UKBpheWAS

Perform phenome-wide association study (PheWAS) in UK Biobank on the `hunt-ukbb` lab.

### Step 1. Download

`sh download.sh`

The best resource for comprehensive UK Biobank summary statistics as of May, 2022 is [Pan UKBB](https://pan-dev.ukbb.broadinstitute.org). You can view the manifest and sort for the traits you are intersted in. Information regarding downloads is [here](https://pan-dev.ukbb.broadinstitute.org/downloads). Be sure to cite `Pan-UKB team. https://pan.ukbb.broadinstitute.org. 2020.` In this example, I've donwloaded a .tsv file from the Google Sheet manifest with only the subset of traits I'm interested in. Note, these are in the human genome reference hg19/GRCh37.

Bash script takes arguments in this order
1) the name of the latest Pan UKBB manifest in a tab separated variable (.tsv) file.  (i.e. Pan-UK_Biobank_phecode_manifest.tsv)
2) Trait type (biomarkers, continuous, categorical, icd10, phecode, prescriptions) from 1st column of manifest file
3) Path to the output directory where you want the download made. 

* Script creates `wget` command for all the results that you want. Do understand this utility, `wget -help`

For example:
`wget -O /home/bwolford/scratch/panukb/continuous-100001-both_sexes-irnt.tsv.bgz https://pan-ukb-us-east-1.s3.amazonaws.com/sumstats_flat_files/continuous-100001-both_sexes-irnt.tsv.bgz`

* We want to use `nohup` so the downloads won't get interrupted

`nohup bash download.sh <file> <trait_type> <output/dir/> &`

For example:
`bash how-to-ukbb/UKBpheWAS/download.sh Pan-UKBiobank_phenotype_manifest.tsv continuous /home/bwolford/scratch/panukbb`

* If you wanted to do this one by one and download into the current working directory, the command would look something like

`wget https://pan-ukb-us-east-1.s3.amazonaws.com/sumstats_flat_files/phecode-008-both_sexes.tsv.bgz`

* You also need to download the tabix index file (.tbi) which helps us query the markers quickly 

`wget https://pan-ukb-us-east-1.s3.amazonaws.com/sumstats_flat_files_tabix/phecode-008-both_sexes.tsv.bgz.tbi`

### Step 2. Query

`sh query.sh` 

