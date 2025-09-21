#!/bin/bash
#SBATCH --job-name=structure
#SBATCH --output=logs/structure_%A_%a.out
#SBATCH --error=logs/structure_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=48:00:00
#SBATCH --mem=1G
#SBATCH --array=1-10

module load all
module load gencore/2
module load structure/2.3.4

# Create logs directory if it doesn't exist
mkdir -p logs

# Get the value of K passed from the submission command
K=$1

# Replicate number from the array task ID
i=${SLURM_ARRAY_TASK_ID}

# Optional: Sleep to stagger job starts and reduce I/O load
sleep $i

# Run STRUCTURE
structure -m mainparams -e extraparams -K $K -i data/structure_input.txt -o results/output_K${K}_rep${i}

