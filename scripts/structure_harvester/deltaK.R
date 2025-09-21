# delta_k_analysis.R

setwd("/Users/sanzhar/Desktop/Eco_Lab/analysis_v2/structure_harvester")
evanno_data     <- read.table("EvannoTableOutput.txt", header=TRUE, stringsAsFactors=FALSE)
evanno_filtered <- subset(evanno_data, !is.na(DeltaK))

plot(evanno_filtered$K,
     evanno_filtered$DeltaK,
     type="b",
     pch=19,
     xlab="K",
     ylab=expression(Delta*K),
     main="Delta K vs K")

library(ggplot2)

plot_evanno <- ggplot(evanno_filtered, aes(x=K, y=DeltaK)) +
  geom_line() +
  geom_point(size=3) +
  theme_minimal() +
  labs(
    title="Evanno's Delta K for Full Dataset",
    x="K",
    y="Delta K"
  )

print(plot_evanno)

ggsave(
  filename="delta_k_plot.jpeg",
  plot=plot_evanno,
  width=8,
  height=6,
  dpi=600,
  device="jpeg"
)