setwd("/Users/sanzhar/Desktop")

if (!dir.exists("eems")) {
  system("git clone https://github.com/dipetkov/eems.git")
}

if (!dir.exists("eems_input")) dir.create("eems_input")
if (!dir.exists("eems_results")) dir.create("eems_results")
if (!dir.exists("eems_plots")) dir.create("eems_plots")

input_dir <- file.path(getwd(), "eems_input")

if (file.exists("updated_polygon.outer.txt")) {
  success <- file.copy(
    "updated_polygon.outer.txt",
    file.path(input_dir, "eems_data.outer"),
    overwrite = TRUE
  )
  if (!success) stop("Failed to copy updated_polygon.outer.txt.")
} else {
  stop("updated_polygon.outer.txt not found on Desktop.")
}

metadata_raw <- read.csv("genalex_metadata_sp_only.csv", header = TRUE)
coords_processed <- data.frame(
  Lon = metadata_raw$longitude,
  Lat = metadata_raw$latitude
)
write.table(
  coords_processed,
  file = file.path(input_dir, "eems_data.coord"),
  sep = " ",
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE
)

geno_raw    <- read.csv("genalex_geno_sp_only.csv", header = TRUE, stringsAsFactors = FALSE)
geno_numeric<- as.matrix(geno_raw)
num_cols    <- ncol(geno_numeric)
if (num_cols %% 2 != 0) {
  stop(sprintf(
    "Odd number of columns (%d); expected an even number.",
    num_cols
  ))
}
nSites <- num_cols / 2
write.table(
  geno_numeric,
  file = file.path(input_dir, "eems_data.sites"),
  sep = " ",
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE
)

metadata_processed <- read.table(
  file.path(input_dir, "eems_data.coord"),
  header = FALSE
)
nIndiv     <- as.integer(nrow(metadata_processed))
results_run<- file.path(getwd(), "eems_results", "run1")
if (!dir.exists(results_run)) dir.create(results_run, recursive = TRUE)

config_text <- sprintf(
  "datapath = %s/eems_data
mcmcpath = %s
nIndiv = %d
nSites = %d
nDemes = 200
diploid = true
numMCMCIter = 2000000
numBurnIter = 1000000
numThinIter = 9999",
  input_dir, results_run, nIndiv, nSites
)
config_file <- file.path(input_dir, "params.ini")
writeLines(config_text, con = config_file)

setwd(file.path(getwd(), "eems", "runeems_sats", "src"))
system("make darwin")
if (!file.exists("runeems_sats")) {
  stop("Compilation failed: executable not found.")
}

eems_exec <- file.path(getwd(), "runeems_sats")
cmd       <- sprintf('"%s" --params "%s" --seed 123', eems_exec, config_file)
system(cmd)

setwd("/Users/sanzhar/Desktop")
mcmcpath <- results_run
plotpath <- file.path(getwd(), "eems_plots", "run1")
if (!dir.exists(plotpath)) dir.create(plotpath, recursive = TRUE)

if (!"rEEMSplots" %in% installed.packages()[, "Package"]) {
  install.packages("rEEMSplots", repos = NULL, type = "source")
}
library(rEEMSplots)
eems.plots(mcmcpath, plotpath, longlat = TRUE)