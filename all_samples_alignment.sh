#!/bin/bash

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=allSamplesAlignment
#SBATCH --time=04:00:00  # Adjust based on your expectation of job runtime
#SBATCH --mem=50G        # Adjust based on your expectation of memory need

# Load the STAR module, if necessary. This command might change based on your system's module environment.
# module load STAR


# Define the directory containing the genome index
GENOME_DIR="star_index_output"

# Define the directory to store the alignment output
ALIGNMENT_DIR="star_alignment_output"

# Create an array with all input FASTQ files
FASTQ_FILES=("$@")

# Loop over all pairs of FASTQ files
for ((i=0; i<${#FASTQ_FILES[@]}; i+=2))
do
    # Define paths to the FASTQ files
    FASTQ1=${FASTQ_FILES[$i]}
    FASTQ2=${FASTQ_FILES[$i+1]}

    # Define the output prefix for this pair of FASTQ files
    OUTPUT_PREFIX="${ALIGNMENT_DIR}/$(basename ${FASTQ1} .fastq.gz)_$(basename ${FASTQ2} .fastq.gz)"

    # Run STAR for alignment
    STAR --genomeDir ${GENOME_DIR} \
         --readFilesIn ${FASTQ1} ${FASTQ2} \
         --runThreadN ${SLURM_CPUS_PER_TASK} \
         --outSAMtype BAM SortedByCoordinate \
         --outFileNamePrefix ${OUTPUT_PREFIX} \
         --readFilesCommand zcat  # Use this if your FASTQ files are gzipped
done