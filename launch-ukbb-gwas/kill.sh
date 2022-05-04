# Kill all bg jobs on host

ssh ubuntu@hunt-ukbb-iaas-theem 'kill $(jobs -p)'
