setwd("/Users/sanzhar/Desktop")

cluster_colors <- c(
  "Cluster1" = "#E69F00",
  "Cluster2" = "#56B4E9",
  "Cluster3" = "#009E73",
  "Cluster4" = "#CC79A7",
  "grey"     = "#999999"
)

library(dplyr)
library(ggplot2)

threshold <- 0.75

metadata <- read.csv("samples_metadata.csv", stringsAsFactors = FALSE)
head(metadata)

samples    <- metadata$sample_id
qdf_values <- read.table("k4.q", header = FALSE, stringsAsFactors = FALSE)

colnames(qdf_values) <- c("Cluster1", "Cluster2", "Cluster3", "Cluster4")
qdf <- cbind(sample_id = samples, qdf_values)

if (nrow(qdf) != nrow(metadata)) {
  stop("Number of individuals in qdf and metadata do not match!")
}

cluster_cols <- c("Cluster1", "Cluster2", "Cluster3", "Cluster4")

assignment_df <- qdf %>%
  rowwise() %>%
  mutate(
    max_membership = max(c_across(all_of(cluster_cols))),
    max_cluster    = cluster_cols[which.max(c_across(all_of(cluster_cols)))]
  ) %>%
  ungroup() %>%
  mutate(
    assigned_group = ifelse(max_membership >= threshold, max_cluster, "grey")
  )

assignment_df$color <- cluster_colors[assignment_df$assigned_group]

write.csv(assignment_df, "K4_assignments.csv", row.names = FALSE)

ggplot(assignment_df, aes(x = max_membership, fill = assigned_group)) +
  geom_histogram(binwidth = 0.05, color = "black") +
  scale_fill_manual(values = cluster_colors) +
  theme_minimal() +
  labs(
    title = "Distribution of Max Membership Coefficients (K=4)",
    x     = "Max Membership Coefficient",
    y     = "Count",
    fill  = "Assigned Group"
  ) +
  theme(legend.position = "bottom")