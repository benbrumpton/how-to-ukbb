#!/bin/bash

# print user
ps ua > ps.txt
echo 'NO_ONE ssh ubuntu@hunt-ukbb-iaas-theem bash' >> ps.txt

user=`cat ps.txt | grep 'ssh ubuntu@hunt-ukbb-iaas-theem bash' | head -n1 | cut -d ' ' -f1`

echo 'Currently '${user}' is running a GWAS'

echo 'Details can be found below'

echo 'Please check %CPU and %MEM are 0'

# print time log
cat time.log

# print details from remote

tmp_dir=$(mktemp -d)
tmpfile=${tmp_dir}/psaux.txt

ssh ubuntu@hunt-ukbb-iaas-theem 'ps aux' > ${tmpfile}

(
  printf "%-8s\t%%CPU\t%%MEM\n" USER
  for u in `tail -n +2 ${tmpfile} | cut -d ' ' -f1 | sort -u` ; do
    res=`cat ${tmpfile} |grep "^${u} " | sed "s/  */ /g" | awk 'BEGIN{cpu=0 ; mem=0} {cpu+=$3; mem+=$4} END{print cpu/100"\t"mem}'`
    printf "%-8s\t${res}\n" $u
  done |grep -v -P "\t0\t0$" | sort -g -k2

  res=`tail -n +2 ${tmpfile} | sed "s/  */ /g" | awk 'BEGIN{cpu=0 ; mem=0} {cpu+=$3; mem+=$4} END{print cpu/100"\t"mem}' `
  printf "%-8s\t${res}\n" total
)

rm ${tmpfile}
rmdir ${tmp_dir}

# 
echo 'If %CPU and %MEM are not 0 please check who is doing what on Slack'

# print ETAs

echo 'ETAs for 24 cpu:
binary step1: 20.6 [8.5-32.3] hours
binary step2: 45.9 [13.4-66.4] hours
qt step1: 133.6 [120.4-143.5] hours
qt step2: 24 [23.4-24.7] hours'

echo ' avg [min-max] cpu hours
binary step1: 495 [204-776] cpu hours
binary step2: 1102 [320-1594] cpu hours
qt step1: 3207 [2889-3444] cpu hours
qt step2: 1102 [320-1594] cpu hours'

echo 'Updated runtimes
TYPE    N/1K    STEP1_THREADS   STEP1_TIME      CHUNKS  STEP2_AVGTIME   STEP2_MAXTIME
binary  318.4[8.9-407.9]        24      20.6[8.4-32.3]  24      46.0[13.4-66.4] 49.2[16.6-69.8]
quantitative    377.6[356.0-388.6]      24      133.6[120.4-143.5]      24      23.9[23.4-24.7] 24.6[24.2-25.2]'
