#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/josh_vbm_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/josh_vbm_jobs/Sample_job.e%j
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
#SBATCH -t 1:00:00

module load fsl
cd /home/gilberstadt.j/Upload_from_Local/fsltest
for i in "$@";
do	
bet $i brain-$i
        fast brain-$i
        flirt -in brain-$i -ref /home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain -omat brain-$i.mat -out flirt-brain-$i
        fnirt --ref=/home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain --in=flirt-brain-$i --aff=brain-$i.mat --iout=fnirt-brain-$i
done
