scripts/ADZE/README.md
# ADZE

Purpose:  
Transform SSR genotype data into the specific input format required by **ADZE** (Allelic Diversity Analyzer).  
The transformation script converts each individual’s two alleles per locus into two separate rows, which ADZE needs to calculate allelic richness (AR) and private allelic richness (AP).

---

Key files:
- `adze_transform.py` — Python script that performs the transformation
- Example input: Excel file with genotype data (alleles in `_A1` and `_A2` columns)

---

How to run:
1. Activate the environment:
   ```bash
   mamba activate fig-ssr
   
2.	Run the transformation script:
python adze_transform.py --in raw_genotypes.xlsx --out adze_input.xlsx
	•	--in: path to your raw SSR Excel file
	•	--out: path for the transformed ADZE-compatible Excel file
Inputs/outputs:
  Input:
	•	Excel file with SSR genotype data
	•	Must contain allele columns named *_A1 and *_A2 plus base columns (sorted_sample_id, cluster)
  Output:
	•	Excel file formatted for ADZE (two rows per individual, one per allele copy)
	•	Ready to use in ADZE to compute AR and AP