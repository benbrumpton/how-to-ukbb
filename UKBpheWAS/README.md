# UKBpheWAS

Perform phenome-wide association study (PheWAS) in UK Biobank on the `hunt-ukbb` lab.

### Step 1. Download

`sh download.sh`

The best resource for comprehensive UK Biobank summary statistics as of May, 2022 is [Pan UKBB](https://pan-dev.ukbb.broadinstitute.org). You can view the manifest and sort for the traits you are intersted in. Information regarding downloads is [here](https://pan-dev.ukbb.broadinstitute.org/downloads). Be sure to cite `Pan-UKB team. https://pan.ukbb.broadinstitute.org. 2020.` In this example, I've donwloaded a .tsv file from the Google Sheet manifest with only the subset of traits I'm interested in. 

### Step 2. Query

`sh query.sh` 

