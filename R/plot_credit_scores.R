#Setup Folder and Connection
dir.create("presentation_plots", showWarnings = FALSE)
conn <- dbConnect(RSQLite::SQLite(), "pezesha_data.db")

# 2. Get Data
query <- "
SELECT 
    user_id, 
    credit_score, 
    CASE WHEN default_flag = 1 THEN 'Defaulter' ELSE 'Good Standing' END as status
FROM users
"
df_scores <- dbGetQuery(conn, query)

#Create Density Plot
plot <- ggplot(df_scores, aes(x = credit_score, fill = status)) +
  geom_density(alpha = 0.6, color = NA) + # 'alpha' makes it see-through
  scale_fill_manual(values = c("Defaulter" = "#E74C3C", "Good Standing" = "#2ECC71")) +
  labs(
    title = "Credit Score Profiles",
    subtitle = "Defaulters (Red) are concentrated in lower score ranges",
    x = "Credit Score",
    y = "Density",
    fill = "User Status"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    legend.position = "top"
  )

# 4. Save
print(plot)
ggsave("presentation_plots/1_credit_score_density.png", plot, width = 8, height = 5)
dbDisconnect(conn)
