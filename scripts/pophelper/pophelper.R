# pophelper.R

# 1. Install and load required packages
# install.packages(c("pophelper","ggplot2","maps","mapdata","sf","cowplot","dplyr","tidyr","ggforce"))
library(pophelper)
library(ggplot2)
library(maps)
library(mapdata)
library(sf)
library(cowplot)
library(dplyr)
library(tidyr)
library(ggforce)

# 2. Set working directory and load Q files
setwd("/Users/sanzhar/Desktop/Eco Lab/organized_analysis/pophelper")
qfiles <- list.files(pattern="k[2-7]\\.q$")
qlist  <- readQ(qfiles)

# 3. Load and check metadata
metadata      <- read.csv("samples_metadata.csv", stringsAsFactors=FALSE)
samples       <- metadata$sample_id
lat           <- metadata$latitude
lon           <- metadata$longitude
population    <- metadata$site_id
site_number   <- metadata$site_number

if(nrow(metadata) != nrow(qlist[[1]])) {
  stop("Number of samples in metadata does not match Q files!")
}

# 4. Generate barplots for each K
accessible_colors <- c(
  "Cluster1"="#E69F00", "Cluster2"="#56B4E9",
  "Cluster3"="#009E73", "Cluster4"="#CC79A7",
  "grey"     ="#999999"
)

for(qname in names(qlist)) {
  kvalue <- sub("\\.q$", "", qname)
  qdf    <- qlist[[qname]]
  qdf$sample_id   <- samples
  qdf$site_id     <- population
  qdf$site_number <- site_number
  
  cluster_cols <- grep("Cluster", names(qdf), value=TRUE)
  
  qdf_long <- qdf %>%
    pivot_longer(cols = all_of(cluster_cols),
                 names_to = "Cluster",
                 values_to = "Proportion")
  
  max_site_num <- max(qdf_long$site_number, na.rm=TRUE)
  qdf_long$site_number <- factor(
    qdf_long$site_number,
    levels = rev(seq_len(max_site_num))
  )
  
  barplot_gg <- ggplot(qdf_long, aes(x=sample_id, y=Proportion, fill=Cluster)) +
    geom_bar(stat="identity", position="stack") +
    facet_grid(. ~ site_number, scales="free_x", space="free_x") +
    theme_bw() +
    theme(
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      panel.spacing=unit(0, "lines"),
      legend.position="bottom"
    ) +
    scale_fill_manual(values=accessible_colors) +
    ggtitle(paste("Admixture Barplot for", toupper(kvalue), "- By Site Number"))
  
  ggsave(paste0(kvalue, "_barplot.pdf"),
         barplot_gg, width=12, height=6, dpi=300)
}

# 5. Generate pie-chart maps for all K values
focus_xlim <- c(-20, 60)
focus_ylim <- c(0, 60)

plot_pie_map_for_k <- function(kvalue) {
  qdf <- qlist[[paste0(kvalue, ".q")]]
  qdf$sample_id <- samples
  qdf$site_id   <- population
  qdf$latitude  <- lat
  qdf$longitude <- lon
  
  cluster_cols <- grep("Cluster", names(qdf), value=TRUE)
  
  qdf_long <- qdf %>%
    pivot_longer(cols = all_of(cluster_cols),
                 names_to = "Cluster",
                 values_to = "Proportion")
  
  qdf_site_summary <- qdf_long %>%
    group_by(site_id, latitude, longitude, Cluster) %>%
    summarise(mean_prop = mean(Proportion), .groups="drop")
  
  qdf_pies <- qdf_site_summary %>%
    group_by(site_id, latitude, longitude) %>%
    arrange(Cluster) %>%
    mutate(
      cumulative  = cumsum(mean_prop),
      angle_start = lag(cumulative, default=0),
      angle_end   = cumulative
    ) %>%
    ungroup()
  
  pie_radius  <- 1
  world_map   <- map_data("world")
  country_centers <- world_map %>%
    group_by(region) %>%
    summarise(long = mean(range(long)), lat = mean(range(lat)))
  
  map_pie_plot <- ggplot() +
    geom_polygon(
      data = world_map,
      aes(x=long, y=lat, group=group),
      fill="white", color="black"
    ) +
    geom_arc_bar(
      data = qdf_pies,
      aes(
        x0 = longitude, y0 = latitude,
        r  = pie_radius, r0 = 0,
        start = angle_start*2*pi,
        end   = angle_end*2*pi,
        fill  = Cluster
      ),
      color="black", size=0.2, alpha=0.8
    ) +
    scale_fill_manual(values=accessible_colors) +
    geom_text(
      data = country_centers,
      aes(x=long, y=lat, label=region),
      size=2
    ) +
    coord_sf(xlim = focus_xlim, ylim = focus_ylim, expand = FALSE) +
    theme_minimal() +
    theme(legend.position="bottom") +
    ggtitle(paste("Map of Mean Admixture Proportions for", toupper(kvalue)))
  
  ggsave(
    paste0(kvalue, "_pie_map_with_country_names.pdf"),
    map_pie_plot, width=12, height=8, dpi=300
  )
}

k_values <- sub("\\.q$", "", names(qlist))
for(k in k_values) {
  plot_pie_map_for_k(k)
}