#Setup Folder and Connection
dir.create("presentation_plots", showWarnings = FALSE)
conn <- dbConnect(RSQLite::SQLite(), "pezesha_data.db")

#Get Data
query <- "
SELECT 
    CASE WHEN t.category IS NULL OR category = ''THEN 'Unclassified' ELSE t.category END as category,
    AVG(u.default_flag) * 100 as default_rate
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY 1
ORDER BY default_rate ASC
"
df_risk <- dbGetQuery(conn, query)

#Create Lollipop Chart
plot <- ggplot(df_risk, aes(x = reorder(category, default_rate), y = default_rate)) +
  geom_segment(aes(x=reorder(category, default_rate), xend=category, y=0, yend=default_rate), color="grey") +
  geom_point(aes(color = default_rate), size=5) + 
  scale_color_gradient(low = "#3498DB", high = "#C0392B") + 
  coord_flip() + 
  labs(
    title = "Risk Ranking by Category",
    subtitle = "Red indicates categories with the highest default rates",
    # ADDED CAPTION HERE
    caption = "Note: 'Unclassified' refers to transactions with missing category information",
    x = "",
    y = "Default Rate (%)",
    color = "Risk Level"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.caption = element_text(size = 10, color = "grey40", face = "italic"), 
    panel.grid.major.y = element_blank() 
  )

# 4. Save
print(plot)
ggsave("presentation_plots/3_risk_lollipop.png", plot, width = 8, height = 6)
dbDisconnect(conn)