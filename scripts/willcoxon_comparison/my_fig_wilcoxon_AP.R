# Set the working directory and load the data
setwd("/Users/sanzhar/Desktop/Eco_Lab/analysis_v3/willcoxon")  
rac <- read.table("Ap_wilcoxon_input.txt", header = TRUE, sep = "\t", dec = ".")

# Exclude the first column (assumed to be locus labels) to obtain just the AP values
ap_data <- rac[, -1]

# Get the column names (populations)
pop_names <- colnames(ap_data)

# Initialize vectors to store the results of each comparison
comparisons  <- c()  # To store the description of each comparison
raw_pvals    <- c()  # To store the raw p-values
wilcoxon_Vs  <- c()  # To store the Wilcoxon test statistics

# Get the number of AP columns
n_cols <- ncol(ap_data)

# Nested loop: compare every unique pair of columns
for (i in 1:(n_cols - 1)) {
  for (j in (i + 1):n_cols) {
    # Construct a description for the current comparison
    comp_label <- paste(pop_names[i], "vs", pop_names[j])
    
    # Perform the paired Wilcoxon test
    res <- wilcox.test(ap_data[[i]], ap_data[[j]], paired = TRUE)
    
    # Save the results
    comparisons <- c(comparisons, comp_label)
    raw_pvals   <- c(raw_pvals, res$p.value)
    wilcoxon_Vs <- c(wilcoxon_Vs, res$statistic)
  }
}

# Apply Benjamini-Hochberg FDR correction for multiple testing
adj_pvals <- p.adjust(raw_pvals, method = "fdr")

# Create a summary data frame with the results
results_df <- data.frame(
  Comparison = comparisons,
  Raw_P      = raw_pvals,
  FDR_P      = adj_pvals,
  Wilcoxon_V = wilcoxon_Vs,
  stringsAsFactors = FALSE
)

# Print the summary
print(results_df)
