#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/josh_vbm_fnirt_3_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/josh_vbm_fnirt_3_jobs/Sample_job.e%j
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

echo "fnirt --ref=/home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain.nii.gz --in=${dirpath}/FLIRT/${fbase}_brain_flirt.nii.gz --aff=${dirpath}/FLIRT/${fbase}_brain.mat --iout ${dirpath}/FNIRT/${fbase}_brain_fnirt.nii.gz --fout=${dirpath}/FNIRT/${fbase}_brain_warp.nii.gz --jout=${dirpath}/FNIRT/${fbase}_brain_jac.nii.gz"
echo "fnirt starts"
if [ ! -d "${dirpath}/FNIRT" ]
then
        mkdir ${dirpath}/FNIRT
fi
fnirt --ref=/home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain.nii.gz --in=${dirpath}/FLIRT/${fbase}_brain_flirt.nii.gz --aff=${dirpath}/FLIRT/${fbase}_brain.mat --iout=${dirpath}/FNIRT/${fbase}_brain_fnirt.nii.gz --fout=${dirpath}/FNIRT/${fbase}_brain_warp.nii.gz --jout=${dirpath}/FNIRT/${fbase}_brain_jac.nii.gz
success=$(echo $?)
if (($success==0))
then
        echo "success"
fi
echo "fnirt ends"
