#!/bin/bash
######## Job Name: Sample_Job ########
#SBATCH -J Sample_Job
######## Job Output File: Sample_job.oJOBID ########
#SBATCH -o /home/gilberstadt.j/Upload_from_Local/MRQy_jobs/Sample_job.o%j
######## Job Error File: Sample_job.eJOBID ########
#SBATCH -e /home/gilberstadt.j/Upload_from_Local/MRQy_jobs/Sample_job.e%j
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
#SBATCH -t 24:00:00

module load python
source activate test_MRQy
module list

fullpath_to_images=$1  # the full path to the directory containing the input images
outputdir=$2  # the full path to the directory containing the output of MRQy

for T1_image in $(find ${fullpath_to_images}/*/ -name "*T1w.nii.gz");
do
	echo $(realpath ${T1_image}) >> fullpaths.csv
done
python /scratch/gilberstadt.j/MRQy/src/mrqy/QC.py output_images fullpaths.csv $outputdir
