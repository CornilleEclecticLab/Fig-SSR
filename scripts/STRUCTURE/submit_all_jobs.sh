#!/bin/bash

for K in {1..10}; do
    sbatch \
        --job-name=structure_K${K} \
        --output=logs/structure_K${K}_%A_%a.out \
        --error=logs/structure_K${K}_%A_%a.err \
        --export=ALL \
        scripts/submit_structure_array.sh $K
done


