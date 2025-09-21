scripts/willcoxon_comparison/README.md


Purpose:  
Automate paired Wilcoxon signed-rank analyses comparing allelic richness (AR) and private alleles (AP) across populations. Performs three sets of tests:  
1. Pairwise AP comparisons  
2. Pairwise AR comparisons  
3. AR vs. AP per population

---

Key files:
- `paired_willcoxon.R` — R script running the paired Wilcoxon tests  
- `my_fig_wilcoxon_AP.R` — R script generating AP-specific plots  
- `my_fig_wilcoxon_AR.R` — R script generating AR-specific plots  
- Input files:  
  - `Ap_wilcoxon_input.txt` — AP data (loci × populations)  
  - `Ar_wilcoxon_input.txt` — AR data (loci × populations)

---

How to run:
1. Place `Ap_wilcoxon_input.txt` and `Ar_wilcoxon_input.txt` in the same directory.  
2. Edit the `setwd(...)` line in the R scripts if needed.  
3. Activate the environment:
   ```bash
   mamba activate fig-ssr
4.	Run the paired Wilcoxon tests:
Rscript paired_willcoxon.R
5.	(Optional) Generate figures:
Rscript my_fig_wilcoxon_AP.R
Rscript my_fig_wilcoxon_AR.R
Inputs/outputs:
	Input:
	•	Ap_wilcoxon_input.txt — AP dataset (populations in columns, loci in rows)
	•	Ar_wilcoxon_input.txt — AR dataset (same structure as AP)
	Output:
	•	Console output or CSV tables of pairwise Wilcoxon results (Raw_P, FDR_P, Wilcoxon_V)
	•	Plots of AP and AR comparisons (PDF/PNG depending on script settings)
