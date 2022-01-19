#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/wrapper_fnirt_3_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/wrapper_fnirt_3_jobs/Sample_job.e%j
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

job_number=1
total_jobs=$(wc -l $1 | cut --complement -f2 -d ' ')
for fullpath in $(cat $1);
do
	sbatch /home/gilberstadt.j/josh_vbm_fnirt_3.sh $fullpath
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
done
