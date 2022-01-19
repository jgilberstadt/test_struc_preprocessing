#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/josh_vbm_warp_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/josh_vbm_warp_jobs/Sample_job.e%j
######## Email
#SBATCH --mail-user=gilberstadt.j@wustl.edu
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
######## Number of nodes: 1 #########SBATCH -N 1
######## Number of tasks: 1 ########
#SBATCH -n 1
######## Memory per node: 200 MB ########
#SBATCH --mem 5G
######## Walltime: 30 minutes ########
#SBATCH -t 1:00:00

module load fsl
#cd /home/gilberstadt.j/Upload_from_Local/fsltest
#for i in "$@";
#do

# assumption: 1 input argument -> fullpath to an image
fullpath=$1  # the full path to the image
dirpath=$(dirname ${fullpath}) # gives you the path to the directory where the image lives
fname=$(basename ${fullpath}) # gives you the name of the image file
fbase=$(echo ${fname} | rev | cut -f1 -d '.' | rev) # gives you the name of the image file without the postfix (i.e., .nii.gz)


       #bet $i brain-$i
       bet ${fullpath} ${dirpath}/BET/${fbase}_brain.nii.gz  #mkdir to create directories as needed

       # naming conventions for output ${dirpath}/${SubjID}/${Session}/${ProcessingStep=BET/FAST}

        #fast brain-$i
	fast ${dirpath}/BET/${fbase}_brain.nii.gz # it might be able to take additional arguments for where  to put output : ${dirpath}/FAST/${fbase}_brain


===============================================

        a=0
        for k in $(find * -name "*pve_*");
        do
                mv $k $a-image-$i
                ((a+=1))
        done
        flirt -in brain-$i -ref /home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain -omat brain-$i.mat -out flirt-brain-$i
        fnirt --ref=/home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain --in=flirt-brain-$i --aff=brain-$i.mat --iout=fnirt-brain-$i --fout=warp-brain-$i --jout=jac-brain-$i
	for j in $(find * -name "*image-$i");
        do
                applywarp --in=$j --ref=/home/gilberstadt.j/Upload_from_Local/MNI152_T1_2mm_brain --warp=warp-brain-$i --premat=brain-$i.mat --out=warp-$j
                fslmaths jac-brain-$i -mul warp-$j jac-warp-$j
                var=$(fslstats brain-$i -V | cut -f2 -d ' ')
                fslmaths jac-warp-$j -div $var jac-warp-vol-$j
        done
#done

