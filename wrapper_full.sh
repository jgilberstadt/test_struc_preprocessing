#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/wrapper_full_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/wrapper_full_jobs/Sample_job.e%j
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
total_jobs=$(bc <<< "8*$(wc -l $1 | cut --complement -f2 -d ' ')")
for fullpath in $(cat $1);
do
	jid1=$(sbatch --parsable /home/gilberstadt.j/josh_vbm_bet_0.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	jid2=$(sbatch --parsable --dependency=afterany:$jid1 /home/gilberstadt.j/josh_vbm_fast_1.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	jid3=$(sbatch --parsable --dependency=afterany:$jid2 /home/gilberstadt.j/josh_vbm_flirt_2.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	jid4=$(sbatch --parsable --dependency=afterany:$jid3 /home/gilberstadt.j/josh_vbm_fnirt_3.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	jid5=$(sbatch --parsable --dependency=afterany:$jid4 /home/gilberstadt.j/josh_vbm_applywarp_4.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	jid6=$(sbatch --parsable --dependency=afterany:$jid5 /home/gilberstadt.j/josh_vbm_jac_warp_5.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	jid7=$(sbatch --parsable --dependency=afterany:$jid6 /home/gilberstadt.j/josh_vbm_normalize_6.sh $fullpath)
	echo "Submitted job number $job_number of $total_jobs"
        ((job_number+=1))
	sbatch --dependency=afterany:$jid7 /home/gilberstadt.j/josh_vbm_smooth_7.sh $fullpath
	echo "Submitted job number $job_number of $total_jobs"
	((job_number+=1))
done
