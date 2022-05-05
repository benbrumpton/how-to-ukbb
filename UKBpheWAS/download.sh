#!/bin/bash

#input .tsv version of PanUKB manifest
#assumes the first column is the trait type (biomarkers, continuous, categorical, icd10, phecode, prescriptions)
#assumes columns 77 and 78 (1-based counting) have the AWS link for donwloading the summary statistics and .tbi file, respectively
file=$1
trait_type=$2
output=$3 #needs to be an output file

#some of the columns in the manifest are empty so the tab delimited version will have different line numbers when processed. Let's turn the tabs into semi colons, and then use that to split each line into an array
#it seems the end of the line, which is the tabix index URL, has a character leftover from copy and paste on a non unix environment (%0D), so we need to use dos2unix 
dos2unix $file

#some of the columns in the manifest are empty so the tab delimited version will have differen line numbers when processed. Let's turn the tabs into semi colons with sed, and then use that to split each line into an array
sed 's/\t/;/g' $file > download.tmp
while IFS=";" read -r -a tmp ; do
    if [ "${tmp[0]}" == ${trait_type} ]; then #if it is the trait type we want
	if [ -e "${output}/${tmp[74]}" ]; then #see if summary stats file exists locally 
	    echo "${output}/${tmp[74]} exists."
	else 
	    echo "Downloading  ${tmp[76]}"
	    wget -O ${output}/${tmp[74]} "${tmp[76]}"
	fi

	if [ -e "${output}/${tmp[75]}" ]; then #see if the .tbi file exists locally
	    echo "${output}/${tmp[75]} exists."
	else 
	   echo "Downloading ${tmp[77]}" #.tbi
	   wget -O ${output}/${tmp[75]} "${tmp[77]}"
	fi
    fi
done < download.tmp
rm download.tmp #clean up by removing this file 


