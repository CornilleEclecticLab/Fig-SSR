library(adegenet)
library(pegas)
library(scatterplot3d)
library(ggplot2)
library(dplyr)
library(plotly)
library(factoextra)

setwd("/Users/sanzhar/Desktop/pca_0_9")

geno_data <- read.table("pca_input.txt", header=TRUE, sep="\t", blank.lines.skip=TRUE, stringsAsFactors=FALSE)
metadata  <- read.csv("samples_metadata.csv", header=TRUE, stringsAsFactors=FALSE)

geno_data_full       <- geno_data
metadata_full        <- metadata
geno_cleaned_full   <- geno_data_full[, -(1:2)]
geno_cleaned_full[geno_cleaned_full == -9] <- NA
obj_full             <- df2genind(geno_cleaned_full, ploidy=2, sep="\t", ncode=3)
pop(obj_full)        <- metadata_full$type
colors_full          <- metadata_full$color
pch_cluster_full     <- ifelse(metadata_full$type == "sp", 19, 17)

geno_imputed_full    <- scaleGen(obj_full, NA.method="mean")
pca_full             <- dudi.pca(geno_imputed_full, scannf=FALSE, scale=TRUE, nf=3)
variance_full        <- 100*(pca_full$eig/sum(pca_full$eig))
AXE1_full            <- round(variance_full[1],2)
AXE2_full            <- round(variance_full[2],2)
AXE3_full            <- round(variance_full[3],2)

cat("Unfiltered PCA:\n")
cat(paste("PC1:", AXE1_full, "%\n"))
cat(paste("PC2:", AXE2_full, "%\n"))
cat(paste("PC3:", AXE3_full, "%\n"))

pca_data_full <- data.frame(
  PC1   = pca_full$li[,1],
  PC2   = pca_full$li[,2],
  PC3   = pca_full$li[,3],
  color = colors_full,
  type  = metadata_full$type
)

plot_ly(pca_data_full, x=~PC1, y=~PC2, z=~PC3, type="scatter3d", mode="markers",
        color=~color, symbol=~type, marker=list(size=5)) %>%
  layout(
    title="3D PCA Plot (Unfiltered)",
    scene=list(
      xaxis=list(title=paste("PC1:",AXE1_full,"%")),
      yaxis=list(title=paste("PC2:",AXE2_full,"%")),
      zaxis=list(title=paste("PC3:",AXE3_full,"%"))
    )
  )

plot(pca_full$li[,1], pca_full$li[,2],
     col=colors_full, pch=pch_cluster_full,
     xlab=paste("PC1:",AXE1_full,"%"),
     ylab=paste("PC2:",AXE2_full,"%"),
     main="PCA: PC1 vs PC2 (Unfiltered)")

plot(pca_full$li[,1], pca_full$li[,3],
     col=colors_full, pch=pch_cluster_full,
     xlab=paste("PC1:",AXE1_full,"%"),
     ylab=paste("PC3:",AXE3_full,"%"),
     main="PCA: PC1 vs PC3 (Unfiltered)")

plot(pca_full$li[,2], pca_full$li[,3],
     col=colors_full, pch=pch_cluster_full,
     xlab=paste("PC2:",AXE2_full,"%"),
     ylab=paste("PC3:",AXE3_full,"%"),
     main="PCA: PC2 vs PC3 (Unfiltered)")

plot(variance_full, type="b", pch=19,
     xlab="Principal Components",
     ylab="Percentage of Variance Explained",
     main="Scree Plot for PCA (Unfiltered)")

pdf("PCA_Results_Unfiltered.pdf")
plot(pca_full$li[,1], pca_full$li[,2],
     col=colors_full, pch=pch_cluster_full,
     xlab=paste("PC1:",AXE1_full,"%"),
     ylab=paste("PC2:",AXE2_full,"%"),
     main="PC1 vs PC2 (Unfiltered)")
plot(pca_full$li[,1], pca_full$li[,3],
     col=colors_full, pch=pch_cluster_full,
     xlab=paste("PC1:",AXE1_full,"%"),
     ylab=paste("PC3:",AXE3_full,"%"),
     main="PC1 vs PC3 (Unfiltered)")
plot(pca_full$li[,2], pca_full$li[,3],
     col=colors_full, pch=pch_cluster_full,
     xlab=paste("PC2:",AXE2_full,"%"),
     ylab=paste("PC3:",AXE3_full,"%"),
     main="PC2 vs PC3 (Unfiltered)")
plot(variance_full, type="b", pch=19,
     xlab="Principal Components", ylab="Percentage of Variance Explained",
     main="Scree Plot (Unfiltered)")
dev.off()

