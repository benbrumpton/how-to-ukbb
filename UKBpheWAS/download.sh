#!/bin/bash

#input .tsv version of PanUKB manifest
#assumes the first column is the trait type (biomarkers, continuous, categorical, icd10, phecode, prescriptions)
#assumes columns 77 and 78 (1-based counting) have the AWS link for donwloading the summary statistics and .tbi file, respectively
file=$1
trait_type=$2
output=$3

#some of the columns in the manifest are empty so the tab delimited version will have different line numbers when processed. Let's turn the tabs into semi colons, and then use that to split each line into an array
sed 's/\t/;/g' $file > download.tmp
while IFS=";" read -r -a tmp ; do
    if [ "${tmp[0]}" == ${trait_type} ]; then
	echo "${tmp[76]}" #actual summary stats file
	wget "${tmp[76]}"
	echo "${tmp[77]}" #.tbi
	wget "${tmp[76]}"
    fi
done < download.tmp
rm download.tmp #clean up by removing this file 


