# env

This folder defines the software environment and external tools needed to run the Fig-SSR analyses.

---

## 1. Create and activate the environment

The analyses combine **R** and **Python** tools. We manage them through a single conda/mamba environment.

```bash
mamba env create -f env/environment.yml
mamba activate fig-ssr
