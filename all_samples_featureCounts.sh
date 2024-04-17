#!/bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=featureCounts
#SBATCH --time=01:00:00  # Adjust based on your expectation of job runtime
#SBATCH --mem=10G        # Adjust based on your expectation of memory need

# Path to your annotation file
annotation_file="${@: -1}"

# Create an array to hold the bam files
declare -a bam_files

# Loop over all other arguments, which should be BAM files
for bam_file in "${@:1:$#-1}"
do
    # Add the bam file to the array
    bam_files+=("$bam_file")
done

# Run featureCounts on all bam files at once
featureCounts -p --countReadPairs -a $annotation_file -o "featureCountsOutput.counts" "${bam_files[@]}"
