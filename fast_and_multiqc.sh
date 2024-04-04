#!/bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=fastAndMultiQC
#SBATCH --time=01:00:00  # Adjust based on your expectation of job runtime
#SBATCH --mem=10G        # Adjust based on your expectation of memory need

# Load the FastQC and MultiQC modules
mamba activate angsd

# Define the directory to store the FastQC and MultiQC output
OUTPUT_DIR="qc_output"

# Define the file containing the custom adapter sequences
ADAPTERS_FILE="custom_adapters.txt"

# Create the output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

# Loop over all FASTQ files provided as arguments
for FASTQ_FILE in "$@"
do
    # Run FastQC on the current FASTQ file
    fastqc ${FASTQ_FILE} --outdir ${OUTPUT_DIR} --contaminants ${ADAPTERS_FILE}

    # Copy the FastQC report to the output directory
    cp ${FASTQ_FILE}_fastqc.zip ${OUTPUT_DIR}
    cp ${FASTQ_FILE}_fastqc.html ${OUTPUT_DIR}
done

mamba activate multiqc
# Run MultiQC on the FastQC reports in the output directory
multiqc ${OUTPUT_DIR} --outdir ${OUTPUT_DIR}