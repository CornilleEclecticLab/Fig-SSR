scripts/tess3r/README.md
# tess3r

Purpose:  
Run spatial ancestry inference using the **tess3r** package in R.  
This method estimates admixture coefficients while accounting for spatial information, helping visualize genetic structure across geography.

---

Key files:
- `tess3r.R` — R script to run tess3r across multiple K values, generate cross-validation plots, and map ancestry coefficients
- `tess3r.Rmd` — R Markdown notebook version with plots and explanations
- `tess3r.html` — rendered output from the notebook (example results)
- Input files:  
  - `genotypes.csv` — raw SSR genotype matrix  
  - `metadata.csv` — sample metadata with IDs and spatial coordinates

---

How to run:
1. Ensure `genotypes.csv` and `metadata.csv` are in the working directory.
2. Activate the environment:
   ```bash
   mamba activate fig-ssr
3.	Run tess3r in batch mode:
Rscript tess3r.R
4.	(Optional) Render the notebook:
Rscript -e 'rmarkdown::render("tess3r.Rmd")'
Inputs/outputs:
	Input:
	•	genotypes.csv — SSR genotypes
	•	metadata.csv — metadata including longitude and latitude
	Output:
	•	Cross-validation error plot for K = 1–9
	•	Barplot of ancestry proportions at best K (default K = 4)
	•	Interpolated spatial ancestry maps (PDF/PNG)
	•	Notebook output: tess3r.html