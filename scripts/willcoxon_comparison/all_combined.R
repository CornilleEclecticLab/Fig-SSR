setwd("/Users/sanzhar/Desktop/Eco_Lab/analysis_v3/willcoxon")
ap <- read.table("Ap_wilcoxon_input.txt", header=TRUE, sep="\t", dec=".")
ar <- read.table("Ar_wilcoxon_input.txt", header=TRUE, sep="\t", dec=".")

ap_data <- ap[ , -1]
ar_data <- ar[ , -1]

if(!all(rownames(ar_data) == rownames(ap_data))) warning("Row names differ between AR and AP; check that rows match exactly!")
if(ncol(ar_data) != ncol(ap_data)) stop("AR and AP have different numbers of columns - cannot do a direct comparison.")

# pairwise comparisons within AP
comparisons_ap <- c(); raw_pvals_ap <- c(); wilcox_Vs_ap <- c()
n_ap <- ncol(ap_data)
for(i in 1:(n_ap-1)) {
  for(j in (i+1):n_ap) {
    res <- wilcox.test(ap_data[[i]], ap_data[[j]], paired=TRUE)
    comparisons_ap   <- c(comparisons_ap, paste(colnames(ap_data)[i], "vs", colnames(ap_data)[j]))
    raw_pvals_ap     <- c(raw_pvals_ap, res$p.value)
    wilcox_Vs_ap     <- c(wilcox_Vs_ap, res$statistic)
  }
}
adj_pvals_ap <- p.adjust(raw_pvals_ap, method="fdr")
ap_pairwise_results <- data.frame(Comparison=comparisons_ap, Raw_P=raw_pvals_ap, FDR_P=adj_pvals_ap, Wilcoxon_V=wilcox_Vs_ap, stringsAsFactors=FALSE)

# pairwise comparisons within AR
comparisons_ar <- c(); raw_pvals_ar <- c(); wilcox_Vs_ar <- c()
n_ar <- ncol(ar_data)
for(i in 1:(n_ar-1)) {
  for(j in (i+1):n_ar) {
    res <- wilcox.test(ar_data[[i]], ar_data[[j]], paired=TRUE)
    comparisons_ar   <- c(comparisons_ar, paste(colnames(ar_data)[i], "vs", colnames(ar_data)[j]))
    raw_pvals_ar     <- c(raw_pvals_ar, res$p.value)
    wilcox_Vs_ar     <- c(wilcox_Vs_ar, res$statistic)
  }
}
adj_pvals_ar <- p.adjust(raw_pvals_ar, method="fdr")
ar_pairwise_results <- data.frame(Comparison=comparisons_ar, Raw_P=raw_pvals_ar, FDR_P=adj_pvals_ar, Wilcoxon_V=wilcox_Vs_ar, stringsAsFactors=FALSE)

# paired comparisons AR vs AP per population
comparisons_vs <- c(); raw_pvals_vs <- c(); wilcox_Vs_vs <- c()
for(i in seq_len(ncol(ar_data))) {
  res <- wilcox.test(ar_data[[i]], ap_data[[i]], paired=TRUE)
  comparisons_vs   <- c(comparisons_vs, paste(colnames(ar_data)[i], "AR vs", colnames(ap_data)[i], "AP"))
  raw_pvals_vs     <- c(raw_pvals_vs, res$p.value)
  wilcox_Vs_vs     <- c(wilcox_Vs_vs, res$statistic)
}
adj_pvals_vs <- p.adjust(raw_pvals_vs, method="fdr")
ar_vs_ap_results <- data.frame(Comparison=comparisons_vs, Raw_P=raw_pvals_vs, FDR_P=adj_pvals_vs, Wilcoxon_V=wilcox_Vs_vs, stringsAsFactors=FALSE)

print(ap_pairwise_results)
print(ar_pairwise_results)
print(ar_vs_ap_results)
