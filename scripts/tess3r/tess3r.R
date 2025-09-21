# tess3r_analysis.R

setwd("/Users/sanzhar/Desktop")

library(tess3r)

geno_df  <- read.csv("genalex_geno_sp_only.csv",  header=TRUE, row.names=1, stringsAsFactors=FALSE)
meta_df  <- read.csv("genalex_metadata_sp_only.csv", header=TRUE, row.names=1, stringsAsFactors=FALSE)
coords   <- as.matrix(meta_df[, c("longitude", "latitude")])

geno_mat <- as.matrix(geno_df)
mode(geno_mat) <- "numeric"
colnames(geno_mat)[colnames(geno_mat) == "LMFC.26"] <- "LMFC26"

clean_names <- gsub("\\.\\d+$", "", colnames(geno_mat))
loci        <- unique(clean_names)
newgeno_list <- list()

for (locus in loci) {
  idx        <- which(clean_names == locus)
  locus_data <- as.matrix(geno_mat[, idx])
  allele_vals <- sort(unique(as.vector(locus_data)))
  allele_vals <- allele_vals[allele_vals != 0 & !is.na(allele_vals)]
  for (allele in allele_vals) {
    newgeno_list[[paste(locus, allele, sep="_")]] <- rowSums(locus_data == allele, na.rm=TRUE)
  }
}

newgeno_df  <- as.data.frame(newgeno_list)
newgeno_mat <- as.matrix(newgeno_df)

tess3.obj <- tess3(
  X               = newgeno_mat,
  coord           = coords,
  K               = 1:9,
  ploidy          = 2,
  method          = "projected.ls",
  openMP.core.num = 4
)

plot(tess3.obj, pch=19, col="blue",
     xlab="Number of ancestral populations (K)",
     ylab="Cross-validation error")

bestK    <- 4
q.matrix <- qmatrix(tess3.obj, K=bestK)
barplot(q.matrix, border=NA, space=0,
        xlab="Individuals", ylab="Ancestry proportions",
        main=paste("Ancestry matrix (K =", bestK, ")"))

library(rworldmap)
plot(q.matrix, coords,
     method     = "map.max",
     interpol   = FieldsKrigModel(10),
     main       = paste("Spatial Ancestry Coefficients (K =", bestK, ")"),
     resolution = c(300,300),
     cex        = 0.4)