metadata_no_ku_bs <- metadata %>% filter(!(site_id %in% c("ku_sp","bs_sp")))
geno_data_no_ku_bs <- geno_data %>% filter(sample_id %in% metadata_no_ku_bs$sample_id)
geno_cleaned_no_ku_bs <- geno_data_no_ku_bs[, -(1:2)]
geno_cleaned_no_ku_bs[geno_cleaned_no_ku_bs == -9] <- NA
obj_no_ku_bs <- df2genind(geno_cleaned_no_ku_bs, ploidy=2, sep="\t", ncode=3)
pop(obj_no_ku_bs) <- metadata_no_ku_bs$type
colors_no_ku_bs <- metadata_no_ku_bs$color
pch_cluster_no_ku_bs <- ifelse(metadata_no_ku_bs$type=="sp",19,17)
geno_imputed_no_ku_bs <- scaleGen(obj_no_ku_bs,NA.method="mean")
pca_no_ku_bs <- dudi.pca(geno_imputed_no_ku_bs, scannf=FALSE, scale=TRUE, nf=3)
variance_no_ku_bs <- 100*(pca_no_ku_bs$eig/sum(pca_no_ku_bs$eig))
AXE1_no_ku_bs <- round(variance_no_ku_bs[1],2)
AXE2_no_ku_bs <- round(variance_no_ku_bs[2],2)
AXE3_no_ku_bs <- round(variance_no_ku_bs[3],2)
cat("PCA (no ku_sp, no bs_sp):\n")
cat(paste("PC1:",AXE1_no_ku_bs,"%\n"))
cat(paste("PC2:",AXE2_no_ku_bs,"%\n"))
cat(paste("PC3:",AXE3_no_ku_bs,"%\n"))
pca_data_no_ku_bs <- data.frame(PC1=pca_no_ku_bs$li[,1],PC2=pca_no_ku_bs$li[,2],PC3=pca_no_ku_bs$li[,3],color=colors_no_ku_bs,type=metadata_no_ku_bs$type)
plot_ly(pca_data_no_ku_bs, x=~PC1,y=~PC2,z=~PC3,type="scatter3d",mode="markers",color=~color,symbol=~type,marker=list(size=5)) %>% layout(title="3D PCA Plot (No ku_sp, No bs_sp)",scene=list(xaxis=list(title=paste("PC1:",AXE1_no_ku_bs,"%")),yaxis=list(title=paste("PC2:",AXE2_no_ku_bs,"%")),zaxis=list(title=paste("PC3:",AXE3_no_ku_bs,"%"))))
plot(pca_no_ku_bs$li[,1],pca_no_ku_bs$li[,2],col=colors_no_ku_bs,pch=pch_cluster_no_ku_bs,xlab=paste("PC1:",AXE1_no_ku_bs,"%"),ylab=paste("PC2:",AXE2_no_ku_bs,"%"),main="PCA: PC1 vs PC2 (No ku_sp, No bs_sp)")
plot(pca_no_ku_bs$li[,1],pca_no_ku_bs$li[,3],col=colors_no_ku_bs,pch=pch_cluster_no_ku_bs,xlab=paste("PC1:",AXE1_no_ku_bs,"%"),ylab=paste("PC3:",AXE3_no_ku_bs,"%"),main="PCA: PC1 vs PC3 (No ku_sp, No bs_sp)")
plot(pca_no_ku_bs$li[,2],pca_no_ku_bs$li[,3],col=colors_no_ku_bs,pch=pch_cluster_no_ku_bs,xlab=paste("PC2:",AXE2_no_ku_bs,"%"),ylab=paste("PC3:",AXE3_no_ku_bs,"%"),main="PCA: PC2 vs PC3 (No ku_sp, No bs_sp)")
plot(variance_no_ku_bs,type="b",pch=19,xlab="Principal Components",ylab="Percentage of Variance Explained",main="Scree Plot (No ku_sp, No bs_sp)")
pdf("PCA_Results_No_ku_bs.pdf")
plot(pca_no_ku_bs$li[,1],pca_no_ku_bs$li[,2],col=colors_no_ku_bs,pch=pch_cluster_no_ku_bs,xlab=paste("PC1:",AXE1_no_ku_bs,"%"),ylab=paste("PC2:",AXE2_no_ku_bs,"%"),main="PC1 vs PC2 (No ku_sp, No bs_sp)")
plot(pca_no_ku_bs$li[,1],pca_no_ku_bs$li[,3],col=colors_no_ku_bs,pch=pch_cluster_no_ku_bs,xlab=paste("PC1:",AXE1_no_ku_bs,"%"),ylab=paste("PC3:",AXE3_no_ku_bs,"%"),main="PC1 vs PC3 (No ku_sp, No bs_sp)")
plot(pca_no_ku_bs$li[,2],pca_no_ku_bs$li[,3],col=colors_no_ku_bs,pch=pch_cluster_no_ku_bs,xlab=paste("PC2:",AXE2_no_ku_bs,"%"),ylab=paste("PC3:",AXE3_no_ku_bs,"%"),main="PC2 vs PC3 (No ku_sp, No bs_sp)")
plot(variance_no_ku_bs,type="b",pch=19,xlab="Principal Components",ylab="Variance Explained",main="Scree Plot (No ku_sp, No bs_sp)")
dev.off()
write.table(metadata_no_ku_bs,file="filtered_metadata_no_ku_bs.csv",sep="\t",row.names=FALSE)

