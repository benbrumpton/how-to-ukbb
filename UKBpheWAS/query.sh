# Create the regions file to query
echo "1	11063" > regions.txt
prefix=1:11063

# Query the results
tabix phecode-426.31-both_sexes.tsv.bgz -R regions.txt

# Loop through the results and append all to text file

for files in i do

tabix phecode-426.31-both_sexes.tsv.bgz -R regions.txt >> UKBpheWAS.${prefix}.results.txt 

done
