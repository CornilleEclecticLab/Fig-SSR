scripts/max_membership/README.md

Purpose:  
Assign individuals to clusters based on maximum STRUCTURE membership coefficients, and identify admixed individuals below a threshold. Produces both a CSV assignment table and a histogram of max membership values.

---

Key files:
- `max_membership_coef.R` — R script for computing max membership and assignments
- `max_membership_coef.Rmd` — R Markdown notebook version with plots and narrative

---

How to run:
1. Place input files (`samples_metadata.csv` and `k4.q`) in the working directory.
2. Activate the environment:
   ```bash
   mamba activate fig-ssr
3.	Run the R script:
Rscript max_membership_coef.R
4.	(Optional) Render the R Markdown notebook for a full report:
Rscript -e 'rmarkdown::render("max_membership_coef.Rmd")'
	Input:
	•	samples_metadata.csv — sample metadata with at least sample_id
	•	k4.q — STRUCTURE/TESS output Q-matrix for K=4 (no header)
	Output:
	•	K4_assignments.csv — assignments of each individual to a cluster or “grey” (admixed)
	•	Histogram plot of max membership values (bars colored by cluster/admixed)