metadata_no_ku <- metadata %>% filter(site_id!="ku_sp")
geno_data_no_ku <- geno_data %>% filter(sample_id %in% metadata_no_ku$sample_id)
geno_cleaned_no_ku <- geno_data_no_ku[, -(1:2)]; geno_cleaned_no_ku[geno_cleaned_no_ku==-9]<-NA
obj_no_ku <- df2genind(geno_cleaned_no_ku,ploidy=2,sep="\t",ncode=3)
pop(obj_no_ku) <- metadata_no_ku$type
colors_no_ku <- metadata_no_ku$color
pch_cluster_no_ku <- ifelse(metadata_no_ku$type=="sp",19,17)
geno_imputed_no_ku <- scaleGen(obj_no_ku,NA.method="mean")
pca_no_ku <- dudi.pca(geno_imputed_no_ku,scannf=FALSE,scale=TRUE,nf=3)
variance_no_ku <- 100*(pca_no_ku$eig/sum(pca_no_ku$eig))
AXE1_no_ku <- round(variance_no_ku[1],2); AXE2_no_ku <- round(variance_no_ku[2],2); AXE3_no_ku <- round(variance_no_ku[3],2)
pca_data_no_ku <- data.frame(PC1=pca_no_ku$li[,1],PC2=pca_no_ku$li[,2],PC3=pca_no_ku$li[,3],color=colors_no_ku,type=metadata_no_ku$type)
plot_ly(pca_data_no_ku,x=~PC1,y=~PC2,z=~PC3,type="scatter3d",mode="markers",color=~color,symbol=~type,marker=list(size=5))%>%layout(title="3D PCA Plot (No ku_sp)",scene=list(xaxis=list(title=paste("PC1:",AXE1_no_ku,"%")),yaxis=list(title=paste("PC2:",AXE2_no_ku,"%")),zaxis=list(title=paste("PC3:",AXE3_no_ku,"%"))))
plot(pca_no_ku$li[,1],pca_no_ku$li[,2],col=colors_no_ku,pch=pch_cluster_no_ku,xlab=paste("PC1:",AXE1_no_ku,"%"),ylab=paste("PC2:",AXE2_no_ku,"%"),main="PC1 vs PC2 (No ku_sp)")
plot(pca_no_ku$li[,1],pca_no_ku$li[,3],col=colors_no_ku,pch=pch_cluster_no_ku,xlab=paste("PC1:",AXE1_no_ku,"%"),ylab=paste("PC3:",AXE3_no_ku,"%"),main="PC1 vs PC3 (No ku_sp)")
plot(pca_no_ku$li[,2],pca_no_ku$li[,3],col=colors_no_ku,pch=pch_cluster_no_ku,xlab=paste("PC2:",AXE2_no_ku,"%"),ylab=paste("PC3:",AXE3_no_ku,"%"),main="PC2 vs PC3 (No ku_sp)")
plot(variance_no_ku,type="b",pch=19,xlab="Principal Components",ylab="Percentage of Variance Explained",main="Scree Plot (No ku_sp)")
pdf("PCA_Results_No_ku.pdf")
plot(pca_no_ku$li[,1],pca_no_ku$li[,2],col=colors_no_ku,pch=pch_cluster_no_ku,xlab=paste("PC1:",AXE1_no_ku,"%"),ylab=paste("PC2:",AXE2_no_ku,"%"),main="PC1 vs PC2 (No ku_sp)")
plot(pca_no_ku$li[,1],pca_no_ku$li[,3],col=colors_no_ku,pch=pch_cluster_no_ku,xlab=paste("PC1:",AXE1_no_ku,"%"),ylab=paste("PC3:",AXE3_no_ku,"%"),main="PC1 vs PC3 (No ku_sp)")
plot(pca_no_ku$li[,2],pca_no_ku$li[,3],col=colors_no_ku,pch=pch_cluster_no_ku,xlab=paste("PC2:",AXE2_no_ku,"%"),ylab=paste("PC3:",AXE3_no_ku,"%"),main="PC2 vs PC3 (No ku_sp)")
plot(variance_no_ku,type="b",pch=19,xlab="Principal Components",ylab="Variance Explained",main="Scree Plot (No ku_sp)")
dev.off()
write.table(metadata_no_ku,file="filtered_metadata_no_ku.csv",sep="\t",row.names=FALSE)

