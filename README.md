# Fig-SSR: Diffuse and Regionally Structured Domestication of the Common Fig

This repository contains all the code used to reproduce analyses for the work:

> **Diffuse and regionally structured domestication of the common fig (*Ficus carica* L.) in the Mediterranean Basin**

## Repository layout
├─ env/        # Conda environment + R extras + external tool notes
└─ scripts/    # Analysis scripts, one folder per module
### Scripts structure
scripts/
├─ ADZE/                 # AR / AP diversity calculations
├─ eems/                 # Effective migration surfaces
├─ geocoding/            # Site geocoding utilities
├─ max_membership/       # STRUCTURE membership coefficient analyses
├─ pca/                  # PCA scripts and notebooks
├─ pophelper/            # STRUCTURE admixture plots
├─ STRUCTURE/            # Job submission and STRUCTURE runs
├─ structure_harvester/  # Evanno’s ΔK (Structure Harvester or R equivalents)
├─ tess3r/               # tess3r clustering analyses
└─ willcoxon_comparison/ # Wilcoxon tests for AR / AP

Each subfolder includes a `README.md` describing:
- Purpose
- Key files
- How to run
- Inputs / outputs

---

## Environment setup

Create and activate the conda environment:

```bash
mamba env create -f env/environment.yml
mamba activate fig-ssr

Then install extra R packages (from CRAN / GitHub):
Rscript env/R-packages.R
See env/README.md for full details, including external tools like STRUCTURE, SPAGeDI, and EEMS.

Usage
	1.	Set up the environment (env/).
	2.	Navigate to the relevant folder under scripts/.
	3.	Follow that folder’s README.md for how to run the script(s).

Outputs will be written to the locations defined inside each script’s instructions.
