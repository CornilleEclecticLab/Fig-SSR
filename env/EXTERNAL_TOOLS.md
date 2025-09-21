# External tools (install separately)

The analyses use several binaries that are **not** shipped via this repo. Install them and ensure they’re on your `PATH`.

- **STRUCTURE v2.3.3**  
  Individual-based Bayesian clustering. GUI or CLI.  
  *Usage:* scripts under `scripts/STRUCTURE/` and `scripts/structure_harvester/`.

- **Structure Harvester**  
  Parses STRUCTURE outputs and computes Evanno’s ΔK. Some teams now do this in R, but the classic tool is still handy.

- **SPAGeDI v1.3**  
  Spatial genetic structure (SGS). Used for Sp statistic and kinship vs. distance.

- **EEMS (eems2)**  
  Effective migration surfaces. Use with `rUNEEMSplot` (installed via `env/R-packages.R`) to visualize *m* and *q*.

- **fastsimcoal2** (optional)  
  For ABC/demographic scenarios, if you’re reproducing those parts of the pipeline.

- **QGIS / GRASS / SAGA** (optional)  
  For cartography / IDW interpolation used in some figures.

> Tip: Keep a `TOOLBIN` directory and add it to your shell `PATH` in your `.bashrc` or `.zshrc`.