metadata_no_bs <- metadata %>% filter(site_id!="bs_sp")
geno_data_no_bs <- geno_data %>% filter(sample_id %in% metadata_no_bs$sample_id)
geno_cleaned_no_bs <- geno_data_no_bs[, -(1:2)]; geno_cleaned_no_bs[geno_cleaned_no_bs==-9]<-NA
obj_no_bs <- df2genind(geno_cleaned_no_bs,ploidy=2,sep="\t",ncode=3)
pop(obj_no_bs) <- metadata_no_bs$type
colors_no_bs <- metadata_no_bs$color
pch_cluster_no_bs <- ifelse(metadata_no_bs$type=="sp",19,17)
geno_imputed_no_bs <- scaleGen(obj_no_bs,NA.method="mean")
pca_no_bs <- dudi.pca(geno_imputed_no_bs,scannf=FALSE,scale=TRUE,nf=3)
variance_no_bs <- 100*(pca_no_bs$eig/sum(pca_no_bs$eig))
AXE1_no_bs <- round(variance_no_bs[1],2); AXE2_no_bs <- round(variance_no_bs[2],2); AXE3_no_bs <- round(variance_no_bs[3],2)
pca_data_no_bs <- data.frame(PC1=pca_no_bs$li[,1],PC2=pca_no_bs$li[,2],PC3=pca_no_bs$li[,3],color=colors_no_bs,type=metadata_no_bs$type)
plot_ly(pca_data_no_bs,x=~PC1,y=~PC2,z=~PC3,type="scatter3d",mode="markers",color=~color,symbol=~type,marker=list(size=5))%>%layout(title="3D PCA Plot (No bs_sp)",scene=list(xaxis=list(title=paste("PC1:",AXE1_no_bs,"%")),yaxis=list(title=paste("PC2:",AXE2_no_bs,"%")),zaxis=list(title=paste("PC3:",AXE3_no_bs,"%"))))
plot(pca_no_bs$li[,1],pca_no_bs$li[,2],col=colors_no_bs,pch=pch_cluster_no_bs,xlab=paste("PC1:",AXE1_no_bs,"%"),ylab=paste("PC2:",AXE2_no_bs,"%"),main="PC1 vs PC2 (No bs_sp)")
plot(pca_no_bs$li[,1],pca_no_bs$li[,3],col=colors_no_bs,pch=pch_cluster_no_bs,xlab=paste("PC1:",AXE1_no_bs,"%"),ylab=paste("PC3:",AXE3_no_bs,"%"),main="PC1 vs PC3 (No bs_sp)")
plot(pca_no_bs$li[,2],pca_no_bs$li[,3],col=colors_no_bs,pch=pch_cluster_no_bs,xlab=paste("PC2:",AXE2_no_bs,"%"),ylab=paste("PC3:",AXE3_no_bs,"%"),main="PC2 vs PC3 (No bs_sp)")
plot(variance_no_bs,type="b",pch=19,xlab="Principal Components",ylab="Percentage of Variance Explained",main="Scree Plot (No bs_sp)")
pdf("PCA_Results_No_bs.pdf")
plot(pca_no_bs$li[,1],pca_no_bs$li[,2],col=colors_no_bs,pch=pch_cluster_no_bs,xlab=paste("PC1:",AXE1_no_bs,"%"),ylab=paste("PC2:",AXE2_no_bs,"%"),main="PC1 vs PC2 (No bs_sp)")
plot(pca_no_bs$li[,1],pca_no_bs$li[,3],col=colors_no_bs,pch=pch_cluster_no_bs,xlab=paste("PC1:",AXE1_no_bs,"%"),ylab=paste("PC3:",AXE3_no_bs,"%"),main="PC1 vs PC3 (No bs_sp)")
plot(pca_no_bs$li[,2],pca_no_bs$li[,3],col=colors_no_bs,pch=pch_cluster_no_bs,xlab=paste("PC2:",AXE2_no_bs,"%"),ylab=paste("PC3:",AXE3_no_bs,"%"),main="PC2 vs PC3 (No bs_sp)")
plot(variance_no_bs,type="b",pch=19,xlab="Principal Components",ylab="Variance Explained",main="Scree Plot (No bs_sp)")
dev.off()
write.table(metadata_no_bs,file="filtered_metadata_no_bs.csv",sep="\t",row.names=FALSE)