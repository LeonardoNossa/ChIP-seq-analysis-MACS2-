# Load necessary libraries
library(ggplot2)
library(stringr)
# Load data
file_path <- "Downloads/20241125-public-4.0.4-QoVsjN-hg38-all-gene.txt"
data <- read.table(file_path, sep = "\t", header = FALSE, comment.char = "#", col.names = c("Gene", "Info"))

# Extract numeric positions from the 'Info' column
data$Positions <- lapply(str_extract_all(data$Info, "[+-]\\d+"), as.numeric)

# Flatten the positions into a single vector
positions <- unlist(data$Positions)

# Definisci intervalli e label (includendo estremi)
breaks <- c(-Inf, -30000, -1000, 0, 1000, 30000, Inf)
labels <- c("< -30000", "-30000 to -1000", "-1000 to 0", "0 to 1000", "1000 to 30000", "> 30000")

# Categorizza le posizioni nei nuovi intervalli
intervals <- cut(positions, breaks = breaks, labels = labels, right = FALSE)
interval_counts <- as.data.frame(table(intervals))

# Grafico aggiornato
ggplot(interval_counts, aes(x = intervals, y = Freq, fill = intervals)) +
  geom_bar(stat = "identity", color = "black") +
  scale_fill_manual(values = c("white", "green", "darkgreen", "darkgreen", "lightgreen", "white")) +
  labs(title = "Distribution of Positions Across Intervals",
       x = "Position Ranges",
       y = "Count") +
  theme_minimal() +
  theme(axis.line = element_line())+
  scale_y_continuous(expand = expansion(mult = c(0, 0)))





# Flatten the positions into a single vector
positions <- unlist(data$Positions)

# Categorize positions
Categories <- sapply(positions, function(pos) {
  if (pos >= -1000 & pos <= 1000) {
    return("Promoter")
  } else if ((pos >= -30000 & pos < -1000) | (pos > 1000 & pos <= 30000)) {
    return("Distal Regulatory Region")
  } else {
    return("Other")
  }
})

# Count occurrences of each category
category_counts <- as.data.frame(table(Categories))

# Reorder categories
category_counts$categories <- factor(category_counts$categories, levels = c("Promoter", "Distal Regulatory Region", "Other"))

# Plot the barplot
ggplot(category_counts, aes(x = Categories, y = Freq, fill = Categories)) +
  geom_bar(stat = "identity", color = "black") +
  scale_fill_manual(values = c("lightgreen", "darkgreen")) +
  labs(x = "Regions",
       y = "Count") +
  theme_minimal() +
  theme(axis.line = element_line()) +
  scale_y_continuous(expand = expansion(mult = c(0, 0)))

x = fct_infreq(V9))
