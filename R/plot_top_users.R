#Setup Folder and Connection
dir.create("presentation_plots", showWarnings = FALSE)
conn <- dbConnect(RSQLite::SQLite(), "pezesha_data.db")

#Top Users Query
query <- "
SELECT
    user_id,
    COUNT(transaction_id) as transaction_count
FROM
    transactions t
GROUP BY
    user_id
ORDER BY
    transaction_count DESC
LIMIT 5
"
df_top <- dbGetQuery(conn, query)

#Process Data for Coloring
#Convert user_id to Factor to keep the sorted order in the chart
df_top$user_id <- factor(df_top$user_id, levels = df_top$user_id[order(df_top$transaction_count)])

# Use simple row numbers (1, 2, 3...) to guarantee ranks work even if there are ties
df_top$simple_rank <- 1:nrow(df_top)

df_top$color_group <- case_when(
  df_top$simple_rank == 1 ~ "1st Place",
  df_top$simple_rank == 2 ~ "2nd Place",
  df_top$simple_rank == 3 ~ "3rd Place",
  TRUE ~ "Top 5 Runners-up"
)

#Define the order so the Legend looks logical (1st, 2nd, 3rd, Others)
df_top$color_group <- factor(df_top$color_group, 
                             levels = c("1st Place", "2nd Place", "3rd Place", "Top 5 Runners-up"))

#Create Ranked Bar Chart
plot <- ggplot(df_top, aes(x = user_id, y = transaction_count, fill = color_group)) +
  geom_col(width = 0.7) + 
  
  # Explicitly map the colors
  scale_fill_manual(values = c(
    "1st Place" = "#F1C40F",       # Gold
    "2nd Place" = "#95A5A6",       # Silver (Made slightly darker for visibility)
    "3rd Place" = "#D35400",       # Bronze
    "Top 5 Runners-up" = "#2C3E50" # Dark Blue
  )) +
  
  #labels inside the bars
  geom_text(aes(label = transaction_count), hjust = 1.5, color = "white", fontface = "bold") +
  
  coord_flip() + 
  labs(
    title = "Top 5 Most Active Users",
    subtitle = "Users with the highest transaction frequency",
    x = "User ID",
    y = "Number of Transactions",
    fill = "Rank"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    legend.position = "bottom", 
    panel.grid.major.y = element_blank()
  )

# 5. Save
print(plot)
ggsave("presentation_plots/6_top_users_ranked.png", plot, width = 8, height = 6)

# 6. Close Connection
dbDisconnect(conn)