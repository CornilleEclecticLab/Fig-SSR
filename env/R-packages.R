# Run with: Rscript env/R-packages.R

message("Installing extra R packages from GitHub/CRAN ...")

# Ensure remotes is present
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# rUNEEMSplot (EEMS plotting helpers)
try(remotes::install_github("dipetkov/rUNEEMSplot"), silent = TRUE)

# pophelper (R) — if needed (CRAN availability sometimes changes)
# If CRAN is unavailable, use the GitHub mirror:
# try(remotes::install_github("royfrancis/pophelper"), silent = TRUE)

# Helpful extras used in some notebooks
pkgs <- c(
  "sf",          # spatial data
  "sp",          # legacy spatial
  "ggnewscale",  # multiple scales in ggplot
  "gridExtra"
)

to_install <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(to_install)) {
  install.packages(to_install, repos = "https://cloud.r-project.org")
}

message("Done.")