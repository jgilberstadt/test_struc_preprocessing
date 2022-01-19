#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/josh_vbm_bet_0_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/josh_vbm_bet_0_jobs/Sample_job.e%j
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

#suggestion 1: include "module list" so that you know how the environment looks like
#cd /home/gilberstadt.j/Upload_from_Local/fsltest # avoid hard coding

# suggestion 5: capture information regarding slurm arguments, node, queue, job id, etc.

# keep it simple: avoid loops when not necessary
fullpath=$1  # the full path to the image
dirpath=$(dirname ${fullpath}) # gives you the path to the directory where the image lives
fname=$(basename ${fullpath}) # gives you the name of the image file
fbase=$(echo ${fname} | rev | cut -f3- -d '.' | rev) # gives you the name of the image file without the postfix (i.e., .nii.gz)

echo "bet ${fullpath} ${dirpath}/BET/${fbase}_brain.nii.gz"
echo "bet starts"
if [ ! -d "${dirpath}/BET" ]
then
        mkdir ${dirpath}/BET
fi
bet ${fullpath} ${dirpath}/BET/${fbase}_brain.nii.gz
success=$(echo $?)
if (($success==0))
then
	echo "success"
fi
echo "bet ends"
	# suggestion 2: echo the command that you run. especially, when additional (i.e., not standard/default) parameters are used; maybe before command
	# echo "bet $i brain-$i"
	# suggestion 3: use echo to print in stdout useful information (e.g., bet starts, bet ends, information about number of iterations, etc.)
	# suggestion 4: capture exist status (i.e., check output flag if 0) $?

