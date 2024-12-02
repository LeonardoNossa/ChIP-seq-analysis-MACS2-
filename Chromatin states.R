library(ggplot2)
library(forcats)
library(dplyr)  # Per manipolare i dati

# Leggi i dati
a <- read.table("Desktop/chromatin_states_summit")

# Calcola i conteggi e le percentuali
data_summary <- a %>%
  count(V9) %>%
  mutate(perc = n / sum(n) * 100)

# Visualizza il grafico con spazio extra
ggplot(data_summary, aes(x = fct_reorder(V9, n, .desc = TRUE), y = n)) + 
  geom_bar(stat = "identity", fill = "lightgreen", color = "black") +
  geom_text(aes(label = paste0(round(perc, 1), "%")), 
            vjust = -0.5, size = 3.5) +  # Percentuali sopra le barre
  labs(x = "Categories", y = "Count") +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.line = element_line()) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))  # Spazio extra sopra




