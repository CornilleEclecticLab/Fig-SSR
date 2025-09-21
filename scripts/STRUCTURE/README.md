scripts/STRUCTURE/README.md
# STRUCTURE

Purpose:  
Automate and manage STRUCTURE analyses on a SLURM cluster. Provides job submission scripts for running STRUCTURE across multiple values of K and replicates.

---

Key files:
- `submit_all_jobs.sh` — Master SLURM script that loops over K values and submits job arrays
- `submit_structure_array.sh` — SLURM job array script that runs STRUCTURE for a single K with multiple replicates
- Expected parameter files: `mainparams`, `extraparams`
- Input genotype data: `data/structure_input.txt`

---

How to run:

1. Ensure you have a working SLURM environment with STRUCTURE installed (v2.3.3 or v2.3.4).
2. Place genotype data (`data/structure_input.txt`) and parameter files (`mainparams`, `extraparams`) in the appropriate folder.
3. Create a `logs/` folder alongside the submission scripts.
4. Submit the jobs:
   ```bash
   bash submit_all_jobs.sh
The script will loop over K values (default: 1–10) and submit job arrays. Each job array runs multiple replicates of STRUCTURE for a given K.
Inputs/outputs:
	Input:
	•	data/structure_input.txt — genotype data
	•	mainparams, extraparams — STRUCTURE parameter files
	Output:
	•	STRUCTURE result files in results/ (e.g., output_K<k>_rep<i>)
	•	Log files in logs/ (structure_K<k>_<jobID>_<arrayIndex>.out/.err)

⸻

Customization:
	•	Edit the K range in submit_all_jobs.sh (default: {1..10}).
	•	Adjust SLURM directives in submit_structure_array.sh:
	•	--time, --mem, --cpus-per-task, --array (number of replicates).
	•	Modify file paths (data/structure_input.txt, results/) if your directory structure differs.