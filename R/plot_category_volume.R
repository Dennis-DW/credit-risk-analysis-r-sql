#Setup Folder and Connection
dir.create("presentation_plots", showWarnings = FALSE)
conn <- dbConnect(RSQLite::SQLite(), "pezesha_data.db")

#Get Data
query <- "
SELECT 
    CASE 
        WHEN category IS NULL OR category = '' THEN 'Unclassified' 
        ELSE category 
    END as category_clean,
    SUM(amount) as total_volume
FROM transactions
GROUP BY 1
ORDER BY total_volume DESC
"
df_cat <- dbGetQuery(conn, query)

#Create Bar Chart
plot <- ggplot(df_cat, aes(x = reorder(category_clean, total_volume), y = total_volume)) +
  geom_col(fill = "#2C3E50", width = 0.7) + 
  # Add text labels at the end of bars
  geom_text(aes(label = format(round(total_volume, 0), big.mark = ",")), 
            hjust = -0.1, size = 3.5) + 
  coord_flip() + 
  labs(
    title = "Total Transaction Volume by Category",
    subtitle = "Note: 'Unclassified' represents transactions with missing category data",
    x = NULL, 
    y = "Total Amount (KES)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "#E74C3C", size = 10, face = "italic"), # Red subtitle to highlight the data quality note
    panel.grid.major.y = element_blank(), 
    axis.text.y = element_text(size = 11, color = "black"),
    axis.text.x = element_text(color = "grey40")
  ) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.15)))

# 4. Save to Folder
print(plot)
ggsave("presentation_plots/2_volume_bar.png", plot, width = 8, height = 6)

# 5. Close Connection
dbDisconnect(conn)