#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/josh_vbm_normalize_6_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/josh_vbm_normalize_6_jobs/Sample_job.e%j
######## Email
#SBATCH --mail-user=gilberstadt.j@wustl.edu
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
######## Number of nodes: 1 ########
#SBATCH -N 1
######## Number of tasks: 1 ########
#SBATCH -n 1
######## Memory per node: 200 MB ########
#SBATCH --mem 5G
######## Walltime: 30 minutes ########
#SBATCH -t 02:00:00

module load fsl
module list

fullpath=$1  # the full path to the image
dirpath=$(dirname ${fullpath}) # gives you the path to the directory where the image lives
fname=$(basename ${fullpath}) # gives you the name of the image file
fbase=$(echo ${fname} | rev | cut -f3- -d '.' | rev) # gives you the name of the image file without the postfix (i.e., .nii.gz)

echo "matter_type=0
var=$(fslstats ${dirpath}/BET/${fbase}_brain.nii.gz -V | cut -f2 -d ' ')
for loops in $(seq 3);
do
        fslmaths ${dirpath}/JAC_WARP/${fbase}_brain_pve_${matter_type}_warp_jac.nii.gz -div $var ${dirpath}/NORMALIZE/${fbase}_brain_pve_${matter_type}_warp_jac_vol.nii.gz
        ((matter_type+=1))
done"
echo "normalize starts"
if [ ! -d "${dirpath}/NORMALIZE" ]
then
        mkdir ${dirpath}/NORMALIZE
fi
matter_type=0
var=$(fslstats ${dirpath}/BET/${fbase}_brain.nii.gz -V | cut -f2 -d ' ')
for loops in $(seq 3);
do
	fslmaths ${dirpath}/JAC_WARP/${fbase}_brain_pve_${matter_type}_warp_jac.nii.gz -div $var ${dirpath}/NORMALIZE/${fbase}_brain_pve_${matter_type}_warp_jac_vol.nii.gz
	((matter_type+=1))
done
success=$(echo $?)
if (($success==0))
then
        echo "success"
fi
echo "normalize ends"
