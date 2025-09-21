scripts/pca/README.md
# pca

Purpose:  
Perform Principal Component Analysis (PCA) on SSR genotype matrices, visualize genetic structure in 2D/3D plots, and optionally filter subsets of samples. Generates both unfiltered and filtered PCA plots and scree plots.

---

Key files:
- `pca.R` — R script for PCA computation, plotting, and filtered analyses
- `pca_analysis.Rmd` — R Markdown notebook version with plots and explanatory text
- Input files:
  - `pca_input.txt` — tab-delimited SSR genotype matrix
  - `samples_metadata.csv` — sample metadata with IDs, types, and colors

---

How to run:
1. Ensure your working directory contains `pca_input.txt` and `samples_metadata.csv`.
2. Activate the environment:
   ```bash
   mamba activate fig-ssr
3.	Run PCA in batch mode:
Rscript pca.R
4.	(Optional) Render the R Markdown notebook:
Rscript -e 'rmarkdown::render("pca_analysis.Rmd")'
Inputs/outputs:
	Input:
	•	pca_input.txt — SSR genotype matrix (diploid, two alleles per locus)
	•	samples_metadata.csv — metadata (sample_id, site_number, type, color)
	Output:
	•	PCA_Results_Unfiltered.pdf — 2D plots (PC1 vs PC2/3, PC2 vs PC3) and scree plot
	•	PCA_Results_No_ku_bs.pdf — PCA excluding ku_sp and bs_sp sites
	•	PCA_Results_No_ku.pdf — PCA excluding ku_sp
	•	PCA_Results_No_bs.pdf — PCA excluding bs_sp
	•	filtered_metadata_no_*.csv — metadata files after filtering