# UKBpheWAS

Perform phenome-wide association study (PheWAS) in UK Biobank on the `hunt-ukbb` lab.

### Step 1. Download

`sh download.sh`

The best resource for comprehensive UK Biobank summary statistics as of May, 2022 is [Pan UKBB](https://pan-dev.ukbb.broadinstitute.org). You can view the manifest and sort for the traits you are intersted in. Information regarding downloads is [here](https://pan-dev.ukbb.broadinstitute.org/downloads). Be sure to cite `Pan-UKB team. https://pan.ukbb.broadinstitute.org. 2020.` In this example, I've donwloaded a .tsv file from the Google Sheet manifest with only the subset of traits I'm interested in. Note, these are in the human genome reference hg19/GRCh37.

Script takes arguments in this order
1) the name of the latest Pan UKBB manifest in a tab separated variable (.tsv) file.  (i.e. Pan-UK_Biobank_phecode_manifest.tsv)
2) Trait type (biomarkers, continuous, categorical, icd10, phecode, prescriptions) from 1st column of manifest file
3) directory where you want to download the files to

* Script Creates `wget` command for all the results that you want

* We want to use `nohup` so the downloads won't get interrupted

`nohup sh download.sh <file> <trait_type> <output/dir>`
`sh how-to-ukbb/UKBpheWAS/download.sh Pan-UKBiobank_phenotype_manifest.tsv continuous /home/bwolford/scratch`

* If you wanted to do this one by one, the command would look like

`wget https://pan-ukb-us-east-1.s3.amazonaws.com/sumstats_flat_files/phecode-008-both_sexes.tsv.bgz`

* You also need to download the tabix index file (.tbi) which helps us query the markers quickly 

`wget https://pan-ukb-us-east-1.s3.amazonaws.com/sumstats_flat_files_tabix/phecode-008-both_sexes.tsv.bgz.tbi`

* If you'd rather use an awk one-liner to make commands
 ` less Pan-UKBiobank_phenotype_manifest.tsv | awk -F '\t' -v mypath="/home/bwolford/scratch" trait="continuous" '$1 == trait {print "wget -O mypath",$77,"\nwget -O mypath",$78}'`
 
### Step 2. Query

`sh query.sh` 

