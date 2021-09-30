#!/bin/bash

# Input file with fields to extract (one per line, with Field_ID as column name)
inputfile=$1

repos=/mnt/scratch/repo/ukb_extract/
srcdir=${repos}extract_phe/
source ${srcdir}sh/default.sh
source /mnt/scratch/examples/config_2021-08-10.sh
source ${srcdir}sh/src.sh

export R_LIBS_USER=/mnt/work/software/ukb_extr_R_package/3.6

if [ "$inputfile" == "" ] ; then exit ; fi
run
