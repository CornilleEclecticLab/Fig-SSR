setwd("/Users/sanzhar/Desktop/willcoxon")

ar <- read.table("Ar_wilcoxon_input.txt", 
                 header = TRUE, sep = "\t", dec = ".")

ap <- read.table("Ap_wilcoxon_input.txt", 
                 header = TRUE, sep = "\t", dec = ".")

ar_data <- ar[, -1]
ap_data <- ap[, -1]

if(!all(rownames(ar_data) == rownames(ap_data))){
  warning("Row names differ between AR and AP; check that rows match exactly!")
}

# check they have the same number of columns
if(ncol(ar_data) != ncol(ap_data)){
  stop("AR and AP have different numbers of columns - cannot do a direct comparison.")
}

comparisons  <- c()
raw_pvals    <- c()
wilcoxon_Vs  <- c()

ar_col_names <- colnames(ar_data)
ap_col_names <- colnames(ap_data) 

for (i in seq_along(ar_col_names)) {
  
  # Paired Wilcoxon test: AR vs AP for column i
  res <- wilcox.test(ar_data[[i]], ap_data[[i]], paired = TRUE)
  
  # Comparison label
  comp_label <- paste(ar_col_names[i], "AR vs", ap_col_names[i], "AP")
  
  # Store
  comparisons  <- c(comparisons, comp_label)
  raw_pvals    <- c(raw_pvals, res$p.value)
  wilcoxon_Vs  <- c(wilcoxon_Vs, res$statistic)
}

# 7) Adjust p-values for multiple testing using FDR (Benjamini-Hochberg)
adj_pvals <- p.adjust(raw_pvals, method = "fdr")

# 8) Create a data frame of results
results_df <- data.frame(
  Comparison = comparisons,
  Raw_P      = raw_pvals,
  FDR_P      = adj_pvals,
  Wilcoxon_V = wilcoxon_Vs,
  stringsAsFactors = FALSE
)

# 9) Print or write to a file
print(results_df)

write.csv(results_df, "AR_vs_AP_results.csv", row.names=FALSE)
