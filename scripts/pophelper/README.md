scripts/pophelper/README.md

Purpose:  
Organize and visualize STRUCTURE/TESS admixture Q-files. Provides barplots, pie-chart maps, and an organized K=4 plot grouped by dominant cluster. Includes a Python utility to clean raw Q-files.

---

Key files:
- `pophelper.R` — R script that reads Q-files, merges metadata, and generates barplots/maps
- `ssr_pophelper_organized.Rmd` — R Markdown notebook version with plots and narrative
- `clean_all_qfiles.py` — Python script to clean Q-files before visualization

---

How to run:

**Step 1. Clean Q-files**  
1. Place `k2.q` … `k7.q` files in the folder.  
2. Run:
   ```bash
   mamba activate fig-ssr
   python clean_all_qfiles.py
This will create k2_cleaned.q … k7_cleaned.q.

Step 2. Generate plots
	1.	Ensure samples_metadata.csv is present.
	2.	Run in R:
	Rscript pophelper.R
	or render the R Markdown notebook:
	Rscript -e 'rmarkdown::render("ssr_pophelper_organized.Rmd")'
	
Inputs/outputs:
	Input:
	•	STRUCTURE/TESS Q-files (k2.q … k7.q)
	•	samples_metadata.csv — sample metadata (must match rows in Q-files)
	Output:
	•	k2_barplot.pdf … k7_barplot.pdf — faceted admixture barplots by site
	•	k2_pie_map_with_country_names.pdf … k7_pie_map_with_country_names.pdf — pie maps by cluster and country
	•	K4_barplot_by_max_cluster.pdf — organized K=4 barplot
	•	Cleaned Q-files: k2_cleaned.q … k7_cleaned.q