scripts/structure_harvester/README.md`


Purpose:  
Parse STRUCTURE outputs and compute Evanno’s ΔK statistic to determine the most likely number of clusters (K). Produces plots of ΔK versus K.

---

Key files:
- `deltaK.R` — R script for computing and plotting ΔK values
- `delta_k.Rmd` — R Markdown notebook version for ΔK analysis with visualization
- Input file: `EvannoTableOutput.txt` (produced by Structure Harvester or equivalent parser)

---

How to run:

1. Ensure `EvannoTableOutput.txt` is present in the working directory.
2. Activate the environment:
   ```bash
   mamba activate fig-ssr
3.	Run the R script:
Rscript deltaK.R
or render the notebook:
Rscript -e 'rmarkdown::render("delta_k.Rmd")'
Inputs/outputs:
	Input:
	•	EvannoTableOutput.txt — table with mean likelihoods, variance, and ΔK values for each K
	Output:
	•	Base R plot of ΔK vs. K
	•	ggplot2 plot of ΔK vs. K
	•	Saved figure: delta_k_plot.jpeg (high-resolution image)
	•	Optional HTML/PDF report if using the R Markdown notebook