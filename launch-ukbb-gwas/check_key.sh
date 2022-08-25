# This script sends a job to the remote node

# Update this section
user=benb
phenofile=infection-heart_ukb_v1_phenotypeConstructLT_2020-10-28.txt
phenokey=infection-heart_ukb_v1_phenotypeConstructLT_2020-10-28_key.txt
folder=/mnt/archive/phenotypes/constructs/phenoCons/example/

#### Do NOT change anything below ####

# time stamp
echo "Start time: $(date)" > time.log

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
