# Set the working directory and load the data
setwd("/Users/sanzhar/Desktop/Eco_Lab/analysis_v3/willcoxon")  
rac <- read.table("Ar_wilcoxon_input.txt", header = TRUE, sep = "\t", dec = ".")

# Exclude the first column if it is just a locus label
ar_data <- rac[ , -1]

# Get the names of the AR columns
col_names <- colnames(ar_data)

# Initialize vectors to store results
comparisons  <- c()
raw_pvals    <- c()
wilcoxon_Vs  <- c()

# Loop through all unique pairs (i < j)
n_cols <- ncol(ar_data)
for (i in 1:(n_cols - 1)) {
  for (j in (i + 1):n_cols) {
    # Get the current pair of column names
    col1 <- col_names[i]
    col2 <- col_names[j]
    
    # Perform the paired Wilcoxon test
    res <- wilcox.test(ar_data[[i]], ar_data[[j]], paired = TRUE)
    
    # Store the comparison description, raw p-value, and test statistic
    comparisons  <- c(comparisons, paste(col1, "vs", col2))
    raw_pvals    <- c(raw_pvals, res$p.value)
    wilcoxon_Vs  <- c(wilcoxon_Vs, res$statistic)
  }
}

# Adjust the p-values for multiple comparisons using the FDR method
adj_pvals <- p.adjust(raw_pvals, method = "fdr")

# Combine results into a data frame
results_df <- data.frame(
  Comparison = comparisons,
  Raw_P      = raw_pvals,
  FDR_P      = adj_pvals,
  Wilcoxon_V = wilcoxon_Vs,
  stringsAsFactors = FALSE
)

# Print the summary of results
print(results_df)
