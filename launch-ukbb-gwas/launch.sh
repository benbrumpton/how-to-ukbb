# This script sends a job to the remote node

# Update this section
user=benb
phenofile=infection-heart_ukb_v1_phenotypeConstructLT_2020-10-28.txt
phenokey=infection-heart_ukb_v1_phenotypeConstructLT_2020-10-28_key.txt
folder=/mnt/archive/phenotypes/constructs/phenoCons/example/
tool=bolt
#tool=saige

#### Do not change anything below ####

# time stamp
echo "Start time: $(date)" > time.log

# Maintenance
v=current

#Waring 1
WARNING1=yes

if [ "$WARNING1" == "yes" ] ; then
 read -r -p "Have you checked that no one else is running a job? Continue? [Y/n] " input

 case $input in
   [yY][eE][sS]|[yY])
     echo "Continue"
     ;;
   [nN][oO]|[nN])
     exit 1
     ;;
   *)
     echo "Invalid input..."
     exit 1
     ;;
 esac
fi

#Warning 2

# List of traits in the phenotype file
phenokey0=${folder}/${phenokey}
awk 'FNR > 1 {print $1}' ${phenokey0} | sort | uniq -c

WARNING2=yes

if [ "$WARNING2" == "yes" ] ; then
 read -r -p "Are these the jobs you want to run? Any previous results will be overwritten. Continue? [Y/n] " input

 case $input in
   [yY][eE][sS]|[yY])
     echo "Continue"
     ;;
   [nN][oO]|[nN])
     exit 1
     ;;
   *)
     echo "Invalid input..."
     exit 1
     ;;
 esac
fi

# Copy pheno files
rsync -avP ${folder}/${phenokey} ubuntu@hunt-ukbb-iaas-theem:/home/ubuntu/mnt-ukbb/pheno/
rsync -avP ${folder}/${phenofile} ubuntu@hunt-ukbb-iaas-theem:/home/ubuntu/mnt-ukbb/pheno/

# Send job
ssh ubuntu@hunt-ukbb-iaas-theem 'bash /home/ubuntu/mnt-ukbb/scripts/run.sh '${phenofile}' '${phenokey}' '${tool}' '${v}''

wait

# Move results
outdir=/mnt/scratch/output/${user}
mkdir -p ${outdir}

rsync -avP --remove-source-files ubuntu@hunt-ukbb-iaas-theem:/home/ubuntu/mnt-ukbb/output/* ${outdir}

# Done - no checks
echo 'Completed'

echo "Your output can be found here '${outdir}'"
