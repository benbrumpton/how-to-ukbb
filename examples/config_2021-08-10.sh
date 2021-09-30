#!/bin/bash

# PATH with sample files
inpSmpPath=/mnt/archive/genotypes/samples/

# Current sample ids
curSmpFile=${inpSmpPath}gid_current_allchr_20210810_n486287.txt

# Phenotype files
PhenoDir=/mnt/archive/phenotypes/source/
phe1=${PhenoDir}ukb22892.tab # 2018-07-04
phe2=${PhenoDir}ukb28673.tab # 2019-04-02
phe3=${PhenoDir}ukb31008.tab # 2019-05-28
phe4=${PhenoDir}ukb40811.tab # 2020-02-24
phe5=${PhenoDir}ukb43682.tab # 2020-09-12
phe6=${PhenoDir}ukb44857.tab # 2020-12-16
#phe7=${PHenoDir}ukb45202.tab # 2021-02-04 #What's wrong with this file?
phe8=${PhenoDir}ukb45799.tab # Nikhil 2021-03-11
phe9=${PhenoDir}ukb48230.tab # Nikhil 2021-09-09

# missing:
# * 28461	29 Mar 2019
# * 23263	10 Aug 2018

## comma-separated list of data files in reverse chronological order
#inpFileList=${phe9},${phe8},${phe7},${phe6},${phe5},${phe4},${phe3},${phe2},${phe1}
inpFileList=${phe9},${phe8},${phe6},${phe5},${phe4},${phe3},${phe2},${phe1}


# Output path
outPath=/mnt/scratch/${user}/extractphe/
#outPath=/mnt/scratch/${user}/tmp/

# Output prefix
outPrefix=ukb_phenotype

# zip output
zipOutput=TRUE
