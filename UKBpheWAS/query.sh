#!/bin/bash

#arguments
config_file=$1
index=$2 #must be .csv or .tsv
output=$3 #string for output file name
chrom=$4 #0-based column with chromosome number
pos=$5 #0-based column with 1 based position0

#Note: make sure tabix is a global variable
out_file=$output".bed"
out_file_sorted=$output".sorted.bed"

#handle .csv or .tsv file with top GWAS hits for query
if [ $index == *".csv" ]; then
    echo "Comma-separated index file provided"
    n=0
    while IFS=$"," read -r -a myArray; do
	pos1=${myArray[$pos]}
	pos2="$((pos1-1))"
	((n >= 1)) && echo -e "${myArray[$chrom]}\\t${pos2}\\t${myArray[$pos]}" >> $out_file
	((n++))
    done < ${index}
elif [ $index == *".tsv" ]; then
    echo "Tab separated index file provided"
      while IFS=$"\t" read -r -a myArray; do
	echo -e "${myArray[$chrom]}\\t${myArray[$pos]}" >> $out_file
    done < ${index}
else
    echo "Index variant file must be .csv or .tsv"
    exit $ERRCODE
fi

#sort bed file
sort -k1,1n -k2,2n ${out_file} > $out_file_sorted

#remove file so we don't write into it again
rm $output

#loop over all the files in the config file and append query results to an output file, label with the input file name
while IFS= read -r line; do
    base=`basename ${line} .tsv.bgz`
    #tabix $line -R $out_file_sorted >> $base
    tabix $line -R $out_file_sorted | awk -v base=$base '{print $0"\t"base}'>> $output
done < ${config_file}


#### to do: print out each file to the $base and then jsut select the european p-value 
#clean up 
rm $out_file
rm $out_file_sorted

exit 0
