#!/bin/bash

#arguments
file_dir=$1 #directory with summary stats files which have been tabix and bgzipped with ending *.tsv.bgz, string should not end with "/"
output=$2
index=$3 #must be .csv or .tsv

#make sure tabix is a global variable

#do this separately instead of generally for now
#if [ $index == *".csv" ]; then
 #   echo "Comma-separated index file provided"
 #   file=$(cat $index | awk  -v chr='$chr' pos='$pos' '{ print $2"\t"$3 }')
 #   echo $file > test#
#elif [ $index == *".tsv" ]; then
 #    echo "Tab separated index file provided"
#else
 #   echo "Index variant file must be .csv or .tsv"
  #  exit $ERRCODE
#fi

# Loop through the results and append all to text file

#remove file so we don't write into it again
rm $output

for file in `ls $file_dir/*tsv.bgz`
do
    echo $file
    echo $base
    base=`basename ${file} .tsv.bgz`
    tabix $file -R $index >> $output
done


#tabix phecode-426.31-both_sexes.tsv.bgz -R regions.txt >> UKBpheWAS.${prefix}.results.txt 

#done
