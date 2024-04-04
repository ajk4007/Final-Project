#!/bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=QoRTsQC
#SBATCH --time=04:00:00  # Adjust based on your expectation of job runtime
#SBATCH --mem=70G        # Adjust based on your expectation of memory need

mamba activate qorts

# Get the GTF file from the arguments
gtf_file="${@: -1}"

# Loop over all other arguments, which should be BAM files
for bam_file in "${@:1:$#-1}"
do
    # Extract the sample name from the BAM file name
    sample_name=$(basename "$bam_file" .bam)

    # Create a directory for the output
    mkdir -p "${sample_name}_qorts_output"

    # Run qorts with fewer options
    qorts -Xmx48G QC \ --generatePlots --title "$sample_name" \
    --addFunctions writeGeneCounts \
    "$bam_file" "$gtf_file" "${sample_name}_qorts_output"
done